//
//  A1CommunicationKitRESTfulOperation.m
//  A1CommunicationKitAppKit
//
//  Created by Sergey Simonov on 30.11.10.
//  Copyright 2010 Sergey Simonov. All rights reserved.
//

#import "SelleryAppDelegate.h"
#import "SelleryAppRESTfulOperation.h"
#import "SelleryAppCommunicationKit.h"
#import "SelleryAppCommunicationKit+Requests.h"
#import "SelleryAppCommunicationKit+Response.h"
#import "SelleryAppCommunicationKit+Errors.h"


#define kSelleryAppIsOperationExecuting @"isExecuting"
#define kSelleryAppIsOperationFinished @"isFinished"

#define A1_SELF \
  SelleryAppRESTfulOperation

@implementation A1_SELF

#pragma mark -

- (void)finish;
{
  A1_AV (request);
  A1_ATV (URL, request);
  A1_ATV (absoluteURL, URL);
  A1_DLOG (@"Operation with request %@ has been finished", absoluteURL);
  
  [self willChangeValueForKey: kSelleryAppIsOperationExecuting];
  [self willChangeValueForKey: kSelleryAppIsOperationFinished];
  
  _isExecuting = NO;
  _isFinished = YES;
  
  [self didChangeValueForKey: kSelleryAppIsOperationExecuting];
  [self didChangeValueForKey: kSelleryAppIsOperationFinished];
}

#pragma mark -

- (void)connection: (NSURLConnection *)connection
didReceiveResponse: (NSURLResponse *)response;
{
  A1_DLOG_TAG_BEG;

  self.response = response;
  
  A1_ATV (expectedContentLength, response);
  if (expectedContentLength < 0)
  {
  }
  
  A1_DLOG_TAG_END;
}

- (void)connection: (NSURLConnection *)connection
    didReceiveData: (NSData *)data;
{
  A1_DLOG_TAG_BEG;

  A1_CHECK (nil != self.data);
  [self.data appendData: data];
  
  A1_DLOG_TAG_END;
}

- (void)onBeginRequest;
{
  A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));
  A1_ATV (communicationKit, appDelegate);
  
  A1_AV (request);
  A1_AV (contextInfo);
  
  [communicationKit onBeginRequest: request
                       contextInfo: contextInfo];
}

- (void)onEndRequest;
{
  A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));
  A1_ATV (communicationKit, appDelegate);

  A1_AV (request);
  A1_AV (contextInfo);
  
  [communicationKit onEndRequest: request
                     contextInfo: contextInfo];
}

- (void)processError: (NSError *)error;
{
  A1_CHECK (nil != error);
  
  A1_ATV (code, error);
  A1_ATV (userInfo, error);
  
  A1_DLOG (@"Received error: %d, %@", code, [userInfo objectForKey: NSLocalizedDescriptionKey]);
  
  A1_AV (contextInfo);
  
  A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));
  A1_ATV (communicationKit, appDelegate);
  
  [communicationKit requestDidFailWithError: error
                                contextInfo: contextInfo];
}

- (void)processResponse;
{
  A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));
  A1_ATV (communicationKit, appDelegate);
  
  A1_AV (contextInfo);
  A1_AV (data);
  
  A1_ATV (bytes, data);
  A1_CUSTOM_NV (NSString, message, initWithFormat: @"%s", bytes);
  A1_DLOG (@"Received response: %@", message);
  
  A1_AV (response);
  A1_ATV (statusCode, A1_KCAST (NSHTTPURLResponse, response));
  
  if (statusCode >= 400)
  {
    A1_V (error, [communicationKit makeRESTfulErrorFromDescription: message
                                                              code: statusCode]);
    
    [self processError: error];
  }
  else
  {
    [communicationKit requestDidFinishWithData: data
                                   contextInfo: contextInfo];
  }
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection;
{
  A1_DLOG_TAG_BEG;

  [self performSelectorOnMainThread: @selector (processResponse)
                         withObject: nil
                      waitUntilDone: YES];
  
  [self finish];
  
  A1_DLOG_TAG_END;
}

- (void)connection: (NSURLConnection *)connection didFailWithError: (NSError *)error;
{
  A1_DLOG_TAG_BEG;
  
  [self performSelectorOnMainThread: @selector (processError:)
                         withObject: error
                      waitUntilDone: YES];

  [self finish];
  
  A1_DLOG_TAG_END;
}

#pragma mark -

- (void)cancel;
{
  A1_AV (request);
  A1_ATV (URL, request);
  A1_ATV (absoluteURL, URL);
  A1_DLOG (@"Cancelling operation with request %@", absoluteURL);
  
  A1_AV (connection);
  [connection cancel];
  
  [self finish];
  
  [super cancel];
}

- (void)start;
{
  A1_ATV (isMainThread, NSThread);
  if (!isMainThread)
  {
    [self performSelectorOnMainThread: @selector (start)
                           withObject: nil
                        waitUntilDone: NO];

    return;
  }
  
  [self willChangeValueForKey: kSelleryAppIsOperationExecuting];
  _isExecuting = YES;
  [self didChangeValueForKey: kSelleryAppIsOperationFinished];
  
  A1_AV (request);
  A1_ATV (URL, request);
  A1_ATV (absoluteURL, URL);
  A1_DLOG (@"Scheduling operation with request %@", absoluteURL);

  [self performSelectorOnMainThread: @selector (onBeginRequest)
                         withObject: nil
                      waitUntilDone: YES];
  
  // Asyncronious connection
  A1_CUSTOM_NV (NSURLConnection, connection, initWithRequest: request
                                                    delegate: self);
  
  if (!connection)
  {
    A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));
    A1_ATV (communicationKit, appDelegate);

    A1_V (error, [communicationKit makeRESTfulErrorFromDescription: @"Internal error, unable to establish new connection. Please, try again later."
                                                              code: -1]);
    
    [self performSelectorOnMainThread: @selector (processError:)
                           withObject: error
                        waitUntilDone: YES];
    
    [self finish];
  }
  else
  {
    A1_NV (NSMutableData, data);
    
    self.data = data;
    self.connection = connection;
  }
  
  [self performSelectorOnMainThread: @selector (onEndRequest)
                         withObject: nil
                      waitUntilDone: YES];
}

#pragma mark -

- (id)initWithRequest: (NSMutableURLRequest *)request;
{
  self = [super init];
  
  if (self != nil)
  {
    A1_CHECK (nil != request);
    
    self.request = request;
  }
  
  return self;
}

#pragma mark -

A1_PP_SELF_SYNTHESIZE_AND_DEALLOC;

@end

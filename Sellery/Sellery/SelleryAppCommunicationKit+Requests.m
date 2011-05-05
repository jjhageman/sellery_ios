//
//  Requests.m
//  Sellery
//
//  Created by Sergey Simonov on 26.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryAppCommunicationKit+Requests.h"
#import "SelleryAppRESTfulOperation.h"
#import "CJSONDataSerializer.h"


@implementation SelleryAppCommunicationKit (Requests)

- (NSString *) stringByUrlEncoding: (NSString *)string;
{
	return (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)string,  NULL,  (CFStringRef)@":/?#[]@!$’ ()*+,;",  kCFStringEncodingUTF8);
}


#pragma mark -

- (void)queueRequest: (NSMutableURLRequest *)request
         contextInfo: (id)contextInfo;
{
  // Start request operation
  A1_CUSTOM_NV (SelleryAppRESTfulOperation, operation, initWithRequest: request);
  operation.contextInfo = contextInfo;
  
  A1_AV (queue);
  A1_ATV (operations, queue);
  A1_ATV (count, operations);
  if (count > 0)
  {
    A1_V (tailOperation, [operations objectAtIndex: --count]);
    [operation addDependency: tailOperation];
  }
  
  [queue addOperation: operation];
}

#pragma mark -

- (void)requestImageUpload: (UIImage *)image
               contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;
  
  A1_CHECK (image);
  
  A1_V (imageData, UIImageJPEGRepresentation (image, 0.7));
  
  NSString *boundary = @"----FOO";
  
  NSURL *url = [NSURL URLWithString:IMAGE_API_ENDPOINT];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url
                                                     cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval: 60.0f];
  [req setHTTPMethod:@"POST"];
  
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", boundary];
  [req setValue:contentType forHTTPHeaderField:@"Content-type"];
  
  //adding the body:
  NSMutableData *postBody = [NSMutableData data];
  [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[@"Content-Disposition: form-data; name= \"some_name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[@"some_value" dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", @"test.jpeg"] dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:imageData];
  [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[@"Content-Disposition: form-data; name= \"some_other_name\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[@"some_other_value" dataUsingEncoding:NSUTF8StringEncoding]];
  [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  [req setHTTPBody: postBody];
  
  [self queueRequest: req
         contextInfo: contextInfo];
    
  A1_DLOG_TAG_END;
}

- (void)requestItemUpload: (NSString *)email
                 provider: (NSString *)provider
                      uid: (NSString *)uid
                    token: (NSString *)token
                    title: (NSString *)title
              description: (NSString *)description
                    price: (NSString *)price
                  zipcode: (NSString *)zipcode
                 image_id: (NSString *)image_id
              contextInfo: (id)contextInfo;
{
  A1_DLOG_TAG_BEG;

  NSURL *url = [NSURL URLWithString: ITEM_API_ENDPOINT];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url
                                                     cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
                                                 timeoutInterval: 60.0f];
  [req setHTTPMethod: @"POST"];
  
#if 0
  A1_V (userObjects, A1_ARRAY (token, uid, provider, email));
  A1_V (userKeys, A1_ARRAY (@"token", @"uid", @"provider", @"email"));
#else
  A1_V (userObjects, A1_ARRAY (token, provider, email));
  A1_V (userKeys, A1_ARRAY (@"token", @"provider", @"email"));
#endif
#if 0
  A1_V (itemObjects, A1_ARRAY (title, description, price, zipcode));
  A1_V (itemKeys, A1_ARRAY (@"title", @"description", @"price", @"zipcode"));
#else
  A1_V (locationObjects, A1_ARRAY (@"0.0", @"0.0"));
  A1_V (locationKeys, A1_ARRAY (@"lat", @"lng"));
  A1_V (itemObjects, A1_ARRAY (title, description, price));
  A1_V (itemKeys, A1_ARRAY (@"title", @"description", @"price"));
#endif
  A1_V (itemObjectImage1, A1_ARRAY (image_id));
  A1_V (itemObjectKeys1, A1_ARRAY (@"image_id"));
  A1_V (itemImageCollection, A1_DICTIONARY_WITH_OBJECTS_FOR_KEYS (itemObjectImage1, itemObjectKeys1));
  A1_V (itemImage1, A1_ARRAY (itemImageCollection));
  A1_V (itemKeys1, A1_ARRAY (@"image_image1"));

  A1_V (user, A1_DICTIONARY_WITH_OBJECTS_FOR_KEYS (userObjects, userKeys));
  A1_V (item, A1_DICTIONARY_WITH_OBJECTS_FOR_KEYS (itemObjects, itemKeys));
  A1_V (location, A1_DICTIONARY_WITH_OBJECTS_FOR_KEYS (locationObjects, locationKeys));
  A1_V (images, A1_DICTIONARY_WITH_OBJECTS_FOR_KEYS (itemImage1, itemKeys1));
  
  A1_NV (NSMutableDictionary, post); // huh!

  [post setObject: user forKey: @"user"];
  [post setObject: location forKey: @"location"];
  [post setObject: item forKey: @"item"];
  [post setObject: images forKey: @"item_images"];
  
  A1_NV (NSMutableDictionary, itemPost); // huh!
  
  [itemPost setObject: post forKey: @"item_post"];
  
  A1_ATV (serializer, CJSONDataSerializer);
  A1_V (encoded, [serializer serializeDictionary: itemPost]);
  
  [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [req setValue: @"json" forHTTPHeaderField: @"Data-Type"];
  [req setValue:[NSString stringWithFormat: @"%d", [encoded length]] forHTTPHeaderField: @"Content-Length"];
  
  A1_CUSTOM_NV (NSString, stringPostBody, initWithData: encoded
                                              encoding: NSUTF8StringEncoding);
  A1_DLOG (@"Posting an item with request: %@", stringPostBody);


  [req setHTTPBody: encoded];
  
  [self queueRequest: req
         contextInfo: contextInfo];

  A1_DLOG_TAG_END;
}

#pragma mark -

- (void)cancelAllRequests;
{
  A1_AV (queue);
  
  [queue cancelAllOperations];
}

- (void)onBeginRequest: (NSMutableURLRequest *)request
           contextInfo: (id)contextInfo;
{
  A1_AV (RESTfulDelegate);
  A1_CHECK (nil != RESTfulDelegate);
  
  [RESTfulDelegate onBeginRequest: request
                      contextInfo: contextInfo];
}

- (void)onEndRequest: (NSMutableURLRequest *)request
         contextInfo: (id)contextInfo;
{
  A1_AV (RESTfulDelegate);
  A1_CHECK (nil != RESTfulDelegate);
  
  [RESTfulDelegate onEndRequest: request
                    contextInfo: contextInfo];
}

@end

//
//  SelleryAppDelegate+Facebook.m
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryAppDelegate+Facebook.h"
#import "SelleryViewController.h"


@implementation SelleryAppDelegate (Facebook)

- (void)login;
{
  [_facebook authorize:[NSArray arrayWithObjects:
                        @"read_stream", @"offline_access",nil]
              delegate:self];
}

- (void)logout;
{
  [_facebook logout:self];
}

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin;
{
  A1_DLOG_TAG_BEG;
  
  A1_AV (viewController);
  A1_ATV (fbLoginButton, viewController);
  fbLoginButton.isLoggedIn = YES;
  [fbLoginButton updateImage];
  
  [_facebook requestWithGraphPath: @"me" andDelegate: self]; //Attention!!!

  A1_DLOG_TAG_END;
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin: (BOOL)cancelled;
{
  A1_DLOG_TAG_BEG;

  A1_AV (viewController);
  A1_ATV (fbLoginButton, viewController);
  fbLoginButton.isLoggedIn = NO;
  [fbLoginButton updateImage];

  A1_DLOG_TAG_END;
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout;
{
  A1_DLOG_TAG_BEG;

  A1_AV (viewController);
  A1_ATV (fbLoginButton, viewController);
  fbLoginButton.isLoggedIn = YES;
  [fbLoginButton updateImage];

  A1_DLOG_TAG_END;
}

////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  A1_AV (facebook);
  return [facebook handleOpenURL: url];
}

#pragma mark

- (void)request: (FBRequest *)request
        didLoad: (id)result;
{
  if ([result isKindOfClass: [NSArray class]])
  {
    self.facebookResult = [result objectAtIndex: 0];
  }
  else
  {
    self.facebookResult = result;
  }
}

- (void) request: (FBRequest *)request
didFailWithError: (NSError *)error;
{
  A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                message: [error localizedDescription]
                delegate: self
                cancelButtonTitle: nil
                otherButtonTitles: @"OK", nil);
  [alertView show];
}

@end

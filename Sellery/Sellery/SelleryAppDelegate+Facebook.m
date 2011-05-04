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
  [_facebook authorize: [NSArray arrayWithObjects: @"email", @"read_stream", @"offline_access", nil]
              delegate: self];
}

- (void)logout;
{
  [_facebook logout: self];
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
  
  [_facebook requestWithGraphPath: @"me" andDelegate: self];
  
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

  A1_V (userDefaults, A1_USER_DEFAULTS)
  [userDefaults removeObjectForKey: @"id"];
  [userDefaults removeObjectForKey: @"accessToken"];

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
  fbLoginButton.isLoggedIn = NO;
  [fbLoginButton updateImage];

  A1_V (userDefaults, A1_USER_DEFAULTS)
  [userDefaults removeObjectForKey: @"id"];
  [userDefaults removeObjectForKey: @"accessToken"];

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
  A1_CUSTOM_NV (UIActionSheet, downloadingSheet, initWithTitle: @"Requesting Facebook data, please wait\n\n\n"
                delegate: nil
                cancelButtonTitle: nil
                destructiveButtonTitle: nil
                otherButtonTitles: nil);
  UIActivityIndicatorView *progressView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-12.4, -17, 25, 25)] autorelease];
  progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |  
                                   UIViewAutoresizingFlexibleRightMargin |  
                                   UIViewAutoresizingFlexibleTopMargin |  
                                   UIViewAutoresizingFlexibleBottomMargin);
  [downloadingSheet addSubview: progressView];
  [progressView startAnimating];
  [downloadingSheet showInView: self.viewController.view];
  
  self.downloadingSheet = downloadingSheet;

  A1_AV (facebook);
  return [facebook handleOpenURL: url];
}

#pragma mark

- (void)request: (FBRequest *)request
        didLoad: (id)result;
{
  A1_V (userDefaults, A1_USER_DEFAULTS);

  if ([result isKindOfClass: [NSArray class]])
  {
    self.facebookResult = [result objectAtIndex: 0];
  }
  else
  {
    self.facebookResult = result;
  }
  
  [userDefaults setObject: [self.facebookResult objectForKey: @"id"]
                   forKey: @"id"];
  
  A1_AV (facebook);
  A1_ATV (accessToken, facebook);
  [userDefaults setObject: accessToken
                   forKey: @"accessToken"];
  
  [userDefaults synchronize];
  
  [self.downloadingSheet dismissWithClickedButtonIndex: 0 animated: YES];
  self.downloadingSheet = nil;
}

- (void) request: (FBRequest *)request
didFailWithError: (NSError *)error;
{
  // Something goes wrong
  A1_AV (viewController);
  A1_ATV (fbLoginButton, viewController);
  fbLoginButton.isLoggedIn = NO;
  [fbLoginButton updateImage];
  
  A1_V (userDefaults, A1_USER_DEFAULTS)
  [userDefaults removeObjectForKey: @"id"];
  [userDefaults removeObjectForKey: @"accessToken"];

  [self.downloadingSheet dismissWithClickedButtonIndex: 0 animated: YES];
  self.downloadingSheet = nil;
  
  A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                                              message: [error localizedDescription]
                                             delegate: self
                                    cancelButtonTitle: nil
                                    otherButtonTitles: @"OK", nil);
  [alertView show];
}

@end

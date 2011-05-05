//
//  SelleryAppDelegate.m
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include <unistd.h>
#import "SelleryAppDelegate.h"
#import "SelleryAppDelegate+Facebook.h"
#import "SelleryAppDelegate+RESTfull.h"
#import "SelleryAppCommunicationKit.h"
#import "SelleryAppCommunicationKit+Requests.h"
#import "SelleryAppCommunicationKit+Response.h"
#import "SelleryAppCommunicationKit+Errors.h"
#import "SelleryViewController.h"

#import "SelleryViewController.h"

static NSString* kAppId = @"104504556303736";


#define A1_SELF \
  SelleryAppDelegate

@implementation A1_SELF

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application: (UIApplication *)application didFinishLaunchingWithOptions: (NSDictionary *)launchOptions
{
  sleep (3);
  
  // Override point for customization after application launch.
  A1_NV (SelleryAppCommunicationKit, communicationKit);
  self.communicationKit = communicationKit;
  communicationKit.RESTfulDelegate = self;
  
  A1_CUSTOM_NV (Facebook, facebook, initWithAppId: kAppId);
  self.facebook = facebook;
    
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)applicationWillResignActive: (UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground: (UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
  
  A1_ATV (date, NSDate);
  A1_ATV (timeIntervalSince1970, date);
  _shoutdownDate = timeIntervalSince1970;
}

- (void)applicationWillEnterForeground: (UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive: (UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
  A1_ATV (date, NSDate);
  A1_ATV (timeIntervalSince1970, date);

  if (_shoutdownDate > 0)
  {
    A1_V (result, timeIntervalSince1970 - _shoutdownDate);
    if (result > 600)
    {
      A1_V (vc, (SelleryViewController *)self.viewController);
      A1_ATV (state, vc);
      if (state != 0)
      {
        [vc moveToIp1];
      }
    }
  }
}

- (void)applicationWillTerminate: (UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

- (void)dealloc
{
  A1_DLOG_TAG_BEG;
  
  A1_PP_RELEASE_SELF_PROPS;
  
  A1_DLOG_TAG_END;
  
  [super dealloc];
}

#pragma mark -

A1_PP_SELF_SYNTHESIZE;
A1_PP_SELF_SYNTHESIZE_N;

@end

//
//  SelleryAppDelegate.h
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "A1Macros.h"
#import "FBConnect.h"
#import "SelleryAppCommunicationKit.h"
#import "SelleryAppRESTfulDelegate.h"


@class SelleryViewController;

#define SelleryAppDelegateF \
  ((communicationKit) ((nonatomic, retain)) ((SelleryAppCommunicationKit *))) \
  ((userName) ((nonatomic, retain)) ((NSString *))) \
  ((facebook) ((retain)) ((Facebook *))) \
  ((facebookResult) ((retain)) ((NSDictionary *))) \

#define SelleryAppDelegateNF \

@interface SelleryAppDelegate : NSObject <UIApplicationDelegate, SelleryAppRESTfulDelegate>
{
  A1_PP_PROP_IVARS (SelleryAppDelegateF);
  A1_PP_PROP_IVARS (SelleryAppDelegateNF);
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SelleryViewController *viewController;

A1_PP_PROPS (SelleryAppDelegateF);
A1_PP_PROPS (SelleryAppDelegateNF);

@end

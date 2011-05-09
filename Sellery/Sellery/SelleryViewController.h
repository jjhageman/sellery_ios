//
//  SelleryViewController.h
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "A1Macros.h"
#import "FBConnect.h"
#import "FBLoginButton.h"


#define SelleryViewControllerF \
  ((image) ((retain)) ((UIImage *))) \
  ((salary) ((retain)) ((NSString *))) \
  ((uploadingSheet) ((retain)) ((UIActionSheet *))) \
  ((imageUploadResponse) ((retain)) ((NSDictionary *))) \
  ((itemUploadResponse) ((retain)) ((NSDictionary *))) \
  ((menu) ((retain)) ((UIActionSheet *))) \
  ((alertView) ((retain)) ((UIAlertView *))) \

#define SelleryViewControllerNF \
  ((state) ((assign)) ((int))) \
  ((hasEnteredDescription) ((assign)) ((BOOL))) \
  ((selectingImage) ((assign)) ((BOOL))) \

@interface SelleryViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, UITextViewDelegate>
{
  UIView *_ip0;
  UIView *_ipInvisible;
  UIView *_ip1;
  IBOutlet UIView *_ip2;
  IBOutlet UIView *_ip3;
  IBOutlet UITextView *_textView;
  IBOutlet UITextField *_zip;
  IBOutlet UITextField *_email;
  IBOutlet FBLoginButton *_fbLoginButton;
  IBOutlet UIButton *_nextButton;
  IBOutlet UIButton *_selleryButton;
  UIImageView *_firstImageView;
  UIButton *_photo;
  UILabel *_price;
  
  A1_PP_PROP_IVARS (SelleryViewControllerF);
  A1_PP_PROP_IVARS (SelleryViewControllerNF);
}

@property (nonatomic, retain) IBOutlet UIButton *photo;
@property (nonatomic, retain) IBOutlet UIImageView *firstImageView;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) FBLoginButton *fbLoginButton;
@property (nonatomic, retain) IBOutlet UIView *ip0;
@property (nonatomic, retain) IBOutlet UIView *ip1;
@property (nonatomic, retain) IBOutlet UIView *ip2;
@property (nonatomic, retain) IBOutlet UIView *ipInvisible;
@property (nonatomic, retain) IBOutlet UIButton *selleryButton;

A1_PP_PROPS (SelleryViewControllerF);
A1_PP_PROPS (SelleryViewControllerNF);

- (IBAction)addPicture: (id)anObject;
- (IBAction)addPrice: (id)anObject;
- (IBAction)processToFirstScreen: (id)anObject;
- (IBAction)processToFirstScreenFromDescription: (id)anObject;
- (IBAction)processToDescription: (id)anObject;
- (IBAction)processToFinalScreen: (id)anObject;
- (IBAction)loginWithFacebook: (id)anObject;
- (IBAction)doneEditing: (id)sender;
- (IBAction)hideKeypad: (id)sender;

- (void)uploadFinished: (NSDictionary *)response;
- (void)networkError: (NSError *)error;
- (void)moveToIp1;
- (void)moveToIp1WithoutAnimations;
- (void)dismissIp0AndMoveToIp1FromSplashScreen;

@end

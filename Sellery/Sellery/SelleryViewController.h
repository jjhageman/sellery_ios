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

#define SelleryViewControllerNF \
  ((state) ((assign)) ((int))) \

@interface SelleryViewController : UIViewController <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
  IBOutlet UIView *_ip1;
  IBOutlet UIView *_ip2;
  IBOutlet UIView *_ip3;
  IBOutlet UITextView *_textView;
  IBOutlet UITextField *_zip;
  IBOutlet UITextField *_email;
  IBOutlet FBLoginButton *_fbLoginButton;
  IBOutlet UIButton *_nextButton;
  UIButton *_photo;
  UILabel *_price;
  
  A1_PP_PROP_IVARS (SelleryViewControllerF);
  A1_PP_PROP_IVARS (SelleryViewControllerNF);
}

@property (nonatomic, retain) IBOutlet UIButton *photo;
@property (nonatomic, retain) IBOutlet UILabel *price;
@property (nonatomic, retain) FBLoginButton *fbLoginButton;

A1_PP_PROPS (SelleryViewControllerF);
A1_PP_PROPS (SelleryViewControllerNF);

- (IBAction)addPicture: (id)anObject;
- (IBAction)addPrice: (id)anObject;
- (IBAction)processToFirstScreen: (id)anObject;
- (IBAction)processToDescription: (id)anObject;
- (IBAction)processToFinalScreen: (id)anObject;
- (IBAction)loginWithFacebook: (id)anObject;

- (void)uploadFinished: (NSDictionary *)response;
- (void)networkError: (NSError *)error;

@end

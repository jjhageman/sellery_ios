//
//  SelleryViewController.m
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryViewController.h"
#import "SelleryAppDelegate.h"
#import "SelleryAppCommunicationKit+Requests.h"
#import "SelleryAppDelegate+Facebook.h"
#import <QuartzCore/QuartzCore.h>


#define A1_SELF \
  SelleryViewController

@implementation A1_SELF

@synthesize photo = _photo;
@synthesize price = _price;
@synthesize fbLoginButton = _fbLoginButton;

#pragma mark -

- (IBAction)processToFinalScreen: (id)anObject;
{
  [_zip resignFirstResponder];
  [_email resignFirstResponder];
  
  A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));

  if (NSOrderedSame == [[_zip text] compare: @""
                                    options: NSLiteralSearch] ||
      NSOrderedSame == [[_email text] compare: @""
                                    options: NSLiteralSearch] ||
      NSOrderedSame == [[_textView text] compare: @""
                                    options: NSLiteralSearch] ||
      !_fbLoginButton.isLoggedIn || appDelegate.facebookResult == nil
      )
  {
    A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                  message: @"Please fill all fileds in the form and login with the Facebook to continue."
                  delegate: self
                  cancelButtonTitle: nil
                  otherButtonTitles: @"OK", nil);
    [alertView show];
  }
  else
  {
    A1_ATV (communicationKit, appDelegate);
    A1_ATV (facebookResult, appDelegate);
    A1_ATV (facebook, appDelegate);
    A1_V (image, [_imageUploadResponse objectForKey: @"image"]);

    [communicationKit requestItemUpload: [_email text]
                               provider: @"facebook"
                                    uid: [facebookResult objectForKey: @"id"]
                                  token: [facebook accessToken]
                                  title: @"Sent from my iPhone"
                            description: [_textView text]
                                  price: self.salary
                                zipcode: [_zip text]
                               image_id: [image objectForKey: @"id"]
                            contextInfo: self];
  }
}

- (IBAction)loginWithFacebook: (id)anObject;
{
  A1_V (appDelegate, A1_APP_DELEGATE);
  if (_fbLoginButton.isLoggedIn)
  {
    [appDelegate logout];
  }
  else
  {
    [appDelegate login];
  }
}

- (void)removeUnderlayerView: (UIView *)view;
{
  [view removeFromSuperview];
}

- (void)moveToIp1;
{
  _state = 0;
  [self.view removeFromSuperview];
  [UIView transitionWithView: self.view duration:0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ { [self.view addSubview: _ip1];}
                  completion: nil];
}

- (IBAction)processToFirstScreen: (id)anObject;
{
  _state = 0;
  self.image = nil;
  self.salary = nil;
  self.imageUploadResponse = nil;
  self.itemUploadResponse = nil;
  [self moveToIp1];
}

- (void)moveToIp2;
{
  _state = 1;
  [_textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
  [_textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
  [_textView.layer setBorderWidth: 1.0];
  [_textView.layer setCornerRadius:8.0f];
  [_textView.layer setMasksToBounds:YES];
  [UIView transitionWithView: self.view duration:0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ {
                    [self.view addSubview: _ip2];
                  }
                  completion: nil];
}

- (void)moveToIp3;
{
  _state = 2;
  [self.view removeFromSuperview];
  [UIView transitionWithView: self.view duration:0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ { [self.view addSubview: _ip3];}
                  completion: nil];
}

- (void)uploadFinished: (NSDictionary *)response;
{
  [self.uploadingSheet dismissWithClickedButtonIndex: 0 animated: YES];
  self.uploadingSheet = nil;
  
  switch (_state)
  {
    case 0:
      self.imageUploadResponse = response;
      [self moveToIp2];
      break;
    case 1:
      self.itemUploadResponse = response;
      [self moveToIp3];
      break;
    default:
      break;
  }
}

- (void)networkError: (NSError *)error;
{
  if (self.uploadingSheet != nil)
  {
    [self.uploadingSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.uploadingSheet = nil;
  }
  
  // show alert
  A1_ATV (localizedDescription, error);
  A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                                              message: localizedDescription
                                             delegate: self
                                    cancelButtonTitle: nil
                                    otherButtonTitles: @"OK", nil);
  [alertView show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
//  [actionSheet release];
  
  A1_NV (UIImagePickerController, imagePickerController);
  imagePickerController.delegate = self;

  switch (buttonIndex)
  {
    case 0:
      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
      break;
      
    case 1:
      imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      break;
      
    case 2:
      return;
      
    default:
      break;
  }
  
  [self presentModalViewController: imagePickerController
                          animated: YES];
}

- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex: (int) index
{
  A1_V (textField, [alertView viewWithTag: 9999]);
  
  if (!textField) // sux, I know
  {
  }
  else
  {
    if (1 == index)
    {
      A1_ATV (text, A1_KCAST (UITextField, textField));
      if (NSOrderedSame != [text compare: @""
                                 options: NSLiteralSearch])
      {
        self.salary = A1_STRING_WITH_FORMAT (@"%@$", text);
      }
      else
      {
        self.salary = @"0$";
      }
      A1_AV (price);
      [price setText: self.salary];
    }
  }
}

- (IBAction)addPicture: (id)anObject;
{
  A1_DLOG_TAG_BEG;
  
  A1_CUSTOM_NV (UIActionSheet, menu, initWithTitle: @"Add Photo"
                                          delegate: self
                                 cancelButtonTitle: @"Cancel"
                            destructiveButtonTitle: nil
                                 otherButtonTitles: @"Camera", @"Photo Gallery", nil);
  [menu showInView: self.view];
    
  A1_DLOG_TAG_END;
}

- (IBAction)addPrice: (id)anObject;
{
  A1_DLOG_TAG_BEG;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Please, enter a price"
                                                      message: @"   "
                                                     delegate: self
                                            cancelButtonTitle: @"Cancel"
                                            otherButtonTitles: @"OK", nil];
  UITextField *tf = [[UITextField alloc]
                     initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
  tf.borderStyle = UITextBorderStyleRoundedRect;
  tf.tag = 9999;
  tf.clearButtonMode = UITextFieldViewModeWhileEditing;
  tf.keyboardType = UIKeyboardTypeDecimalPad;
  tf.keyboardAppearance = UIKeyboardAppearanceAlert;
  tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
  tf.autocorrectionType = UITextAutocorrectionTypeNo;
  tf.contentVerticalAlignment =
  UIControlContentVerticalAlignmentCenter;
  
	[alertView show];
  
  CGRect bounds = alertView.bounds;
  tf.center = CGPointMake(bounds.size.width / 2.0f,
                          bounds.size.height / 2.0f - 10.0f);
  [alertView addSubview:tf];
  [tf release];
  [self performSelector:@selector(moveAlert:)
                   withObject:alertView afterDelay: 0.7f];
  
  A1_DLOG_TAG_END;
}

- (void)moveAlert: (UIAlertView *) alertView
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  [UIView beginAnimations:nil context:context];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView setAnimationDuration:0.25f];
  alertView.center = CGPointMake(240.0f, 90.0f);
  [UIView commitAnimations];
  [[alertView viewWithTag: 9999] becomeFirstResponder];
}

- (IBAction)processToDescription: (id)anObject;
{
  A1_DLOG_TAG_BEG;
  
  A1_V (appDelegate, A1_KCAST (SelleryAppDelegate, A1_APP_DELEGATE));
  A1_ATV (communicationKit, appDelegate);
  A1_AV (image);
  A1_AV (salary);
  if (nil == image || nil == salary)
  {
    A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                                                message: @"Please take a photo and enter a price to continue."
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil);
    [alertView show];
  }
  else
  {
    A1_CUSTOM_NV (UIActionSheet, uploadingSheet, initWithTitle: @"Uploading photo. Please Wait\n\n\n"
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
    [uploadingSheet addSubview: progressView];
    [progressView startAnimating];
    [uploadingSheet showInView: self.view];
    self.uploadingSheet = uploadingSheet;
    
    [communicationKit requestImageUpload: image
                             contextInfo: self];
  }
  
  A1_DLOG_TAG_END;
}

- (void)imagePickerController: (UIImagePickerController *)picker 
        didFinishPickingImage: (UIImage *)image
                  editingInfo: (NSDictionary *)editingInfo
{
  self.image = image;
  
  A1_AV (photo);
  [photo setImage: image
         forState: UIControlStateNormal];

  [picker dismissModalViewControllerAnimated: YES];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
  [picker dismissModalViewControllerAnimated: YES];
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  _state = 0;
  _fbLoginButton.isLoggedIn = NO;
  [_fbLoginButton updateImage];
  [super viewDidLoad];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

A1_PP_SELF_SYNTHESIZE_AND_DEALLOC;

@end

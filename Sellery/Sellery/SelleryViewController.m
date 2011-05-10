//
//  SelleryViewController.m
//  Sellery
//
//  Created by Sergey Simonov on 22.04.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelleryViewController.h"
#import "SelleryAppDelegate.h"
#import "SelleryAppDelegate+Facebook.h"
#import "SelleryAppCommunicationKit+Requests.h"
#import "SelleryAppDelegate+Facebook.h"
#import "UIImage+Resize.h"
#import <QuartzCore/QuartzCore.h>


#define A1_SELF \
  SelleryViewController

@implementation A1_SELF

@synthesize photo = _photo;
@synthesize price = _price;
@synthesize fbLoginButton = _fbLoginButton;
@synthesize firstImageView = _firstImageView;
@synthesize ip0 = _ip0;
@synthesize ip1 = _ip1;
@synthesize ip2 = _ip2;
@synthesize ipInvisible = _ipInvisible;
@synthesize selleryButton = _selleryButton;

#pragma mark -

- (IBAction)doneEditing: (id)sender
{
  A1_V (userDefaults, A1_USER_DEFAULTS);
  [userDefaults setObject: [_email text]
                   forKey: @"email"];
  [userDefaults setObject: [_zip text]
                   forKey: @"zip"];
  [userDefaults synchronize];

  [sender resignFirstResponder];
}

- (IBAction)hideKeypad: (id)sender;
{
  A1_V (userDefaults, A1_USER_DEFAULTS);
  [userDefaults setObject: [_email text]
                   forKey: @"email"];
  [userDefaults setObject: [_zip text]
                   forKey: @"zip"];
  [userDefaults synchronize];

  [_textView resignFirstResponder];
  [_zip resignFirstResponder];
  [_email resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
  _hasEnteredDescription = YES;
  A1_ATV (text, textView);
  if (NSOrderedSame == [text compare: @"Description (optional)"
                             options: NSLiteralSearch])
  {
    [textView setText: @""];
  }
  [textView setTextColor: [UIColor blackColor]];
}

- (void)textViewDidEndEditing:(UITextView *)textView;
{
  A1_ATV (text, textView);
  
  if (NSOrderedSame == [text compare: @""
                             options: NSLiteralSearch])
  {
    _hasEnteredDescription = NO;
    [textView setText: @"Description (optional)"];
    [textView setTextColor: [UIColor grayColor]];
  }
  
  [textView resignFirstResponder];
}

- (IBAction)processToFinalScreen: (id)anObject;
{
  [_textView resignFirstResponder];
  [_zip resignFirstResponder];
  [_email resignFirstResponder];
  
  A1_V (userDefaules, A1_USER_DEFAULTS);

  if (!_fbLoginButton.isLoggedIn ||
      [userDefaules objectForKey: @"id"] == nil ||
      [userDefaules objectForKey: @"accessToken"] == nil)
  {
    A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                                                message: @"Please login with Facebook to continue."
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil);
    self.alertView = alertView;
    [alertView show];
  }
  else
  {
    A1_CUSTOM_NV (UIActionSheet, uploadingSheet, initWithTitle: @"Uploading item data. Please Wait\n\n\n"
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
    
#if 1
    A1_V (appDelegate, A1_APP_DELEGATE);
    A1_ATV (communicationKit, appDelegate);
    A1_V (image, [_imageUploadResponse objectForKey: @"image"]);

    NSString *description = nil;
    A1_ATV (text, _textView);
    if (NSOrderedSame == [text compare: @"Description (optional)"
                               options: NSOrderedSame])
    {
      description = @"";
    }
    else
    {
      description = A1_STRING_WITH_STRING (text);
    }
    
    [communicationKit requestItemUpload: nil == [_email text] ? @"" : [_email text]
                               provider: @"facebook"
                                    uid: [userDefaules objectForKey: @"id"]
                                  token: [userDefaules objectForKey: @"accessToken"]
                                  title: @"Sent from my iPhone"
                            description: description
                                  price: self.salary
                                zipcode: nil == [_zip text] ? @"" : [_zip text]
                               image_id: [image objectForKey: @"id"]
                            contextInfo: self];
#else
    [self moveToIp3];
#endif
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
    [appDelegate setMoveToFacebook: YES];
    [appDelegate login];
  }
}

- (void)removeUnderlayerView: (UIView *)view;
{
  [view removeFromSuperview];
}

- (UIView *)topMostView;
{
  A1_ATV (subviews, self.view);
  A1_ATV (count, subviews);
  
  if (count > 1)
  {
    return [subviews objectAtIndex: --count];
  }
  
  if (count > 0)
  {
    [subviews objectAtIndex: 0];
  }
  
  return nil;
}

- (void)delaydSplashScreen;
{
  _ip1.alpha = 0.0f;
  [self.view bringSubviewToFront: _ip1];

  [UIView transitionWithView: self.view
                    duration: 0.5
                     options: UIViewAnimationOptionTransitionNone
                  animations:^ {
                    _ip0.alpha = 0.0f;
                    _ip1.alpha = 1.0f;
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: _ip0];
                  }];
}

- (void)dismissIp0AndMoveToIp1FromSplashScreen;
{
  _state = 1;

  self.image = nil;
  self.salary = nil;
  self.imageUploadResponse = nil;
  self.itemUploadResponse = nil;
  
  [_firstImageView setImage: [UIImage imageNamed: @"addphoto.png"]];
  [_photo setImage: [UIImage imageNamed: @"addphoto_pressed.png"]
          forState: UIControlStateHighlighted];
  [_price setText: @"Price it"];
  [_price setTextColor: [UIColor lightGrayColor]];

  _ip0.alpha = 1.0f;
  [self.view bringSubviewToFront: _ip0];
  [self performSelector: @selector (delaydSplashScreen)
             withObject: nil
             afterDelay: 3.0f];
}

- (void)moveToIp0;
{
  _state = 0;
  
  self.image = nil;
  self.salary = nil;
  self.imageUploadResponse = nil;
  self.itemUploadResponse = nil;
  
  A1_AV (topMostView);

  [UIView transitionWithView: self.view
                    duration: 0.5
                     options: UIViewAnimationOptionTransitionCurlUp
                  animations:^ {
                    [self.view bringSubviewToFront: _ip0];
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: topMostView];
                  }];
}

- (void)moveToIp1;
{
  _state = 1;
  
  self.image = nil;
  self.salary = nil;
  self.imageUploadResponse = nil;
  self.itemUploadResponse = nil;
  
  [_firstImageView setImage: [UIImage imageNamed: @"addphoto.png"]];
  [_photo setImage: [UIImage imageNamed: @"addphoto_pressed.png"]
          forState: UIControlStateHighlighted];
  [_price setText: @"Price it"];
  [_price setTextColor: [UIColor lightGrayColor]];

  A1_AV (topMostView);

  [UIView transitionWithView: self.view
                    duration: 0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ {
                    [self.view bringSubviewToFront: _ip1];
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: topMostView];
                  }];
}

- (void)moveToIp1WithoutAnimations;
{
  _state = 1;
  
  self.image = nil;
  self.salary = nil;
  self.imageUploadResponse = nil;
  self.itemUploadResponse = nil;
  
  [_firstImageView setImage: [UIImage imageNamed: @"addphoto.png"]];
  [_photo setImage: [UIImage imageNamed: @"addphoto_pressed.png"]
          forState: UIControlStateHighlighted];
  [_price setText: @"Price it"];
  [_price setTextColor: [UIColor lightGrayColor]];
  
  [self.view bringSubviewToFront: _ip1];
}

- (void)moveToIp1FromDescription;
{
  _state = 1;
  
  self.imageUploadResponse = nil;
  self.itemUploadResponse = nil;

  A1_AV (topMostView);

  [UIView transitionWithView: self.view duration: 0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ {
                    [self.view bringSubviewToFront: _ip1];
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: topMostView];
                  }];
}

- (IBAction)processToFirstScreen: (id)anObject;
{
  [self moveToIp1];
}

- (IBAction)processToFirstScreenFromDescription: (id)anObject;
{
  [self moveToIp1FromDescription];
}

- (void)moveToIp2;
{
  A1_V (userDefaults, A1_USER_DEFAULTS);
  
  _state = 2;
  _hasEnteredDescription = NO;
  [_textView setText: @"Description (optional)"];
  [_textView setTextColor: [UIColor grayColor]];
  [_email setText: [userDefaults objectForKey: @"email"]];
  [_zip setText: [userDefaults objectForKey: @"zip"]];
  [_textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
  [_textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
  [_textView.layer setBorderWidth: 3.0];
  [_textView.layer setCornerRadius:4.0f];
  [_textView.layer setMasksToBounds:YES];
  
  A1_AV (topMostView);
  
  [UIView transitionWithView: self.view
                    duration: 0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ {
                    [self.view bringSubviewToFront: _ip2];
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: topMostView];
                  }];
}

- (void)moveToIp2FromFacebookLogin;
{
  A1_V (userDefaults, A1_USER_DEFAULTS);
  
  _state = 2;
  _hasEnteredDescription = NO;
  [_textView setText: @"Description (optional)"];
  [_textView setTextColor: [UIColor grayColor]];
  [_email setText: [userDefaults objectForKey: @"email"]];
  [_zip setText: [userDefaults objectForKey: @"zip"]];
  [_textView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
  [_textView.layer setBorderColor: [[UIColor grayColor] CGColor]];
  [_textView.layer setBorderWidth: 3.0];
  [_textView.layer setCornerRadius:4.0f];
  [_textView.layer setMasksToBounds:YES];
  
#if 0
  _ip0.alpha = 0.0f;
  _ip2.alpha = 0.0f;
  [self.view bringSubviewToFront: _ip0];
  [UIView transitionWithView: self.view
                    duration: 0.5
                     options: UIViewAnimationOptionTransitionNone
                  animations:^ {
                    _ip0.alpha = 0.0f;
                    _ip2.alpha = 1.0f;
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: _ip0];
                  }];
#else
  [self.view bringSubviewToFront: _ip2];
#endif
}

- (void)moveToIp3;
{
  _state = 3;

  A1_AV (topMostView);
  
  [UIView transitionWithView: self.view duration: 0.5
                     options: UIViewAnimationOptionTransitionCurlDown
                  animations:^ {
                    [self.view bringSubviewToFront: _ip3];
                  }
                  completion: ^ (BOOL finished){
                    [self.view sendSubviewToBack: topMostView];
                  }];
}

- (void)uploadFinished: (NSDictionary *)response;
{
  [self.uploadingSheet dismissWithClickedButtonIndex: 0
                                            animated: YES];
  self.uploadingSheet = nil;
  
  switch (_state)
  {
    case 1:
      self.imageUploadResponse = response;
      [self moveToIp2];
      break;
    case 2:
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
  self.alertView = alertView;
  [alertView show];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
//  [actionSheet release];
  
#if 0
  A1_NV (UIImagePickerController, imagePickerController);
#else
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.delegate = self;
#endif

  switch (buttonIndex)
  {
    case 0:
      _selectingImage = YES;
      imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
      break;

    case 1:
      _selectingImage = YES;
      imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      break;

    case 2:
      _selectingImage = NO;
      return;

    default:
      _selectingImage = NO;
      break;
  }
  
  self.menu = nil;
  
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
      A1_AV (price);
      A1_ATV (text, A1_KCAST (UITextField, textField));
      if (NSOrderedSame != [text compare: @""
                                 options: NSLiteralSearch])
      {
        self.salary = A1_STRING_WITH_FORMAT (@"%@", text);
        [_price setTextColor: [UIColor blackColor]];
        [price setText: A1_STRING_WITH_FORMAT (@"$%@", self.salary)];
      }
      else
      {
        self.salary = nil;
        [price setText: @"Price it"];
        [_price setTextColor: [UIColor lightGrayColor]];
      }
    }
  }
  
  self.alertView = nil;

  [_selleryButton setEnabled: YES];
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
  self.menu = menu;
    
  A1_DLOG_TAG_END;
}

- (IBAction)addPrice: (id)anObject;
{
  A1_DLOG_TAG_BEG;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Please, enter a price"
                                                      message: @"\n"
                                                     delegate: self
                                            cancelButtonTitle: @"Cancel"
                                            otherButtonTitles: @"OK", nil];
  self.alertView = alertView;
  UITextField *tf = [[UITextField alloc]
                     initWithFrame:CGRectMake(0.0f, 0.0f, 260.0f, 30.0f)];
  tf.borderStyle = UITextBorderStyleRoundedRect;
  tf.tag = 9999;
  tf.clearButtonMode = UITextFieldViewModeWhileEditing;
  tf.keyboardType = UIKeyboardTypeNumberPad;
  tf.keyboardAppearance = UIKeyboardAppearanceAlert;
  tf.autocapitalizationType = UITextAutocapitalizationTypeWords;
  tf.autocorrectionType = UITextAutocorrectionTypeNo;
  tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  
	[alertView show];
  while (CGRectEqualToRect(alertView.bounds, CGRectZero));
  
  CGRect bounds = alertView.bounds;
  tf.center = CGPointMake(bounds.size.width / 2.0f,
                          bounds.size.height / 2.0f - 10.0f);
  [alertView addSubview: tf];
  [tf release];
  [self performSelector: @selector(moveAlert:)
             withObject: alertView
             afterDelay: 0.7f];
  
  [_selleryButton setEnabled: NO];
  
  A1_DLOG_TAG_END;
}

- (void)moveAlert: (UIAlertView *) alertView
{
  [alertView setTransform: CGAffineTransformMakeTranslation (0, 0)];
  [[alertView viewWithTag: 9999] becomeFirstResponder];
}

- (IBAction)processToDescription: (id)anObject;
{
  A1_DLOG_TAG_BEG;
  
  A1_AV (image);
  A1_AV (salary);
  if (nil == image || nil == salary)
  {
    A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
                                                message: @"Please take a photo and enter a price to continue."
                                               delegate: self
                                      cancelButtonTitle: nil
                                      otherButtonTitles: @"OK", nil);
    self.alertView = alertView;
    [alertView show];
  }
  else
  {
#if 1
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
    
    A1_V (appDelegate, A1_APP_DELEGATE);
    A1_ATV (communicationKit, appDelegate);
    [communicationKit requestImageUpload: image
                             contextInfo: self];
#else
    [self moveToIp2];
#endif
  }
  
  A1_DLOG_TAG_END;
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {  
  if (!error)
  {  
  }
  else
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Sellery"
                                                    message: [error localizedDescription]
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString (@"OK", @"")
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
  }  
}

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info;
{
  A1_DLOG (@"%@", info);
  
  [picker dismissModalViewControllerAnimated: YES];
  [picker release];

  UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
  
  if (image.size.width > image.size.height)
  {
    self.image = [[image resizedImage: CGSizeMake (480, 320)
                 interpolationQuality: kCGInterpolationMedium] roundedCornerImage: 8 borderSize: 8];
  }
  else
  {
    self.image = [[image resizedImage: CGSizeMake (320, 480)
                 interpolationQuality: kCGInterpolationMedium] roundedCornerImage: 8 borderSize: 8];
  }
  
  A1_ATV (sourceType, picker);
  if (UIImagePickerControllerSourceTypePhotoLibrary != sourceType)
  {
    UIImageWriteToSavedPhotosAlbum (image, self, @selector (imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:), self);
  }
  
  [_firstImageView setImage: self.image];
  [_photo setImage: nil
          forState: UIControlStateHighlighted];
  
  _selectingImage = NO;
  
#if 0
  [picker dismissModalViewControllerAnimated: YES];
#endif
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
  
//  A1_CUSTOM_NV (UIAlertView, alertView, initWithTitle: @"Sellery"
//                                              message: @"App is running under low memory conditions"
//                                             delegate: self
//                                    cancelButtonTitle: nil
//                                    otherButtonTitles: @"OK", nil);
//  [alertView show];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  // _state = 0;
  
  A1_V (userDefaults, A1_USER_DEFAULTS);
  A1_V (uid, [userDefaults objectForKey: @"id"])
  A1_V (accessToken, [userDefaults objectForKey: @"accessToken"])
//  A1_V (appDelegate, (SelleryAppDelegate *)A1_APP_DELEGATE);

  if (nil == uid || nil == accessToken)  
  {
    _fbLoginButton.isLoggedIn = NO;
  }
  else
  {
    _fbLoginButton.isLoggedIn = YES;
  }

  [_fbLoginButton updateImage];

//  if (!appDelegate.moveToFacebook)
  {
    switch (_state)
    {
      case 0:
        [self dismissIp0AndMoveToIp1FromSplashScreen];
        break;
      case 1:
        [self.view bringSubviewToFront: _ip1];
        break;
      case 2:
        [self.view bringSubviewToFront: _ip2];
        break;
      case 3:
        [self.view bringSubviewToFront: _ip3];
        break;
        
      default:
        break;
    }
  }
//  else
//  {
//    [self moveToIp2FromFacebookLogin];
//  }
  
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated;
{
  A1_DLOG (@"View will appear");
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

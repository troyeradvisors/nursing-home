//
//  PictureController.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureController.h"

@implementation PictureController 
@synthesize Caption;
@synthesize PhotoButton;
@synthesize Photo;
@synthesize SubmitMessage;
@synthesize SubmitButton;
@synthesize HomeName;
@synthesize home, photoChanged, photoInstructions;

NSString* DefaultCaption = @"Caption";


- (void)viewDidLoad
{
    [super viewDidLoad];

        
    Caption.delegate = self;
    
    Caption.text = DefaultCaption;
    
    HomeName.text = home.name;
    self.Status = kLoading;
    [[Web home] LoadMyPicture:home OnCompletion:^(Picture* p)
    {
        [self UpdateView:p];
        self.Status = kReady;
        
    } 
    OnError:^(NSError *e) 
    {
        self.Status = kReady;
        SubmitMessage.text = e.description; 
    }];
}


-(void)UpdateView:(Picture*)p
{
    photoInstructions.hidden = p != nil;
    if (p != nil) Photo.alpha = 1.0;
    if (p == nil) return;
    Caption.text = [p.caption copy];
    Photo.image = [p.Content copy];
}


-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-160);
    } completion:^(BOOL finished) {}];
    
    if ([textView.text isEqualToString:DefaultCaption]) 
        textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+160);
    } completion:^(BOOL finished) {}];
    if ([[textView.text Trim] IsEmpty])
        textView.text = DefaultCaption;
}


- (void)setStatus:(StatusType)s
{
    if (s == kLoading)
    {
        SubmitMessage.text = @"Loading";
        [self EnableControls:false];
    }
    if (s == kSubmitting)
    {
        SubmitMessage.text = @"Submitting";
        SubmitButton.enabled = false;
    }
    if (s == kReady || s == kComplete)
    {
        [self EnableControls:true];
        SubmitMessage.text = s == kComplete ? @"Completed" : @"Submit";
    }
}

- (void)EnableControls:(bool)enable
{
    PhotoButton.enabled = Caption.editable = SubmitButton.enabled = enable;
}

- (IBAction)BackgroundTap:(id)sender {
    [Caption resignFirstResponder];
}

- (IBAction)SelectPhoto:(id)sender 
{
    [self startMediaBrowserFromViewController:self usingDelegate:self];
    photoInstructions.hidden = true;
    Photo.alpha = 1.0;
}


- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate 
{
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypePhotoLibrary] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    mediaUI.delegate = delegate;
    
    [self presentModalViewController: mediaUI animated: YES];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage] ?: [info objectForKey:UIImagePickerControllerOriginalImage];
    
    photoChanged = true;
    self.Photo.image = image;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}




- (IBAction)Submit:(id)sender 
{
    Caption.text = [Caption.text Trim];
    
    bool isValid = (![Caption.text IsEqualNoCase:DefaultCaption] && ![Caption.text IsEmpty] && photoChanged);
    if (!isValid)
    {
        SubmitMessage.text = !photoChanged ? @"Select a new photo" : @"All fields are required";
        return;
    }
    
    bool isUpdated = home.myPicture == nil || photoChanged; 
    if (!isUpdated)
    {
        SubmitMessage.text = @"The photo must be updated";
        return;
    }
    
    self.Status = kSubmitting; // for some reason moving this down 3 lines makes the text lag when updating.
    
    Picture* p = [[Picture alloc] init];
    p.caption = Caption.text;
    p.Content = self.Photo.image;
    [[Web home] PostPicture:p Summary:home OnCompletion:^
    {
        self.Status = kComplete;
        photoChanged = false;
    } 
OnError:^(NSError *e) 
    {
        self.Status = kComplete;
        SubmitMessage.text = e.description;
        //SubmitMessage.text = @"Error: Try Again";
        //[[[UIAlertView alloc] initWithTitle:@"Error" message:e.description delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}






- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setCaption:nil];
    [self setHomeName:nil];
    [self setSubmitMessage:nil];
    [self setPhotoButton:nil];
    [self setSubmitButton:nil];
    [self setPhotoButton:nil];
    [self setPhoto:nil];
    [self setPhotoInstructions:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end

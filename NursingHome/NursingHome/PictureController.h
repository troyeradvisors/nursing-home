//
//  PictureController.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Summary.h"
#import "Picture.h"


@interface PictureController : UIViewController<UIImagePickerControllerDelegate, UITextViewDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextView *Caption;
@property (strong, nonatomic) IBOutlet UILabel *HomeName;
@property (strong, nonatomic) IBOutlet UILabel *photoInstructions;
@property (strong, nonatomic) IBOutlet UIButton *PhotoButton;
@property (strong, nonatomic) IBOutlet UIImageView *Photo;
@property (strong, nonatomic) IBOutlet UILabel *SubmitMessage;
@property (strong, nonatomic) IBOutlet UIButton *SubmitButton;

- (IBAction)BackgroundTap:(id)sender;

- (IBAction)SelectPhoto:(id)sender;
- (IBAction)Submit:(id)sender;

@property (strong, nonatomic) Summary* home;
@property (nonatomic) bool photoChanged;

@end

//
//  CommentController.h
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Summary.h"
#import "DLStarRatingControl.h"
#import "FullPictureController.h"


@interface CommentController : UIViewController <UITextViewDelegate, UIScrollViewDelegate>



@property (strong, nonatomic) IBOutlet UIScrollView *ImageScroller;
@property (strong, nonatomic) IBOutlet UIScrollView *RatingScroller;

@property (strong, nonatomic) IBOutlet UITextView *Content;
@property (strong, nonatomic) IBOutlet UITextView *ContentTitle;
@property (strong, nonatomic) IBOutlet UIImageView *HomeImage;
@property (strong, nonatomic) IBOutlet UILabel *SubmitMessage;
@property (strong, nonatomic) IBOutlet UILabel *HomeName;
@property (strong, nonatomic) IBOutlet UIButton *SubmitButton;
- (IBAction)Submit:(id)sender;

@property (strong, nonatomic) Summary* home;
@property (strong, nonatomic) IBOutlet UILabel *StaffLabel;
@property (strong, nonatomic) IBOutlet UILabel *HelpfulLabel;
@property (strong, nonatomic) IBOutlet UILabel *RehabilitationLabel;
@property (strong, nonatomic) IBOutlet UILabel *AppealLabel;
@property (strong, nonatomic) IBOutlet UILabel *OdorLabel;
@property (strong, nonatomic) IBOutlet UILabel *MealLabel;
@property (strong, nonatomic) DLStarRatingControl* StaffRating;
@property (strong, nonatomic) DLStarRatingControl* HelpfulRating;
@property (strong, nonatomic) DLStarRatingControl* RehabilitationRating;
@property (strong, nonatomic) DLStarRatingControl* AppealRating;
@property (strong, nonatomic) DLStarRatingControl* OdorRating;
@property (strong, nonatomic) DLStarRatingControl* MealRating;
@property (nonatomic) StatusType Status;
@end

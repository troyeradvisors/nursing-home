//
//  CommentCell.h
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"
#import "RatingControl.h"

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RatingControl *Rating;
@property (weak, nonatomic) IBOutlet RatingControl *FriendlyRating;
@property (weak, nonatomic) IBOutlet RatingControl *ResponsiveRating;
@property (weak, nonatomic) IBOutlet RatingControl *RehabRating;
@property (strong, nonatomic) IBOutlet UILabel *Content;
@property (weak, nonatomic) IBOutlet RatingControl *AppealRating;
@property (weak, nonatomic) IBOutlet RatingControl *OdorRating;
@property (strong, nonatomic) IBOutlet UILabel *ContentTitle;
@property (weak, nonatomic) IBOutlet RatingControl *MealRating;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *Votes;
@property (strong, nonatomic) IBOutlet UIButton *LikeButton;
@property (strong, nonatomic) IBOutlet UIButton *DislikeButton;
@property (weak, nonatomic) IBOutlet UIView *RatingsContainer;
- (IBAction)Like:(id)sender;
- (IBAction)Dislike:(id)sender;
@property (strong, nonatomic) Comment* comment;
- (void)UpdateView:(Comment*)c IsExpanded:(bool)isExpanded;

+(double)CalculateHeight:(Comment *)c IsExpanded:(bool)isExpanded;
    
@end

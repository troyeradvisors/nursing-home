//
//  CommentSummaryCell.h
//  NursingHome
//
//  Created by Allen on 3/28/13.
//
//

#import <UIKit/UIKit.h>
#import "Summary.h"


@interface CommentSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet RatingControl *Rating;
@property (weak, nonatomic) IBOutlet RatingControl *FriendlyRating;
@property (weak, nonatomic) IBOutlet RatingControl *ResponsiveRating;
@property (weak, nonatomic) IBOutlet RatingControl *RehabRating;
@property (weak, nonatomic) IBOutlet RatingControl *AppealRating;
@property (weak, nonatomic) IBOutlet RatingControl *OdorRating;
@property (weak, nonatomic) IBOutlet RatingControl *MealRating;
@property (weak,nonatomic) IBOutlet UILabel* ReviewCount;


- (void) UpdateView:(Summary*)s;
@end

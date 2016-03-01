//
//  CommentSummaryCell.m
//  NursingHome
//
//  Created by Allen on 3/28/13.
//
//

#import "CommentSummaryCell.h"


@implementation CommentSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) UpdateView:(Summary*)s
{
    [self.Rating Rating:s.userRating.doubleValue];
    self.ReviewCount.text = [NSString stringWithFormat:@"%d reviews", s.userRatingCount];
    
    [[Web home] LoadCommentSummary:s OnCompletion:^(Comment *c) {
        [self.FriendlyRating Rating:c.friendlyRating];
        [self.ResponsiveRating Rating:c.responsiveRating];
        [self.RehabRating Rating:c.rehabRating];
        [self.AppealRating Rating:c.appealRating];
        [self.MealRating Rating:c.mealRating];
        [self.OdorRating Rating:c.odorRating];
    } OnError:^(NSError *e) {
        
    }];
    
}
@end

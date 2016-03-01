//
//  CommentCell.m
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

const int COMMENT_MIN_HEIGHT = 107;
const int COMMENT_LABEL_WIDTH = 251;
const int COMMENT_LABEL_PADDING = 35;
const int COMMENT_FONT_SIZE = 13;
const int COMMENT_RATINGS_HEIGHT=59;

@synthesize LikeButton, DislikeButton, Rating, ContentTitle, Content, Date, Votes, comment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(double)CalculateHeight:(Comment *)c IsExpanded:(bool)isExpanded
{
    if (!isExpanded) return COMMENT_MIN_HEIGHT;
    CGSize commentSize = [c.content sizeWithFont:[UIFont fontWithName:@"Helvetica" size:COMMENT_FONT_SIZE] constrainedToSize:CGSizeMake(COMMENT_LABEL_WIDTH, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    commentSize.height += 2*COMMENT_LABEL_PADDING + COMMENT_RATINGS_HEIGHT;
    
    return MAX(COMMENT_MIN_HEIGHT+COMMENT_LABEL_PADDING, commentSize.height);

}

-(void)UpdateView:(Comment *)c
{
    comment = c;
    [Rating Rating:c.Rating];
    [self.FriendlyRating Rating:c.friendlyRating];
    [self.ResponsiveRating Rating:c.responsiveRating];
    [self.RehabRating Rating:c.rehabRating];
    [self.AppealRating Rating:c.appealRating];
    [self.MealRating Rating:c.mealRating];
    [self.OdorRating Rating:c.odorRating];
    
    
    ContentTitle.text = c.title;
    Content.text = c.content;
    Content.numberOfLines = 0;
    Votes.text = [NSString stringWithFormat:@"%.0f", c.Score];
    Date.text = [c.editDate ToFriendlyShortMonthString];

    LikeButton.enabled = DislikeButton.enabled = true; // set this to true or else if this cell reuses one that used to be IsMine comment, the opacity gets screwy.  
    if (comment.isMine)
    {
        LikeButton.enabled = DislikeButton.enabled = false;
        LikeButton.alpha = DislikeButton.alpha = .25;
    }
    else if (comment.vote != nil)
    {
        if (comment.vote.boolValue)
        {
            LikeButton.alpha = 1.0;
            DislikeButton.alpha = .25;
        }
        else
        {
            LikeButton.alpha = .25;
            DislikeButton.alpha = 1.0;
        }
    }
    else
        LikeButton.alpha = DislikeButton.alpha = .25;

}
-(void)UpdateView:(Comment *)c IsExpanded:(bool)isExpanded
{
    [self UpdateView:c];
    if (!isExpanded)
    {
        CGRect r = Content.frame;
        r.size = [c.content sizeWithFont:Content.font constrainedToSize:CGSizeMake(COMMENT_LABEL_WIDTH, COMMENT_MIN_HEIGHT-COMMENT_LABEL_PADDING) lineBreakMode:UILineBreakModeWordWrap];
        Content.frame = r;
        self.RatingsContainer.Hidden = true;
        
    }
    else
    {
         CGRect r = Content.frame;
        r.size = [c.content sizeWithFont:Content.font constrainedToSize:CGSizeMake(COMMENT_LABEL_WIDTH, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        Content.frame = r;
        self.RatingsContainer.Hidden = false;
        
    }
}

- (IBAction)Like:(id)sender
{
    [self Vote:true];
}

- (IBAction)Dislike:(id)sender
{
    [self Vote:false];
}

- (void)Vote:(bool) vote
{
    if (comment.vote != nil && comment.vote.boolValue == vote) // already voted this choice before.
        return;

    int sub = comment.vote != nil ? 1 : 0;
    comment.vote = comment.vote != nil ? nil : [NSNumber numberWithBool:vote];
    //comment.vote = [NSNumber numberWithBool:vote];
    if (vote)
    {
        if (comment.vote != nil) ++comment.positiveVotes;
        comment.negativeVotes -= sub;
    }
    else 
    {
        if (comment.vote != nil) ++comment.negativeVotes;
        comment.positiveVotes -= sub;
    }
    [self UpdateView:comment]; // update view
    [[Web home] PostCommentVote:comment.id Vote:comment.vote OnCompletion:^{} OnError:^(NSError *e) {}];
}

@end

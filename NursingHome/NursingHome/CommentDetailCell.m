//
//  CommentDetailCell.m
//  NursingHome
//
//  Created by Allen Brubaker on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentDetailCell.h"

@implementation CommentDetailCell
@synthesize Title, Rating, RatingContainer, Date, PositiveVotes, NegativeVotes, Description;

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

- (void)viewDidUnload
{
    Title = RatingContainer = Date = PositiveVotes = NegativeVotes = Description = nil;
    
}

@end

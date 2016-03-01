//
//  CommentDetailCell.h
//  NursingHome
//
//  Created by Allen Brubaker on 31/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RatingControl.h"

@interface CommentDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *RatingContainer;
@property (strong, nonatomic) RatingControl * Rating;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *PositiveVotes;
@property (strong, nonatomic) IBOutlet UILabel *NegativeVotes;
@property (strong, nonatomic) IBOutlet UILabel *Description;
@property (strong, nonatomic) IBOutlet UILabel *Title;


@end

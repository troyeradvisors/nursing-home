//
//  TASummaryCell.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"
#import "Filter.h"
#import "RatingControl.h"
#import "MKNetworkOperation.h"

@interface SummaryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nursingHomeName;
@property (strong, nonatomic) IBOutlet UILabel *numReviews;
@property (strong, nonatomic) IBOutlet UILabel *rowNumber;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong,nonatomic) IBOutlet UILabel *rank;
@property (strong,nonatomic) IBOutlet UILabel *rankTotal;
@property (strong,nonatomic) IBOutlet UIImageView *photo;
@property (strong,nonatomic) IBOutlet RatingControl *rating;
@property (strong,nonatomic) MKNetworkOperation* imageLoadingOperation;
-(void)Update:(Summary*)home;
@end

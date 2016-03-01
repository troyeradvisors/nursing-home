//
//  MapCalloutController.h
//  NursingHome
//
//  Created by Allen Brubaker on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Summary.h"
#import "RatingControl.h"
@interface MapCallout : UIViewController

@property (strong,nonatomic) Summary* home;

@property (strong, nonatomic) IBOutlet UILabel *nursingHomeName;
@property (strong, nonatomic) IBOutlet RatingControl* rating;
@property (strong, nonatomic) IBOutlet UILabel *numReviews;
@property (strong, nonatomic) IBOutlet UILabel *rowNumber;
@property (strong, nonatomic) IBOutlet UILabel *distance;
@property (strong,nonatomic) IBOutlet UILabel *rank;
@property (strong,nonatomic) IBOutlet UILabel *rankTotal;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UIButton *detailButton;

- (IBAction)DetailButtonPushed:(UIButton *)sender;
-(void)Update:(Summary*)h;

@end

//
//  DetailController.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"
#import "RatingControl.h"
#import "ShareHome.h"


@interface DetailController : UITableViewController
- (Home*) home;
@property (strong, nonatomic) Summary *summary;

@property (weak, nonatomic) IBOutlet UILabel *AddPhotoLabel;
@property (strong,nonatomic) ShareHome* Share;
@property (strong, nonatomic) IBOutlet UIImageView *Photo;
@property (strong, nonatomic) IBOutlet UILabel *HomeName;

@property (strong, nonatomic) IBOutlet RatingControl *Quality;
@property (strong, nonatomic) IBOutlet RatingControl *OverallRating;
@property (strong, nonatomic) IBOutlet RatingControl *UserRating;
@property (strong, nonatomic) IBOutlet UILabel *OverallRealRating;
@property (strong, nonatomic) IBOutlet UILabel *QualityRealRating;

@property (strong, nonatomic) IBOutlet UILabel *UserRatingCount;
@property (strong, nonatomic) IBOutlet UILabel *Rank;
@property (strong, nonatomic) IBOutlet UILabel *BedCount;
@property (strong, nonatomic) IBOutlet UILabel *Distance;
@property (strong, nonatomic) IBOutlet UILabel *Street;
@property (strong, nonatomic) IBOutlet UILabel *Address;
@property (strong, nonatomic) IBOutlet UILabel *PhoneNumber;
@property (strong, nonatomic) IBOutlet UILabel *Category;
@property (strong, nonatomic) IBOutlet UILabel *Ownership;
@property (strong, nonatomic) IBOutlet UILabel *OwnershipDetail;

@property (strong, nonatomic) IBOutlet UILabel *HealthSurveyDate;

- (IBAction)SharePressed:(id)sender;
- (IBAction)InfoPressed:(id)sender;
- (IBAction)CallFacilityPressed:(id)sender;

- (IBAction)DirectionsPressed:(id)sender;

@end

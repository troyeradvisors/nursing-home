//
//  Detail2Controller.h
//  NursingHome
//
//  Created by Allen Brubaker on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Home.h"

@interface Detail2Controller : UITableViewController

@property (strong, nonatomic) Home* home;

@property (strong, nonatomic) IBOutlet UILabel *SprinklerStatus;
@property (strong, nonatomic) IBOutlet UILabel *Name;
@property (strong, nonatomic) IBOutlet UILabel *IsInHospital;
@property (strong, nonatomic) IBOutlet UILabel *IsMultiOwned;
@property (strong, nonatomic) IBOutlet UILabel *IsSpecialFocusFacility;
@property (strong, nonatomic) IBOutlet UILabel *SubjectOccupancy;
@property (strong, nonatomic) IBOutlet UILabel *StateOccupancy;
@property (strong, nonatomic) IBOutlet UILabel *CountryOccupancy;
@property (strong, nonatomic) IBOutlet UILabel *SubjectRN;
@property (strong, nonatomic) IBOutlet UILabel *StateRN;
@property (strong, nonatomic) IBOutlet UILabel *CountryRN;
@property (strong, nonatomic) IBOutlet UILabel *SubjectLPN;
@property (strong, nonatomic) IBOutlet UILabel *StateLPN;
@property (strong, nonatomic) IBOutlet UILabel *CountryLPN;
@property (strong, nonatomic) IBOutlet UILabel *SubjectTotal;
@property (strong, nonatomic) IBOutlet UILabel *StateTotal;
@property (strong, nonatomic) IBOutlet UILabel *CountryTotal;
@property (strong, nonatomic) IBOutlet UILabel *SubjectCNA;
@property (strong, nonatomic) IBOutlet UILabel *StateCNA;
@property (strong, nonatomic) IBOutlet UILabel *CountryCNA;
@property (strong, nonatomic) IBOutlet UILabel *UpdatedDate;
@property (strong, nonatomic) IBOutlet UILabel *IsInCCRC;
@property (strong, nonatomic) IBOutlet UILabel *IsIndividualOwned;
@property (strong, nonatomic) IBOutlet UILabel *IsGovernmentOwned;
- (IBAction)ShowGridTip:(id)sender;
- (IBAction)ShowDetailTip:(id)sender;

@end

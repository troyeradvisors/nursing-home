//
//  FilterDetailController.h
//  NursingHome
//
//  Created by Lion User on 19/09/2012.
//
//

#import <UIKit/UIKit.h>
#import "Filter.h"
#import "DCRoundSwitch.h"

@interface FilterDetailController : UITableViewController

@property (strong, nonatomic) Filter* filter;

@property (strong, nonatomic) IBOutlet DCRoundSwitch *IncludeSpecialFocus;
@property (strong, nonatomic)  IBOutlet DCRoundSwitch * IncludeChainOwned;
@property (strong, nonatomic) IBOutlet DCRoundSwitch *IncludeCountyOwned;
 
@property (strong, nonatomic) IBOutlet UILabel *SortDisplay;
@property (strong, nonatomic) IBOutlet UILabel *GovernmentFundingProgramDisplay;
@property (strong, nonatomic) IBOutlet UILabel *LocationDisplay;
@property (strong, nonatomic) IBOutlet UILabel *OperatorTypeDisplay;

- (IBAction)ClearFilterDetail:(id)sender;

- (IBAction)ShowSpecialFocusInfo:(id)sender;


@end

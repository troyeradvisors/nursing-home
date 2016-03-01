//
//  TASummaryViewController.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"
#import "FilterBarController.h"
#import "WelcomeController.h"
#import "FilterController.h"
#import "MapController.h"
#import "SortController.h"
#import <iAd/iAd.h>

@interface SummaryController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>


@property (strong, nonatomic) NSArray *homes;
@property (strong, nonatomic) FilterBarController* filterBar;
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) IBOutlet UILabel *LocationServicesWarning;

@end

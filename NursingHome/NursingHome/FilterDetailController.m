//
//  FilterDetailController.m
//  NursingHome
//
//  Created by Lion User on 19/09/2012.
//
//

#import "FilterDetailController.h"
#import "SortController.h"
#import "OperatorTypeController.h"
#import "GovProgramController.h"
#import "LocationFilterController.h"

@implementation FilterDetailController
@synthesize SortDisplay;
@synthesize GovernmentFundingProgramDisplay;
@synthesize LocationDisplay;
@synthesize OperatorTypeDisplay;
@synthesize filter;
@synthesize IncludeChainOwned, IncludeSpecialFocus, IncludeCountyOwned;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Global SetBackground:self.tableView];
    self.tableView.sectionFooterHeight = 2.0;
    
    NSArray* switches = [NSArray arrayWithObjects:IncludeChainOwned, IncludeSpecialFocus, IncludeCountyOwned, nil];
    for (DCRoundSwitch* s in switches)
    {
        // weird iphone error where you have to set selector before the on = YES.  Only happens on actual iphone though.  
        [s addTarget:self action:@selector(SwitchChanged:) forControlEvents:UIControlEventValueChanged];
        
        s.on = YES;
        s.onTintColor = [UIColor colorWithRed:25/255.0 green:128/255.0 blue:180/255.0 alpha:1.0];
        s.onText = @"Yes";
        s.offText = @"No";
    }

    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //[self.tableView selectRowAtIndexPath:[self GetIndexOfSort] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.destinationViewController isKindOfClass:[SortController class]])
    {
        SortController *sort = segue.destinationViewController;
        sort.filter = filter;
    }
    
    if ([segue.destinationViewController isKindOfClass:[GovProgramController class]])
    {
        GovProgramController *g = segue.destinationViewController;
        g.filter =filter;
    }
    if ([segue.destinationViewController isKindOfClass:[OperatorTypeController class]])
    {
        OperatorTypeController *o = segue.destinationViewController;
        o.filter = filter;
    }
    if ([segue.destinationViewController isKindOfClass:[LocationFilterController class]])
    {
        LocationFilterController *l = segue.destinationViewController;
        l.filter = filter;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self UpdateFromFilter];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (![self.navigationController.childViewControllers containsObject:self])
        [[Global data] setHomeFilter:self.filter]; 
}
- (NSIndexPath*)GetIndexOfSort
{
    SortType s = [Global data].HomeFilter.Sort;
    int row = s == kDistance ? 0 : s == kQuality ? 1 : s == kUserRating ? 2 : 3;
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (SortType) GetSortTypeFromIndex:(NSIndexPath*)path
{
    return path.row == 0 ? kDistance : path.row == 1 ? kQuality : path.row == 2 ? kUserRating: kOverallRating;
}

- (void) UpdateFromFilter
{
    self.GovernmentFundingProgramDisplay.text = filter.GovernmentFundingProgramDisplay;
    self.LocationDisplay.text = filter.LocationDisplay;
    self.OperatorTypeDisplay.text = filter.OperatorTypeDisplay;
    self.SortDisplay.text = filter.SortLongString;
    
    
    [IncludeSpecialFocus setOn:filter.IncludeSpecialFocus];
    [IncludeCountyOwned setOn:filter.IncludeCountyOwned];
    [IncludeChainOwned setOn:filter.IncludeChainOwned];
     
     
}

- (void)viewDidUnload
{
    [self setSortDisplay:nil];
    [self setGovernmentFundingProgramDisplay:nil];
    [self setLocationDisplay:nil];
    [self setOperatorTypeDisplay:nil];
    IncludeCountyOwned =  IncludeChainOwned= IncludeSpecialFocus = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (IBAction)ShowSpecialFocusInfo:(id)sender {
    NSString* m = @"Each month, the Centers for Medicare & Medicaid Services (CMS) identifies nursing facilities that are among the facilities providing the poorest care to their residents, as determined by federal deficiencies cited in the prior three years.   These facilities, called Special Focus Facilities (SFFs), receive special attention from state survey agencies – at least two surveys each year (instead of one) and enhanced enforcement activities.  While SFFs may not necessarily be the very poorest quality facilities in the country, they are, by definition, among the facilities nationwide that provide the poorest quality of care.";
    [[[UIAlertView alloc] initWithTitle:@"Special Focus" message:m delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)SwitchChanged:(id)sender {
    if (sender == IncludeSpecialFocus)
        filter.IncludeSpecialFocus = IncludeSpecialFocus.on;
    else if (sender == IncludeChainOwned)
        filter.IncludeChainOwned = IncludeChainOwned.on;
    else if (sender == IncludeCountyOwned)
        filter.IncludeCountyOwned = IncludeCountyOwned.on;
}

- (IBAction)ClearFilterDetail:(id)sender
{
    [self.filter ClearDetail];
    [self UpdateFromFilter];
}



#pragma mark - Table view delegate



@end


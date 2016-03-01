//
//  TASummaryViewController.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 18/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SummaryController.h"
#import "SummaryCell.h"
#import "Home.h"
#import "Global.h"
#import "DetailController.h"
#import <CoreLocation/CoreLocation.h>
#import "FilterDetailController.h"

@implementation SummaryController

@synthesize homes;
@synthesize filterBar;
@synthesize table;
@synthesize LocationServicesWarning;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:DataUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:CommentPostedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:PicturePostedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:PictureRemovedNotification object:nil];
    
    [Global SetBackground:table];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed: @"menuBar.png"];
    [navigationBar setBackgroundImage:image forBarMetrics: UIBarMetricsDefault];
    //navigationBar.tintColor = [UIColor colorWithRed:25/255.0f green:128/255.0f blue:180/255.0f alpha:1.0];
    //navigationBar.tintColor = [UIColor colorWithRed:10/255.0f green:103/255.0f blue:170/255.0f alpha:1.0];
    navigationBar.tintColor = [UIColor colorWithRed:26/255.0f green:134/255.0f blue:192/255.0f alpha:1.0];
    
    
    UIBarButtonItem* filter = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(GoBack)];
    UIBarButtonItem* map = [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStylePlain target:self action:@selector(GoMap)];
    
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:filter,map,nil];

    filterBar = [[FilterBarController alloc] init];
    [self.view addSubview:filterBar.view];
    [filterBar Update:[Global data].HomeFilter];
    self.table.delegate = self;
    self.table.dataSource = self;
}


-(Filter*)filter
{
    return [Global data].HomeFilter;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LocationServicesWarning.hidden = [Global data].LocationServicesEnabled || ![Global data].HomeFilter.IsNearbyMe;
}

- (void) UpdateData:(NSNotification*)notification
{
    self.homes = [Global data].FilteredHomes;
    [filterBar Update:[Global data].HomeFilter];
    [self UpdateRefineButton];
    [self.table reloadData];
    [self.table scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
    LocationServicesWarning.hidden = [Global data].LocationServicesEnabled || self.homes.count > 0;
}



- (void)UpdateRefineButton
{
    UIBarButtonItem* refine = [[UIBarButtonItem alloc] initWithTitle:@"Refine" style:UIBarButtonItemStyleBordered target:self action:@selector(Refine)];
    UIBarButtonItem* clearRefine = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(ClearRefine)];
    if ([Global data].HomeFilter.IsDetailFilterApplied)
    {
        refine.tintColor = [UIColor colorWithRed:21/255.0f green:109/255.0f blue:153/255.0f alpha:1.0];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:refine, clearRefine, nil];
    }
    else
    {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:refine, nil];
    }
    
}

- (void)ClearRefine
{
    Filter* filter = [Global data].HomeFilter;
    [filter ClearDetail];
    [[Global data] setHomeFilter:filter];
    [self UpdateRefineButton]; // remove the clear button
    [self UpdateData:nil];
}
- (void)Refine
{
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FilterDetailController* d = [s instantiateViewControllerWithIdentifier:@"FilterDetailController"];
    d.filter = [[Global data] HomeFilter];
    [self.navigationController pushViewController:d animated:YES];
}

- (void)GoBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)GoMap
{
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MapController* d = [s instantiateViewControllerWithIdentifier:@"MapController"];
    [self.navigationController pushViewController:d animated:YES];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[DetailController class]])
    {
        Summary *s = [self.homes objectAtIndex:[table indexPathForCell:sender].row];
        DetailController *detail = segue.destinationViewController;
        detail.summary = s;
    }
    if ([segue.destinationViewController isKindOfClass:[SortController class]])
    {
        SortController *detail = segue.destinationViewController;
        detail.filter = [[Global data] HomeFilter];
    }
    if ([segue.destinationViewController isKindOfClass:[FilterDetailController class]])
    {
        FilterDetailController *detail = segue.destinationViewController;
        detail.filter = [[Global data] HomeFilter];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = [homes count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultCell";
    SummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell Update:[homes objectAtIndex:indexPath.row]];
    return cell;
}


-(UIView*)AdResizeView { return self.table; }


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    homes = nil;
    filterBar = nil;
    [self setTable:nil];
    [self setLocationServicesWarning:nil];
    [super viewDidUnload];
}


@end

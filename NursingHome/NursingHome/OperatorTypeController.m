//
//  SortController.m
//  NursingHome
//
//  Created by Lion User on 26/09/2012.
//
//

#import "OperatorTypeController.h"


@implementation OperatorTypeController

@synthesize SelectedRows, filter;

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
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    SelectedRows = [NSMutableArray array];

    
    if (filter.IsGovernment)
        [SelectedRows addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (filter.IsNonProfit)
        [SelectedRows addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (filter.NonProfitFaithBased)
        [SelectedRows addObject:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (filter.IsForProfit)
        [SelectedRows addObject:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (filter.ForProfitIndividualOwned)
        [SelectedRows addObject:[NSIndexPath indexPathForRow:4 inSection:0]];
    [self.tableView reloadData];
}


-(void)viewWillDisappear:(BOOL)animated
{
    //[super viewWillDisappear:animated];
    
    filter.IsGovernment = filter.IsNonProfit = filter.NonProfitFaithBased = filter.IsForProfit = filter.ForProfitIndividualOwned = false;
    for (NSIndexPath* p in SelectedRows)
    {
        switch (p.row)
        {
            case 0: filter.IsGovernment = true; break;
            case 1: filter.IsNonProfit = true; break;
            case 2: filter.NonProfitFaithBased = true; break;
            case 3: filter.IsForProfit = true; break;
            case 4: filter.ForProfitIndividualOwned = true; break;
        }
    }
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    bool contains = false;
    for (NSIndexPath* p in SelectedRows)
        if (p.row == indexPath.row)
            contains = true;
    if (contains)
    {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        UILabel* name = (UILabel*)[cell viewWithTag:1];
        name.textColor = [UIColor colorWithRed:10/255.0 green:104/255.0 blue:170/255.0 alpha:1.0];
        //name.font = [UIFont boldSystemFontOfSize:[name.font pointSize]];
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UILabel* name = (UILabel*)[cell viewWithTag:1];
        name.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    bool contains = false;
    NSIndexPath* remove = nil;
    for (NSIndexPath* p in SelectedRows)
        if (p.row == indexPath.row)
        {
            contains = true;
            remove = p;
        }
                
    if (contains)
        [SelectedRows removeObject:remove];
    else
        [SelectedRows addObject:indexPath];
    
    [tableView reloadData];
}

- (IBAction)TipPressed:(id)sender
{
    NSString* message = @"Distance:\nDistance in miles from your chosen location.  This can be either nearby you or near a custom location and is specified in the filter page.\n\nHealth Inspection Rating:\nA team of state health inspectors conduct onsite health inspections, on average, about once a year. Inspectors look at the care of residents, the process of care, staff and resident interactions, and the nursing home environment. The data from the last three standard health inspections and all complaint inspections that have been conducted in the last three years were used to calculate the rating.\n\nUser Rating:\nThe average rating of all user reviews for each facility.\n\nOverall Rating:A rating calculated from Quality and Rating, attributing equal weighting to both.\n";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Sort Tip" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// rgb = 236, 245, 235



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

@end

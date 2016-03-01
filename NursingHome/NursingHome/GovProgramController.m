//
//  SortController.m
//  NursingHome
//
//  Created by Lion User on 26/09/2012.
//
//

#import "GovProgramController.h"


@implementation GovProgramController
@synthesize SelectedRow, filter;

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
    
    SelectedRow = -1;
    NSIndexPath* p = [self GetIndexOfSort];
    if (p != nil)
        [self tableView:self.tableView didSelectRowAtIndexPath:p];
}

- (NSIndexPath*)GetIndexOfSort
{
    if (!filter.IsMedicaid && !filter.IsMedicare) return nil;
    int row = filter.IsMedicaid ? 0 : 1;
    return [NSIndexPath indexPathForRow:row inSection:0];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    filter.IsMedicaid = filter.IsMedicare = false;
    if (SelectedRow == 0)
    {
        filter.IsMedicaid = true;
        filter.IsMedicare = false;
    }
    else if (SelectedRow == 1)
    {
        filter.IsMedicaid = false;
        filter.IsMedicare = true;
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
    if (indexPath.row == self.SelectedRow)
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
    if (self.SelectedRow == indexPath.row)
        self.SelectedRow = -1;
    else
        self.SelectedRow = indexPath.row;
    [tableView reloadData];
}


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

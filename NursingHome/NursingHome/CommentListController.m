//
//  CommentListController.m
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentListController.h"
#import "Comment.h"
#import "CommentSummaryCell.h"
#import "CommentCell.h"
#import "CommentController.h"

@implementation CommentListController

@synthesize home, ExpandedCells, table;

bool AddingComment;
NSDate* ScrollTime;

-(NSArray*)Comments
{
    return home.comments;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    table.delegate = self;
    table.dataSource = self;
    
    if ([Global IsCommentListInstructionsNeeded])
    {
        if (![Global IsDeviceLong])
        {
            self.Instructions.layer.contentsRect = CGRectMake(0, 0, 1.0, 0.8450704225352113); // trim bottom of display if the device is the shorter one (iphone 4 and less).
        }
        self.Instructions.hidden = false;
    }
    else
        self.Instructions.hidden = true;
    
    
    [Global SetBackground:self.table];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:CommentPostedNotification object:nil];
    
    ExpandedCells = [NSMutableArray array];
    AddingComment = false;
    ScrollTime = [NSDate date];
    self.table.sectionFooterHeight = 2.0;
    [self UpdateView];
}


- (void) UpdateData:(NSNotification*)notification
{
    [self.table reloadData];
}

- (void) UpdateView
{
    [[Web home] LoadComments:home LoadMore:false OnCompletion:^(NSArray *c)
     {
         [self.table reloadData];
     } OnError:^(NSError *e) {
         
     }];
}

- (void) viewDidAppear:(BOOL)animated
{
    if (AddingComment)
    {
        AddingComment = false;
        [self.table reloadData];
    }
}


- (void) LoadMoreData
{
    if (home.NoMoreComments) return;
    [[Web home] LoadComments:home LoadMore:true OnCompletion:^(NSArray *c)
     {
         [self.table reloadData];
         
     } OnError:^(NSError *e)
    {
        
    }];
}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([[NSDate date] timeIntervalSinceDate:ScrollTime] < 2) return;
    NSIndexPath* index = [self.table indexPathsForVisibleRows].lastObject;
    if (index == nil || index.row == home.comments.count-1 || index.row >= home.commentCacheSize)
    {
        ScrollTime = [NSDate date];
        [self LoadMoreData];
    }
    
    return;
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYOffset;
    
    if (distanceFromBottom < height) // at end of table
    {
        ScrollTime = [NSDate date];
        [self LoadMoreData];
    }
}


- (IBAction)InstructionsTapped:(id)sender {
    [Global DisplayedCommentList];
    [UIView beginAnimations:@"instructions" context:nil];
        self.Instructions.alpha = 0.0;
    [UIView commitAnimations];
    
}

- (void)viewDidUnload
{
    [self setTable:nil];
    [self setInstructions:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return 1; break;
        default: return self.Comments.count; break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *id = @"SummaryCell";
        CommentSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
        [cell UpdateView:home];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"DefaultCell";
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        Comment* c = [self.Comments objectAtIndex:indexPath.row];
        [cell UpdateView:c IsExpanded:[self IsExpanded:indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return tableView.rowHeight;
    }
    else
    {
        int row = indexPath.row;
        return [CommentCell CalculateHeight:[self.Comments objectAtIndex:row] IsExpanded:[self IsExpanded:row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0);
        [self Toggle:indexPath.row];
}

- (void)Toggle:(int) row
{
    for (int i=ExpandedCells.count; i<=row; ++i)
    {
        [ExpandedCells addObject:[NSNumber numberWithBool:false]];
    }
    NSNumber* n = [ExpandedCells objectAtIndex:row];
    bool expanded = n.boolValue;
    [ExpandedCells replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:!expanded]];
    [self.table reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:row inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
}

- (bool)IsExpanded:(int) row
{
    if (row >= ExpandedCells.count)
        return false;
    NSNumber* n = [ExpandedCells objectAtIndex:row];
    return n.boolValue;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[CommentController class]])
    {
        CommentController *detail = segue.destinationViewController;
        detail.home = home;
        AddingComment = true;
    }
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

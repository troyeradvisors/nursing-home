//
//  PictureListController.m
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureListController.h"
#import "PictureCell.h"
#import "PictureController.h"
#import "FullPictureController.h"

@implementation PictureListController
@synthesize Scroller, loadedAllPics;

@synthesize home, LoadingData, table;

bool AddingPicture;
NSDate* ScrollTime;
const SortType DefaultSort = kGrid;
const int MaxGridColumns = 10;
-(NSArray*) Pictures
{
    return home.pictures;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:PicturePostedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:PictureRemovedNotification object:nil];
    
    self.table.delegate = self;
    self.table.dataSource = self;

     
    [self UpdateView:DefaultSort];
    
    AddingPicture = false;
    ScrollTime = [NSDate date];
    [[Web home] LoadPictures:home LoadMore:false OnCompletion:^(NSArray *pics)
    {
        [self UpdateData:nil];
       
    } OnError:^(NSError *e) {
        
    }];
    
}

- (void) UpdateData:(NSNotification*)notification
{
    [self.table reloadData];
    [self UpdateGridColumns];
    [self updateScroller];
}

-(void) UpdateView:(ListType)type
{
    
    if (type == kList)
    {
        UIBarButtonItem* add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddPicture)];
        UIBarButtonItem* grid = [[UIBarButtonItem alloc] initWithTitle:@"Grid" style:UIBarButtonItemStylePlain target:self action:@selector(ShowGrid)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:add,grid,nil];
        self.Scroller.hidden = true;
        self.table.hidden = false;
    }
    else if (type == kGrid)
    {
        UIBarButtonItem* add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddPicture)];
        UIBarButtonItem* list = [[UIBarButtonItem alloc] initWithTitle:@"List" style:UIBarButtonItemStylePlain target:self action:@selector(ShowList)];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:add,list,nil];
        self.table.hidden = true;
        self.Scroller.hidden = false;
    }
    
}

- (void)ShowList
{
    [self UpdateView:kList];
}

- (void)ShowGrid
{
    [self UpdateView:kGrid];
}

- (void)AddPicture
{
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    PictureController* d = [s instantiateViewControllerWithIdentifier:@"PictureController"];
    d.home = home;
    [self.navigationController pushViewController:d animated:true];
}



- (void)updateScroller
{
    Scroller.delegate = self;
    for (UIView* view in Scroller.subviews)
        [view removeFromSuperview];
    
    
    [Scroller setCanCancelContentTouches:NO];
    
    int spacer = 2;
    CGFloat cx = spacer;
    CGFloat cy = spacer;
    double picsPerRow = lroundf(self.GridColumns);
    
    double rowWidth = [Scroller bounds].size.width;
    CGFloat maxLength = 1/picsPerRow * (rowWidth - (picsPerRow+1) * spacer);
    double maxRowHeight = 0;
    for (int i = 0; i< home.pictures.count + (home.NoMorePictures || home.pictures.count == 0 ? 0 : 1); ++i)
    {
        Picture *p = i < home.pictures.count ? [home.pictures objectAtIndex:i] : nil;
        double height = p != nil ? p.Content.size.height : 50;
        double width = p != nil ? p.Content.size.width : 50;
        double heightPerWidth = height / width;
        CGRect rect;
        if (height > width)
        {
            height = MIN(maxLength, height);
            width = height / heightPerWidth;
        }
        else
        {
            width = MIN(maxLength, width);
            height = width * heightPerWidth;
        }
        rect.size.height = height;
        rect.size.width = width;
        rect.origin.x = cx;
        rect.origin.y = cy;
        cx += width + spacer;
        maxRowHeight = MAX(maxRowHeight, height);
        if (cx+maxLength >= [Scroller bounds].size.width)
        {
            cx = spacer;
            cy += maxRowHeight + spacer;
            maxRowHeight = 0;
        }
        
        
        UIButton *button = p == nil ? [UIButton buttonWithType:UIButtonTypeContactAdd] : [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:p.Content forState:UIControlStateNormal];
        button.tag = i;
        if (p != nil)
        {
            [button addTarget:self action:@selector(ImagePressed:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
        }
        else
        {
            [button addTarget:self action:@selector(PressedLoadMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        UIImageView* view = [[UIImageView alloc] initWithImage:p.Content];
        [view setContentMode:UIViewContentModeScaleAspectFill];
        view.frame = rect;
        button.frame = rect;
        //[button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [Scroller addSubview:view];
        [Scroller addSubview:button];
    }
    
    [Scroller setContentSize:CGSizeMake([Scroller bounds].size.width, cy+maxRowHeight)];
    Scroller.showsVerticalScrollIndicator = NO;
    Scroller.showsVerticalScrollIndicator = YES;

}

-(void)PressedLoadMoreButton:(id)sender
{
    UIButton* b = (UIButton*) sender;
    b.hidden = true;
    [self LoadMoreData];
}

-(void)ImagePressed:(id)sender
{
    int tag = ((UIControl*) sender).tag;
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FullPictureController* d = [s instantiateViewControllerWithIdentifier:@"FullPictureController"];
    d.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    d.picture = [home.pictures objectAtIndex:tag];
    d.home = self.home;
    [self presentModalViewController:d animated:NO];
}


- (void) LoadMoreData
{
    if (home.NoMorePictures) return;
    [[Web home] LoadPictures:home LoadMore:true OnCompletion:^(NSArray *pics)
     {
        [self UpdateData:nil];
     } OnError:^(NSError *e) {
     }];
    
}

-(void) UpdateGridColumns
{
    self.GridColumns = home.pictures.count <= 5 ? 1.0 : home.pictures.count <= 10 ? 2.0 : 3.0;
    [self updateScroller];
}



- (IBAction)Zoom:(UIPinchGestureRecognizer *)gesture {
    int newValue = (int)lroundf((1-MIN(1.0,gesture.scale))*(MaxGridColumns-1)+1);
    if (newValue != self.GridColumns)
    {
        self.GridColumns = newValue;
        [self updateScroller];
    }
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([[NSDate date] timeIntervalSinceDate:ScrollTime] < 2) return;
    NSIndexPath* index = [self.table indexPathsForVisibleRows].lastObject;
    if (index == nil || index.row == home.pictures.count-1 || index.row >= home.pictureCacheSize)
    {
        ScrollTime = [NSDate date];
        [self LoadMoreData];
    }
    
    return;
    
    if ([[NSDate date] timeIntervalSinceDate:ScrollTime] < 2) return;
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYOffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYOffset;
    if (distanceFromBottom < height) // at end of table
    {
        ScrollTime = [NSDate date];
        [self LoadMoreData];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    if (AddingPicture)
    {
        AddingPicture = false;
        [self.table reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Pictures == nil ? 0 : self.Pictures.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultCell";
    PictureCell *c = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [c UpdateView:[self.Pictures objectAtIndex:indexPath.row] Summary:self.home Navigator:self];
    return c;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PictureController class]])
    {
        AddingPicture = true;
        PictureController *detail = segue.destinationViewController;
        detail.home = home;
    }
    

}


- (void)viewDidUnload
{
    Scroller = nil;
    table = nil;
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];	
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end

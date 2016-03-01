//
//  DetailController.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailController.h"
#import "Detail2Controller.h"
#import "Comment.h"
#import "CommentController.h"
#import "CommentListController.h"
#import "PictureListController.h"
#import "MapController.h"
#import "CommentDetailCell.h"

@implementation DetailController
@synthesize summary;
@synthesize Photo;
@synthesize HomeName;
@synthesize Quality;
@synthesize OverallRating;
@synthesize UserRating;
@synthesize OverallRealRating;
@synthesize QualityRealRating;
@synthesize UserRatingCount;
@synthesize Rank;
@synthesize BedCount;	
@synthesize Distance;
@synthesize Street;
@synthesize Address;
@synthesize PhoneNumber;
@synthesize Category;
@synthesize Ownership;
@synthesize OwnershipDetail;
@synthesize HealthSurveyDate;
@synthesize AddPhotoLabel;

const int DynamicSection = 4;
const int CommentDisplayLimit = 3;
const int CommentHeight = 95, AddReviewHeight = 45;
bool RegisteredCells;


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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateViewComments:) name:CommentPostedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateView:) name:PicturePostedNotification object:nil];
    
    [[Web home] LoadHome:self.summary OnComplete:^(Home *h) {
        [self UpdateView:nil];
    } OnError:^(NSError *e) {}];
    
    [[Web home] LoadThumbnail:summary OnCompletion:^(UIImage *pic)
     {
         if (pic != nil)
         {
             Photo.image = pic;
             AddPhotoLabel.hidden = true;
         }
     } OnError:^(NSError *e) {}];    
    
    [[Web home] LoadComments:self.summary LoadMore:false OnCompletion:^(NSArray *comments)
     {
         [self UpdateViewComments:nil];
     } OnError:^(NSError *e) {}];
    
    [Global SetBackground:self.tableView];
    
    self.Share = [[ShareHome alloc] init:summary];
    [self.view addSubview:self.Share];
    
    self.tableView.sectionFooterHeight = 2.0;
    RegisteredCells = false;
    [self UpdateView:nil];
}

- (Home*) home { return summary.home; }

-(void) UpdateRatings
{
    [Quality Rating:summary.healthInspectionRating.intValue*2.0];
    QualityRealRating.hidden = OverallRealRating.hidden = true;
    QualityRealRating.text = [NSString stringWithFormat:@"%.1f", summary.healthInspectionRating.intValue*2.0];
    
    [UserRating Rating:summary.userRating.doubleValue];
    UserRatingCount.text = [NSString stringWithFormat:@"%d reviews", summary.userRatingCount];
    
    [OverallRating Rating:summary.weightedRating];
    OverallRealRating.text = [NSString stringWithFormat:@"%.1f", summary.weightedRating];
    
}

-(void) UpdateViewComments:(NSNotification*)notification
{
    [self UpdateRatings];
     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DynamicSection] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void) UpdateView:(NSNotification*)notification
{
    
    // Summary
    if (summary.picture != nil)
    {
        Photo.image = summary.picture;
        AddPhotoLabel.hidden = true;
    }
    
    [Photo Modify:10.0 Glossy:false];
    
    HomeName.text = [self.home.name Trim];
    
    [self UpdateRatings];

    Rank.text = [NSString stringWithFormat:@"%d of %d results", summary.rank, [Global data].FilteredHomes.count];
    BedCount.text = [NSString stringWithFormat:@"%@", self.home.certifiedBedCount];
    Distance.text = summary.distance < 10 ? [NSString stringWithFormat:@"%.1f miles", summary.distance] : [NSString stringWithFormat:@"%.0f miles", summary.distance];
    
    // Detail
    Street.text = [NSString stringWithFormat:@"%@", [summary.street Trim]];
    Address.text = [NSString stringWithFormat:@"%@, %@ %@", [self.home.city Trim], self.home.stateCode, self.home.zipCode];
    PhoneNumber.text = [[NSString stringWithFormat:@"%@", self.home.phoneNumber] FormatPhoneNumber];
    Category.text = [self.home.categoryType Contains:@"BOTH"] ? @"Medicare/Medicaid" : self.home.categoryType.ToNormalized;
    Ownership.text= self.home.ownershipType.ToNormalized;
    HealthSurveyDate.text = [self.home.healthSurveyDate ToShortString];
}



- (IBAction)SharePressed:(id)sender
{
    [self.Share ShareHome];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != DynamicSection)
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (!RegisteredCells)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CommentDetailCell" bundle:nil] forCellReuseIdentifier:@"CommentDetailCell"];
        [tableView registerNib:[UINib nibWithNibName:@"AddReviewCell" bundle:nil] forCellReuseIdentifier:@"AddReviewCell"];
        RegisteredCells = true;
    }
    if (indexPath.row == [self rowsInDynamicSection] - 1)
    {
        return [tableView dequeueReusableCellWithIdentifier:@"AddReviewCell"];
    }
    else 
    {
        CommentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentDetailCell"];
        Comment* c = [summary.comments objectAtIndex:indexPath.row];
        cell.Title.text = c.title;
        if (cell.Rating == nil) cell.Rating = [[RatingControl alloc] initWithView:cell.RatingContainer];
        [cell.Rating Rating:c.Rating];
        cell.Date.text = [c.editDate ToFriendlyShortMonthString];
        cell.PositiveVotes.text = [NSString stringWithFormat:@"%d", c.positiveVotes];
        cell.NegativeVotes.text = [NSString stringWithFormat:@"%d", c.negativeVotes];
        cell.Description.text = c.content;
        
        // Vertical align hack.  But it only works when the content is smaller than the frame size or else it overflows!
        CGSize size = [c.content sizeWithFont:cell.Description.font constrainedToSize:CGSizeMake(cell.Description.frame.size.width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        if (size.height < cell.Description.frame.size.height)
            [cell.Description sizeToFit];
        return cell;    
    }
    
}
 

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == DynamicSection)
    {
        if (indexPath.row == [self rowsInDynamicSection] - 1)
        {
            UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            CommentController* d = [s instantiateViewControllerWithIdentifier:@"CommentController"];
            d.home = self.summary;
            [self.navigationController pushViewController:d animated:YES]; 
        }
        else {
            UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            CommentListController* d = [s instantiateViewControllerWithIdentifier:@"CommentListController"];
            d.home = self.summary;
            [self.navigationController pushViewController:d animated:YES]; 
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (section == DynamicSection) 
        return [self rowsInDynamicSection];
    else return [super tableView:tableView numberOfRowsInSection:section];
}

- (int)rowsInDynamicSection
{
    return MIN(CommentDisplayLimit, [summary.comments count]) + 1; // +1 for "add comment" button
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{     
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{     
    return UITableViewCellEditingStyleNone;     
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    // if dynamic section make all rows the same height as row 0
    if (section == DynamicSection) {
        if (indexPath.row != [self rowsInDynamicSection] -1)
            return CommentHeight;
        else return AddReviewHeight;
        //return [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    
    // if dynamic section make all rows the same indentation level as row 0
    if (section == DynamicSection) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}




-(void) DirectionsToHome
{
    NSString* addr;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0)
        addr = [NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%f,%f", summary.latitude, summary.longitude];
    else
        addr = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current Location&daddr=%f,%f", summary.latitude, summary.longitude];

    NSURL* url = [[NSURL alloc] initWithString:[addr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

-(void) CallHome  
{
    
    // Save State? Application will exit after placing phone call.
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel://%@", self.home.phoneNumber]];
    [[UIApplication sharedApplication] openURL:url];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[MapController class]])
    {
        MapController *detail = segue.destinationViewController;
        detail.CurrentHome = summary;
    }
    if ([segue.destinationViewController isKindOfClass:[Detail2Controller class]])
    {
        Detail2Controller *detail = segue.destinationViewController;
        detail.home = self.home;
    }
    if ([segue.destinationViewController isKindOfClass:[CommentController class]])
    {
        CommentController *detail = segue.destinationViewController;
        detail.home = summary;
    }
    if ([segue.destinationViewController isKindOfClass:[CommentListController class]])
    {
        CommentListController *detail = segue.destinationViewController;
        detail.home = summary;
    }
    if ([segue.destinationViewController isKindOfClass:[PictureListController class]])
    {
        PictureListController *detail = segue.destinationViewController;
        detail.home = summary;
    }
}

- (IBAction)CallFacilityPressed:(id)sender {
    [self CallHome];
}

- (IBAction)DirectionsPressed:(id)sender {
    [self DirectionsToHome];
}


- (IBAction)InfoPressed:(id)sender {
    NSString* message = @"Government Quality:\nA team of state health inspectors conduct onsite health inspections, on average, about once a year. Inspectors look at the care of residents, the process of care, staff and resident interactions, and the nursing home environment. The data from the last three standard health inspections and all complaint inspections that have been conducted in the last three years were used to calculate the rating. This score is one of the components of the '5-star' rating by CMS (Centers for Medicare and Medicaid Services) found on Medicare.gov.\n\nUser Rating:\nAverage user rating.\n\nOverall:\nA rating calculated from Quality and Rating, attributing equal weighting to both.\n";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Ratings" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}




- (void)viewDidUnload
{
    [self setHomeName:nil];
    [self setQuality:nil];
    [self setOverallRating:nil];
    [self setUserRating:nil];
    [self setRank:nil];
    [self setBedCount:nil];
    [self setDistance:nil];
    [self setStreet:nil];
    [self setAddress:nil];
    [self setPhoneNumber:nil];
    [self setCategory:nil];
    [self setOwnership:nil];
    [self setOwnershipDetail:nil];
    [self setHealthSurveyDate:nil];
    [self setPhoto:nil];
    [self setUserRatingCount:nil];
    [self setOverallRealRating:nil];
    [self setQualityRealRating:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setAddPhotoLabel:nil];
    self.Share = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end

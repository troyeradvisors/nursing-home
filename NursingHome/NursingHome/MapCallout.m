//
//  MapCalloutController.m
//  NursingHome
//
//  Created by Allen Brubaker on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapCallout.h"
#import "DetailController.h"
#import <QuartzCore/QuartzCore.h>

@implementation MapCallout

@synthesize home;
@synthesize nursingHomeName;
@synthesize rating;
@synthesize numReviews;
@synthesize rowNumber;
@synthesize distance;
@synthesize rank;
@synthesize rankTotal;
@synthesize address;
@synthesize detailButton;


-(void)Update:(Summary*)h
{
    self.home = h;
 
    address.text = [h.street Trim];
    
    rowNumber.text = [NSString stringWithFormat:@"%d", h.row + 1];
    
    
    double v;
    SortType sort = [Global data].HomeFilter.Sort;
    
    numReviews.text = @"";
    NSString* reviews = @"";
    switch (sort)
    {
        case kQuality: v = h.healthInspectionRating.intValue*2.0; break;
        case kUserRating: v = h.userRating != nil ? h.userRating.doubleValue : 0.0; reviews = [NSString stringWithFormat:@"%d",h.userRatingCount]; break;
        case kDistance:
        case kOverallRating: v = h.weightedRating; reviews = [NSString stringWithFormat:@"%d",h.userRatingCount]; break;
    }
    [rating Rating:v];
    
    //numReviews.text = [NSString stringWithFormat:@"%.1f %@", v, reviews];
    numReviews.text = [NSString stringWithFormat:@"%@ reviews", reviews];
    numReviews.hidden = sort == kQuality;
    
    nursingHomeName.text = [h.name Trim];
    distance.text = h.distance < 10 ? [NSString stringWithFormat:@"%.1fmi", h.distance]:[NSString stringWithFormat:@"%.0fmi", h.distance];
    rank.text = [NSString stringWithFormat:@"%d", h.rank];
    rankTotal.text = [NSString stringWithFormat:@"%d / %d", h.rank, [Global data].FilteredHomes.count];
    
    //if (h.summary != nil && h.summary.Picture != nil)
        //photo.image = h.summary.Picture;

 
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.layer.cornerRadius = 5;  
    
}

- (void)viewDidUnload
{
    home = nil;
    address = rankTotal = rank = distance = rowNumber = numReviews = nursingHomeName = nil;
    [self setDetailButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)DetailButtonPushed:(UIButton *)sender {
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    DetailController* d = [s instantiateViewControllerWithIdentifier:@"DetailIdentifier"];
    d.summary = self.home;
    [self.navigationController pushViewController:d animated:YES];
}
@end

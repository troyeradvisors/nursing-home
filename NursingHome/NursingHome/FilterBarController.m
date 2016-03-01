//
//  FilterBarController.m
//  NursingHome
//
//  Created by Allen Brubaker on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterBarController.h"


@implementation FilterBarController

@synthesize labelSort;
@synthesize labelSearch;
@synthesize labelAddress;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) Update:(Filter*) f
{
    labelAddress.text = f.IsNearbyMe ? @"" : f.Address;
    labelSort.text = f.SortString;
    labelSearch.text = [NSString stringWithFormat:@"%d miles", (int)f.Radius];
    if ([f IsDetailFilterApplied])
    {
        CGRect frame = labelAddress.frame;
        labelAddress.frame = CGRectMake(frame.origin.x, frame.origin.y, 195, frame.size.height);
    }
    else
    {
        CGRect frame = labelAddress.frame;
        labelAddress.frame = CGRectMake(frame.origin.x, frame.origin.y, 219, frame.size.height);
    }
}












- (void)viewDidUnload
{
    [self setLabelSearch:nil];
    [self setLabelSort:nil];
    [self setLabelAddress:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

//
//  TAThirdViewController.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapController.h"
#import "MapPin.h"
#import "DetailController.h"

@implementation MapController

@synthesize CurrentHome;
@synthesize mapView;
@synthesize FilterBar;
@synthesize OverlayButton;
@synthesize Callout;
@synthesize CurrentPin;
@synthesize LocationServicesWarning;

- (bool) SingleHomeMode { return CurrentHome != nil; }

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    FilterBar = [[FilterBarController alloc] init];
    [self.view addSubview:FilterBar.view];

    if (!self.SingleHomeMode)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateData:) name:DataUpdatedNotification object:nil];
    [self UpdateData:nil];
    Callout = [[MapCallout alloc] init];    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    LocationServicesWarning.hidden = [Global data].LocationServicesEnabled || ![Global data].HomeFilter.IsNearbyMe;
}

-(UIView*)AdResizeView { return self.mapView; }


- (void) UpdateData:(NSNotification*)notification
{
    LocationServicesWarning.hidden = [Global data].LocationServicesEnabled || [Global data].FilteredHomes.count > 0;
    Filter* f = [Global data].HomeFilter;
    [FilterBar Update:f];
    [mapView removeAnnotations:mapView.annotations];
    
    double radius;
    CLLocation* center;
    if (!self.SingleHomeMode)
    {
        mapView.showsUserLocation = f.IsNearbyMe;
        [mapView addAnnotations:[Global data].FilteredHomes];
        radius = f.Radius;
        center = [Global data].Location;
        if (radius == -1)
        {
            radius = 1300;
            center = [[CLLocation alloc] initWithLatitude:39.83333333 longitude:-98.583333333];
        }
    }
    else
    {
        mapView.showsUserLocation = false;
        [mapView addAnnotation:self.CurrentHome];
        radius = 3;
        center = [[CLLocation alloc] initWithLatitude:self.CurrentHome.latitude longitude:self.CurrentHome.longitude];
    }
    
    double diameter = radius * 2 * METERS_PER_MILE;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(center.coordinate, diameter, diameter);
    [mapView setRegion:[mapView regionThatFits:viewRegion] animated:YES];
   
}

- (MKAnnotationView *)mapView:(MKMapView *)m viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[Home class]])
    {
        static NSString *identifier = @"MyLocation";   
        
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [m dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (pin == nil) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            pin.annotation = annotation;
        }
        
        
        
        pin.enabled = YES;
        pin.canShowCallout = NO;
        [pin setPinColor:MKPinAnnotationColorGreen];

        //annotationView.image=[UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
        return pin;
    }
    
    return nil; // draw pulsating blue dot
}

-(void)NavigateToHome
{
    DetailController* d = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailIdentifier"];
    d.summary = (Summary*)CurrentPin.annotation;
    [self.navigationController pushViewController:d animated:YES];
}


// Map Pin selected.
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)pin
{
    if ([pin isKindOfClass:[MKPinAnnotationView class]])
    {
        CurrentPin = pin;
        //[pin addSubview:Callout.view];
        [self UpdateOverlayButton:CurrentPin]; // Set overlay button location before animating in or it'll try to place it at an animated position!
        [self animateIn:Callout.view forPin:pin];
        [Callout Update:pin.annotation]; //For some reason adding the view to subview resets the contents.  Must manually update again!
    }

}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (CurrentPin)
        [self UpdateOverlayButton:CurrentPin];
}

-(void)UpdateOverlayButton:(MKAnnotationView*)pin
{
    if (!OverlayButton)
    {
        OverlayButton = [[UIButton alloc] init];
        OverlayButton.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0]; // invisible
        [OverlayButton addTarget:self action:@selector(NavigateToHome) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:OverlayButton];
    
    CGRect frame = Callout.detailButton.frame;
    CGPoint origin = [self GetOrigin:CurrentPin];
    
    frame.origin.x += origin.x - 8 - round(Callout.view.frame.size.width/2-8);
    frame.origin.y += origin.y - 34 - Callout.view.frame.size.height-2;
    
    OverlayButton.frame = frame;
}


-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)pin
{
    [Callout.view removeFromSuperview];
    [OverlayButton removeFromSuperview];
    CurrentPin = nil;
}


- (CGPoint) GetOrigin:(MKAnnotationView*)pin
{
    Summary* home = (Summary*)pin.annotation;
    return [mapView convertCoordinate:home.coordinate toPointToView:self.view]; 
}

- (void)animateIn:(UIView*)calloutView forPin:(MKAnnotationView*)pin
{   
    float myBubbleWidth = calloutView.frame.size.width;
    float myBubbleHeight = calloutView.frame.size.height;
    
    calloutView.frame = CGRectMake(-myBubbleWidth*0.005+8, -myBubbleHeight*0.01-2, myBubbleWidth*0.01, myBubbleHeight*0.01);
    [pin addSubview:calloutView];
    
    [UIView animateWithDuration:0.12 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        calloutView.frame = CGRectMake(-myBubbleWidth*0.55+8, -myBubbleHeight*1.1-2, myBubbleWidth*1.1, myBubbleHeight*1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^(void) {
            calloutView.frame = CGRectMake(-myBubbleWidth*0.475+8, -myBubbleHeight*0.95-2, myBubbleWidth*0.95, myBubbleHeight*0.95);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 animations:^(void) {
                calloutView.frame = CGRectMake(-round(myBubbleWidth/2-8), -myBubbleHeight-2, myBubbleWidth, myBubbleHeight);
            }];
        }];
    }];
}




- (void)viewDidUnload
{
    [self setLocationServicesWarning:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    mapView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

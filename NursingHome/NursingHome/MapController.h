//
//  TAThirdViewController.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Filter.h"
#import "FilterBarController.h"
#import "MapCallout.h"
#import "Home.h"
#import "Summary.h"

#define METERS_PER_MILE 1609.344

@interface MapController : UIViewController
    <MKMapViewDelegate>
@property (strong, nonatomic) Summary* CurrentHome;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) FilterBarController* FilterBar;
@property (strong,nonatomic) UIButton* OverlayButton;
@property (strong,nonatomic) MapCallout* Callout;
@property (strong, nonatomic) MKAnnotationView* CurrentPin;
@property (strong, nonatomic) IBOutlet UILabel *LocationServicesWarning;
@end

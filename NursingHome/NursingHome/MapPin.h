//
//  MapPin.h
//  NursingHome
//
//  Created by Allen Brubaker on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "MapCallout.h"
#import "MapController.h"

@interface MapPin : MKPinAnnotationView
@property (strong,nonatomic) MapCallout* Callout;
@property (strong,nonatomic) MapController* Root;
@end

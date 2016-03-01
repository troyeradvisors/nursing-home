//
//  TAData.h
//  NursingHome
//
//  Created by Allen Brubaker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Filter.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "StateAverage.h"
#import "CountryAverage.h"
#import "Home.h"
#import "HomeService.h"
#import "Comment.h"
#import "Picture.h"
#import "Summary.h"

extern NSString* const DataUpdatedNotification;
extern NSString* const CommentPostedNotification;
extern NSString* const PicturePostedNotification;
extern NSString* const PictureRemovedNotification;

@interface Data : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *LocationManager;
@property (strong, nonatomic) CLLocation *Location;
@property (strong, nonatomic) CLLocation *MyLocation;
@property (nonatomic, strong) Filter* HomeFilter;
@property (nonatomic, strong) NSArray* FilteredHomes;
@property (nonatomic, strong) StateAverage* HomeAverage;
@property (nonatomic) bool IsMonitoringLocation;

- (bool) ResultsTrimmed;
- (bool) LocationServicesEnabled;

- (NSManagedObjectContext*) Context;

- (void) Save;
- (void) Add:(id)object;
- (void) Delete:(id)object;
- (void) Add:(id)object Save:(bool)save;
- (void) Delete:(id)object Save:(bool)save;

-(void) UpdateFilteredHomes;
-(void) SortFilteredHomes;
-(StateAverage*) StateAverage:(NSString*)state;

// Web Service Cache
-(NSArray*)LoadSummaries;
-(Home*)LoadHome:(Summary*)s;

-(NSArray*)LoadComments:(Summary*)s;
-(NSArray*)LoadPictures:(Summary*)s;
-(NSArray*)LoadMyComment:(Summary*)s;
-(NSArray*)LoadMyPicture:(Summary*)s;

-(void) SortByScore:(NSMutableArray*)as;
@end






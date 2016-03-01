//
//  TAData.m
//  NursingHome
//
//  Created by Allen Brubaker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Data.h"
#import "SSKeychain.h"

NSString* const DataUpdatedNotification = @"DataUpdatedNotification";
NSString* const CommentPostedNotification = @"CommentPostedNotification";
NSString* const PicturePostedNotification = @"PicturePostedNotification";
NSString* const PictureRemovedNotification = @"PictureReportedNotification";

@implementation Data

@synthesize HomeFilter;
@synthesize FilteredHomes;
@synthesize LocationManager;
@synthesize Location;
@synthesize HomeAverage;
@synthesize IsMonitoringLocation;
@synthesize MyLocation;


- (id)init
{
    self = [super init];
    
    HomeFilter = [[Filter alloc] init];
    
    LocationManager = [[CLLocationManager alloc] init];
    LocationManager.delegate = self;
    LocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    LocationManager.distanceFilter = 1000.0f; //1 kilometers
    self.IsMonitoringLocation = true;
    [LocationManager startUpdatingLocation];
    return self;
}

- (bool) LocationServicesEnabled { return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized; // locationServicsEnabled checks only for global switch not for app specifically.
}

- (NSManagedObjectContext*) Context
{
    return [Global App].managedObjectContext;
}

// Saving at the end of a large batch is vastly more performant than after every object.  For 20k records it took a guy >2.5 minutes down to ~5 seconds.
- (void) Save
{
    return;
    [[Global App] saveContext];
}


- (void) Add:(id)object
{
    [self Add:object Save:true];
}
- (void) Add:(id)object Save:(bool)save
{
    if ([object isKindOfClass:[NSArray class]])
    {
        bool added = false;
        for (id o in object)
        {
            [self Add:o Save:false];
            added = true;
        }
        if (save && added) [self Save];
        return;
    }
    
    if ([object isKindOfClass:[NSManagedObject class]])
    {
        [self.Context insertObject:object];
        if (save) [self Save];
    }
}

- (void) Delete:(id)object
{
    [self Delete:object Save:true];
}
-(void) Delete:(id) object Save:(bool)save
{
    if ([object isKindOfClass:[NSArray class]])
    {
        bool added = false;
        for (id o in object)
        {
            [self Delete:o Save:false];
            added = true;
        }
        if (save && added) [self Save];
        return;
    }
    
    if ([object isKindOfClass:[NSManagedObject class]])
    {
        [self.Context deleteObject:object];
        if (save) [self Save];
    }
}




- (void) setHomeFilter:(Filter*)filter
{
    HomeFilter = filter;
    NSLog(@"Updating Homes:  Filter changed.");
    
    if (!HomeFilter.IsNearbyMe)
    {
        if (self.IsMonitoringLocation)
            [LocationManager stopUpdatingLocation];
        self.IsMonitoringLocation = false;
        self.Location = HomeFilter.AddressLocation;
        [self UpdateFilteredHomes];
    }
    else if (!self.IsMonitoringLocation && MyLocation == nil)
    {
        [self.LocationManager startUpdatingLocation];
        self.IsMonitoringLocation = true;
        // once the location is updated updateFilteredHomes is called automatically.
    }
    else [self UpdateFilteredHomes];
    
}

- (CLLocation*) Location
{
    if (HomeFilter.IsNearbyMe) return MyLocation;
    else return Location;
}


- (int) Choice:(NSNumber*)b
{
    return b == nil ? -1 : b.boolValue ? 1 : 0;
}

- (void) UpdateFilteredHomes
{
    [[Web home] LoadSummaries:self.Location.coordinate.latitude Longitude:self.Location.coordinate.longitude Radius:HomeFilter.Radius Filter:self.HomeFilter OnCompletion:^(NSArray *results)
    {

        
        // Filtering is done server side now.
        
        /*
        //// FILTER
        
        NSMutableArray *And =  [[NSMutableArray alloc]init];
        NSMutableArray* Or = [NSMutableArray array];
        
        if (HomeFilter.IsMedicaid)
            [Or addObject:@"(categoryType CONTAINS[cd] 'medicaid') OR (categoryType CONTAINS[cd] 'both')"];
        if (HomeFilter.IsMedicare)
            [Or addObject:@"(categoryType CONTAINS[cd] 'medicare') OR (categoryType CONTAINS[cd] 'both')"];
        if ([Or count] > 0)
            [And addObject:[NSString stringWithFormat:@"(%@)", [Or componentsJoinedByString:@" or "]]];
        [Or removeAllObjects];
        
        if (HomeFilter.IsInHospital)
            [Or addObject: @"(isInHospital == true)"];
        else if (HomeFilter.IsInRetirementCommunity)
            [Or addObject: @"(isInContinuingCareRetirementCommunity == true)"];
        if ([Or count] > 0)
            [And addObject:[NSString stringWithFormat:@"(%@)", [Or componentsJoinedByString:@" or "]]];
        [Or removeAllObjects];
        
        if (HomeFilter.IsForProfit)
            [Or addObject:@"ownershipType CONTAINS[cd] 'for profit'"];
        if (HomeFilter.IsNonProfit)
            [Or addObject:@"ownershipType CONTAINS[cd] 'non profit'"];
        if (HomeFilter.IsGovernment)
            [Or addObject:@"ownershipType CONTAINS[cd] 'government'"];
        if (HomeFilter.ForProfitIndividualOwned)
            [Or addObject:@"ownershipType CONTAINS[cd] 'individual'"];
        if (HomeFilter.NonProfitFaithBased)
            [Or addObject:@"ownershipType CONTAINS[cd] 'church'"];
        if ([Or count] > 0)
            [And addObject:[NSString stringWithFormat:@"(%@)", [Or componentsJoinedByString:@" or "]]];
        [Or removeAllObjects];
        
        if (!HomeFilter.IncludeChainOwned)
            [And addObject: @"(isMultipleNursingHomeOwnership == false)"];
        
        if (!HomeFilter.IncludeSpecialFocus)
            [And addObject: @"(isSpecialFocusFacility == false)"];
        
        if (!HomeFilter.IncludeCountyOwned)
            [And addObject: @"(NOT (ownershipType CONTAINS[cd] 'county'))"];  // GOVERNMENT - CITY/COUNTY, GOVERNMENT - COUNTY

        if (And.count != 0)
        {
            NSPredicate *p = [NSPredicate predicateWithFormat:[And componentsJoinedByString:@" and "]];
            results = [results filteredArrayUsingPredicate:p];
        }*/
        

        //// CALCULATE RADIUS
        
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        bool enabled = [self LocationServicesEnabled];
        double radius = HomeFilter.Radius;
        //NSLog(@"NearbyMe = %d, location=%@", HomeFilter.IsNearbyMe, self.Location);
        for (Summary* h in results)
        {
            if ([h DistanceTo:self.Location] <= radius && (enabled || !HomeFilter.IsNearbyMe)) // Call DistanceTo:Location one time to populate the field for each home object!
            {
                [temp addObject:h];
            }
        }
        results = temp;
        
        
        
        //// SORT
        
        NSSortDescriptor *sort;
        NSString *sortString;
        switch (HomeFilter.Sort) {
            case kQuality: sortString = @"healthInspectionRating"; break;
            case kUserRating: sortString = @"userRating"; break;
            case kOverallRating: sortString = @"weightedRating"; break;
            case kDistance: sortString = @"distance"; break;
        }
        sort = [[NSSortDescriptor alloc] initWithKey:sortString ascending:HomeFilter.IsAscending];
        results = [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        
        //// RANK
        
        NSArray *t = [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"weightedRating" ascending:NO]]];
        int rank = 0,i=0;
        double currentRating, lastRating = -1;
        for (Summary* s in t)
        {
            s.row = i++; // update row for map.
            currentRating = s.weightedRating;
            if (currentRating != lastRating)
                ++rank;
            lastRating = currentRating;
            s.rank = rank;
        }
        
        
        //// NOTIFY
        
        self.FilteredHomes = results;
        [self NotifyDataUpdated:results];
    
     }
    OnError:^(NSError *error)
    {
        return;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"The following error was received when trying to download homes:\n\n%@", error] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
    }];

}

-(void) SortFilteredHomes
{
    NSString *sortString;
    switch (HomeFilter.Sort) {
        case kQuality: sortString = @"healthInspectionRating"; break;
        case kUserRating: sortString = @"summary.UserRating"; break;
        case kOverallRating: sortString = @"weightedRating"; break;
        case kDistance: sortString = @"distance"; break;
    }
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:sortString ascending:HomeFilter.IsAscending];
    FilteredHomes = [FilteredHomes sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self NotifyDataUpdated:FilteredHomes];
}

-(void) NotifyDataUpdated:(NSArray*)results
{
    [[NSNotificationCenter defaultCenter] postNotificationName:DataUpdatedNotification object:results];
}

- (void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    [LocationManager stopUpdatingLocation];
    self.IsMonitoringLocation = false;
    self.MyLocation = newLocation;
    static bool firstLoad = true;
    if (!firstLoad)
        [self UpdateFilteredHomes];
    else firstLoad = false;
}

-(void) SortByScore:(NSMutableArray *)items
{
    return [items sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"Score" ascending:false]]];
}

@end

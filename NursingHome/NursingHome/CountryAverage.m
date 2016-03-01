//
//  CountryAverage.m
//  NursingHome
//
//  Created by Allen Brubaker on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CountryAverage.h"


@implementation CountryAverage

@dynamic certifiedNurseAssistantHoursPerResidentDay;
@dynamic licensedNurseHoursPerResidentDay;
@dynamic licensedStaffHoursPerResidentDay;
@dynamic occupancy;
@dynamic registeredNurseHoursPerResidentDay;
+(CountryAverage*)countryAverage
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CountryAverage" inManagedObjectContext:[[Global data] Context]];
    return (CountryAverage*)[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
}
@end

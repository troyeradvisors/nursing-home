//
//  StateAverage.h
//  NursingHome
//
//  Created by Allen Brubaker on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StateAverage : NSObject

@property (nonatomic, retain) NSNumber * certifiedNurseAssistantHoursPerResidentDay;
@property (nonatomic, retain) NSNumber * licensedNurseHoursPerResidentDay;
@property (nonatomic, retain) NSNumber * licensedStaffHoursPerResidentDay;
@property (nonatomic, retain) NSNumber * occupancy;
@property (nonatomic, retain) NSNumber * registeredNurseHoursPerResidentDay;
@property (nonatomic, retain) NSString * stateCode;
@end

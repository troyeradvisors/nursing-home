//
//  Home.m
//  NursingHome
//
//  Created by Allen Brubaker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Home.h"


@implementation Home

@synthesize categoryType, certifiedBedCount, city, councilType, countyCode, countyName, fireSurveyDate, hasQualitySurvey, healthInspectionRating, healthSurveyDate, id, isInContinuingCareRetirementCommunity, isInHospital, isMultipleNursingHomeOwnership, isSpecialFocusFacility, latitude, longitude, name, nursingRating, overallRating, ownershipType, phoneNumber, qualityRating, registeredNurseRating, residentCount, sprinklerStatus, stateCode, street, zipCode, certifiedNurseAssistantHoursPerResidentDay, registeredNurseHoursPerResidentDay, licensedNurseHoursPerResidentDay, licensedStaffHoursPerResidentDay;


- (bool) isIndividualOwned
{
    return [[self.ownershipType lowercaseString] Contains:@"individual"];
}

- (bool) isGovernmentOwned
{
    return [[self.ownershipType lowercaseString] Contains:@"government"];
}

@end

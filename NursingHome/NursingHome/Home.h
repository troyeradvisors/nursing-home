//
//  Home.h
//  NursingHome
//
//  Created by Allen Brubaker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Home : NSObject

@property (nonatomic, retain) NSString * categoryType;
@property (nonatomic, retain) NSNumber * certifiedBedCount;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * councilType;
@property (nonatomic, retain) NSNumber * countyCode;
@property (nonatomic, retain) NSString * countyName;
@property (nonatomic, retain) NSDate * fireSurveyDate;
@property (nonatomic, retain) NSNumber * hasQualitySurvey;
@property (nonatomic, retain) NSNumber * healthInspectionRating;
@property (nonatomic, retain) NSDate * healthSurveyDate;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSNumber * isInContinuingCareRetirementCommunity;
@property (nonatomic, retain) NSNumber * isInHospital;
@property (nonatomic, retain) NSNumber * isMultipleNursingHomeOwnership;
@property (nonatomic, retain) NSNumber * isSpecialFocusFacility;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * nursingRating;
@property (nonatomic, retain) NSNumber * overallRating;
@property (nonatomic, retain) NSString * ownershipType;
@property (nonatomic, retain) NSNumber * phoneNumber;
@property (nonatomic, retain) NSNumber * qualityRating;
@property (nonatomic, retain) NSNumber * registeredNurseRating;
@property (nonatomic, retain) NSNumber * residentCount;
@property (nonatomic, retain) NSString * sprinklerStatus;
@property (nonatomic, retain) NSString * stateCode;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSNumber * zipCode;
@property (nonatomic, retain) NSNumber * certifiedNurseAssistantHoursPerResidentDay;
@property (nonatomic, retain) NSNumber * registeredNurseHoursPerResidentDay;
@property (nonatomic, retain) NSNumber * licensedNurseHoursPerResidentDay;
@property (nonatomic, retain) NSNumber * licensedStaffHoursPerResidentDay;

-(bool) isIndividualOwned;
-(bool) isGovernmentOwned;



@end

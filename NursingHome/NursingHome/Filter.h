//
//  TAFilter.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum { kQuality, kUserRating, kOverallRating, kDistance } SortType; 

@interface Filter : NSObject

@property (nonatomic, strong) NSString *Search;
@property (nonatomic, strong) NSString *Address;
@property (nonatomic, strong) CLLocation *AddressLocation;
@property (nonatomic) double Radius;
@property (nonatomic) SortType Sort;
@property (nonatomic, readonly) NSString *SortString;
@property (nonatomic, readonly) BOOL IsAscending;
@property (nonatomic) bool IsNearbyMe;

@property (nonatomic) bool IsMedicaid;
@property (nonatomic) bool IsMedicare;
@property (nonatomic) bool IsInHospital;
@property (nonatomic) bool IsInRetirementCommunity;

@property (nonatomic) bool IsGovernment;
@property (nonatomic) bool IsForProfit;
@property (nonatomic) bool IsNonProfit;
@property (nonatomic) bool IncludeChainOwned, IncludeSpecialFocus, IncludeCountyOwned;
@property (nonatomic) bool NonProfitFaithBased;
@property (nonatomic) bool ForProfitIndividualOwned;

- (bool) IsDetailFilterApplied;
- (void) ClearDetail;
- (NSString*) GovernmentFundingProgramDisplay;
- (NSString*) LocationDisplay;
- (NSString*) OperatorTypeDisplay;
- (NSString*) SortLongString;
@end


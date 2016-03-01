//
//  TAFilter.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 23/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Filter.h"

@implementation Filter

@synthesize Search;
@synthesize Address;
@synthesize AddressLocation;
@synthesize Radius;
@synthesize Sort;
@synthesize IsAscending;
@synthesize SortString;
@synthesize IsMedicaid, IsMedicare, IsInHospital, IsInRetirementCommunity, IsGovernment, IsForProfit, IsNonProfit;
@synthesize NonProfitFaithBased, ForProfitIndividualOwned;
@synthesize IsNearbyMe;
@synthesize IncludeChainOwned, IncludeSpecialFocus, IncludeCountyOwned;
- (id) init
{
    self = [super init];
    Search = @"";
    Address = @"";
    Radius = 5.0;
    IsNearbyMe = true;
    Sort = kDistance;
    [self ClearDetail];
    return self;
}

- (int) Choice:(NSNumber*)b
{
    return b == nil ? -1 : b.boolValue ? 1 : 0;
}

- (bool) IsDetailFilterApplied
{
    return IsMedicaid|| IsMedicare|| IsInHospital|| IsInRetirementCommunity|| IsGovernment|| IsForProfit|| IsNonProfit|| !IncludeChainOwned|| !IncludeSpecialFocus|| NonProfitFaithBased|| ForProfitIndividualOwned || !IncludeCountyOwned;
}

- (NSString*) GovernmentFundingProgramDisplay
{
    if (self.IsMedicaid && self.IsMedicare) return @"Any";
    else if (self.IsMedicaid) return @"Medicaid";
    else if (self.IsMedicare) return @"Medicare";
    else return @"Any";
}

- (NSString*) LocationDisplay
{
    if (self.IsInHospital && self.IsInRetirementCommunity) return @"ERROR";
    else if (self.IsInHospital) return @"Hospital";
    else if (self.IsInRetirementCommunity) return @"Continuing Care";
    else return @"Any";
}

- (NSString*) OperatorTypeDisplay
{
    if (self.IsGovernment && self.IsForProfit && self.IsNonProfit) return @"Any";
    else
    {
        NSMutableArray* Or = [NSMutableArray array];
        if (self.IsGovernment) [Or addObject:@"Gov't"];
        if (self.IsNonProfit) [Or addObject:@"Non-profit"];
        else if (self.NonProfitFaithBased) [Or addObject:@"Faith"];
        if (self.IsForProfit) [Or addObject: @"For-profit"];
        else if (self.ForProfitIndividualOwned) [Or addObject:@"Individual"];
        NSString* s =  [Or componentsJoinedByString:@", "];
        return [s IsEmpty] ? @"Any" : s;
    }
}
- (NSString*) SortLongString
{
    switch (Sort) {
        case kOverallRating: return @"Overall Rating (Rank)";
        case kQuality: return @"Government Quality";
        case kUserRating: return @"User Rating";
        case kDistance: return @"Distance";
        default: return @"Unknown";
    }
}

- (NSString*) SortString
{
    switch (Sort) {
        case kOverallRating: return @"Overall";
        case kQuality: return @"Gov't";
        case kUserRating: return @"User";
        case kDistance: return @"Distance";
        default: return @"Unknown";
    }
}

- (void) ClearDetail
{
    IsMedicaid= IsMedicare= IsInHospital= IsInRetirementCommunity= IsGovernment= IsForProfit= IsNonProfit = NonProfitFaithBased= ForProfitIndividualOwned = false;
    IncludeSpecialFocus = IncludeCountyOwned = IncludeChainOwned = true;
    Sort = kDistance;
}


- (BOOL) IsAscending
{
    switch (Sort)
    {
        case kOverallRating: case kUserRating: case kQuality: return NO;
        case kDistance: return YES;
    }
}




- (id)copyWithZone:(NSZone*)zone
{
    Filter* f = [[Filter alloc] init];
    f.Search = [Search copy];
    f.Address = [Address copy];
    f.AddressLocation = [AddressLocation copy];
    f.Radius = Radius;
    f.Sort = Sort;
    f.IsNearbyMe = IsNearbyMe;
    
    f.IsMedicaid = IsMedicaid;
    f.IsMedicare = IsMedicare;
    f.IsInHospital = IsInHospital;
    f.IsInRetirementCommunity = IsInRetirementCommunity;
    f.IsGovernment = IsGovernment;
    f.IsForProfit = IsForProfit;
    f.IsNonProfit = IsNonProfit;
    f.IncludeChainOwned = IncludeChainOwned;
    f.IncludeSpecialFocus = IncludeSpecialFocus;
    f.NonProfitFaithBased = NonProfitFaithBased;
    f.ForProfitIndividualOwned = ForProfitIndividualOwned;
    f.IncludeCountyOwned = IncludeCountyOwned;
    
    return f;
}

@end

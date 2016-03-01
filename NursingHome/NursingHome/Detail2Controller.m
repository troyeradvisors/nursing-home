//
//  Detail2Controller.m
//  NursingHome
//
//  Created by Allen Brubaker on 20/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Detail2Controller.h"
#import "CountryAverage.h"
#import "StateAverage.h"

@implementation Detail2Controller
@synthesize home;
@synthesize SprinklerStatus;
@synthesize Name;
@synthesize IsInHospital;
@synthesize IsMultiOwned;
@synthesize IsSpecialFocusFacility;
@synthesize SubjectOccupancy;
@synthesize StateOccupancy;
@synthesize CountryOccupancy;
@synthesize SubjectRN;
@synthesize StateRN;
@synthesize CountryRN;
@synthesize SubjectLPN;
@synthesize StateLPN;
@synthesize CountryLPN;
@synthesize SubjectTotal;
@synthesize StateTotal;
@synthesize CountryTotal;
@synthesize SubjectCNA;
@synthesize StateCNA;
@synthesize CountryCNA;
@synthesize UpdatedDate;
@synthesize IsInCCRC;
@synthesize IsIndividualOwned;
@synthesize IsGovernmentOwned;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Global SetBackground:self.tableView];
    self.tableView.sectionFooterHeight = 2.0;
    
    Name.text = home.name;
    SprinklerStatus.text = [home.sprinklerStatus ToNormalized];
    IsInHospital.text = [home.isInHospital boolValue] ? @"Yes" : @"No";
    IsInCCRC.text = home.isInContinuingCareRetirementCommunity ? @"Yes" : @"No";
    IsGovernmentOwned.text = home.isGovernmentOwned ? @"Yes" : @"No";
    IsIndividualOwned.text = home.isIndividualOwned ? @"Yes" : @"No";
    IsMultiOwned.text = [home.isMultipleNursingHomeOwnership boolValue] ? @"Yes" : @"No";
    IsSpecialFocusFacility.text = [home.isSpecialFocusFacility boolValue] ? @"Yes" : @"No";
    
    UpdatedDate.text = [NSString stringWithFormat:@"Updated %@",[home.healthSurveyDate ToShortString]];
    
    SubjectOccupancy.text = [self ToString:[NSNumber numberWithFloat:home.residentCount.floatValue / home.certifiedBedCount.floatValue] IsPercent:true];
    SubjectRN.text = [self ToString:home.registeredNurseHoursPerResidentDay];
    SubjectLPN.text = [self ToString:home.licensedNurseHoursPerResidentDay];
    SubjectCNA.text = [self ToString:home.certifiedNurseAssistantHoursPerResidentDay];
    SubjectTotal.text = [self ToString:[NSNumber numberWithDouble:(home.registeredNurseHoursPerResidentDay.doubleValue + home.licensedNurseHoursPerResidentDay.doubleValue + home.certifiedNurseAssistantHoursPerResidentDay.doubleValue)]];
    
    [[Web home] LoadStateAverage:home.stateCode OnCompletion:^(StateAverage *state) {
        StateOccupancy.text = [self ToString:state.occupancy IsPercent:true];
        StateRN.text = [self ToString:state.registeredNurseHoursPerResidentDay];
        StateLPN.text = [self ToString:state.licensedNurseHoursPerResidentDay];
        StateTotal.text = [self ToString:[NSNumber numberWithDouble:(state.registeredNurseHoursPerResidentDay.doubleValue + state.licensedNurseHoursPerResidentDay.doubleValue + state.certifiedNurseAssistantHoursPerResidentDay.doubleValue)]];
        StateCNA.text = [self ToString:state.certifiedNurseAssistantHoursPerResidentDay];
    } OnError:^(NSError *e) {
    }];
    
    [[Web home] LoadStateAverage:@"us" OnCompletion:^(StateAverage *country) {
        CountryOccupancy.text = [self ToString:country.occupancy IsPercent:true];
        CountryRN.text = [self ToString:country.registeredNurseHoursPerResidentDay];
        CountryLPN.text = [self ToString:country.licensedNurseHoursPerResidentDay];
        CountryTotal.text = [self ToString:[NSNumber numberWithDouble:(country.registeredNurseHoursPerResidentDay.doubleValue + country.licensedNurseHoursPerResidentDay.doubleValue + country.certifiedNurseAssistantHoursPerResidentDay.doubleValue)]];
        CountryCNA.text = [self ToString:country.certifiedNurseAssistantHoursPerResidentDay];
    } OnError:^(NSError *e) {}];
    
}

- (NSString*)ToString:(NSNumber*)num
{
    return [self ToString:num IsPercent:false];
}
- (NSString*)ToString:(NSNumber*)num IsPercent:(bool)isPercent
{
    if (num == nil)
        return @"";
    NSNumberFormatter *format =[[NSNumberFormatter alloc] init];
    if (isPercent)
        format.numberStyle = NSNumberFormatterPercentStyle;  
    else
        format.positiveFormat = @".##";
    return [format stringFromNumber:num];
}

- (void)viewDidUnload
{
    [self setSprinklerStatus:nil];
    [self setName:nil];
    [self setIsInHospital:nil];
    [self setIsMultiOwned:nil];
    [self setIsSpecialFocusFacility:nil];
    [self setSubjectOccupancy:nil];
    [self setStateOccupancy:nil];
    [self setCountryOccupancy:nil];
    [self setSubjectRN:nil];
    [self setStateRN:nil];
    [self setCountryRN:nil];
    [self setSubjectLPN:nil];
    [self setStateLPN:nil];
    [self setCountryLPN:nil];
    [self setSubjectTotal:nil];
    [self setStateTotal:nil];
    [self setCountryTotal:nil];
    [self setSubjectCNA:nil];
    [self setStateCNA:nil];
    [self setCountryCNA:nil];
    [self setUpdatedDate:nil];
    [self setIsInCCRC:nil];
    [self setIsIndividualOwned:nil];
    [self setIsGovernmentOwned:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (IBAction)ShowGridTip:(id)sender {
    NSString* message = @"Occupancy:\nNursing home occupancy calculated from resident count / total certified bed count.\n\nRegistered Nurses (RN), Licensed Practical/Vocational Nurses (LPN/LVN), Certified Nursing Assistants (CNA) Hours Per Resident Per Day:\nThis was computed in two steps: (1) Compute the average total number of hours worked by (registered nurses, licensed practical/vocational nurses, licensed nursing staff, certified nursing assistants) in the nursing home each day during the 2-week period prior to the inspection.\n(2) Divide the resulting number of hours by the number of residents.\n";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)ShowDetailTip:(id)sender {
    NSString* message = @"Within Hospital:\nSpecifies whether or not the nursing home is located within a hospital.\n\nWithin CCRC:\nSpecifies whether or not the nursing home is located within a Continuing Care Retirement Community (CCRC), a community that offers other levels of care.\n\nIndividual Owned:\nSpecifies whether or not the nursing home is run by private for-profit individuals.\n\nGov't Owned:\nSpecifies whether or not the nursing home is run by a government entity.\n\nChain Owned:\nSpecifies whether or not the owner owns more than one nursing home.\n\nSpecial Focus Facility:\nIndicates nursing homes that have a record of persistently poor survey performance and have been selected for more frequent inspections and monitoring.\n\nSprinkler Status:\nLists the status of the sprinkler system installed.  (Fully, Partially, None)\n";
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Info" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
@end

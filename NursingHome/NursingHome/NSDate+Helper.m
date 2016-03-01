//
//  NSDate+Helper.m
//  NursingHome
//
//  Created by Allen Brubaker on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)


-(NSString*) ToLongString
{
    return [self ToString:@"MM/dd/yyyy hh:mm:ss a"];
}
-(NSString*) ToString:(NSString*)format
{
    if (format == nil)
        return [self ToLongString];
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    [d setDateFormat:format];
    return [d stringFromDate:self];
}
-(NSString*) ToShortString
{
    return [self ToString:@"M/d/yyyy"];
}

-(NSString*) ToFriendlyString
{
    return [self ToString:@"MMMM d, yyyy"]; 
}

-(NSString*) ToFriendlyShortMonthString
{
    return [NSString stringWithFormat:@"%@ %@", [[self ToString:@"MMMM"] substringToIndex:3], [self ToString:@"d, yyyy"] ];
}

-(NSString*) ToISOString
{
    return [self ToString:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
}
+(NSDate*) FromISOString:(NSString*)s
{
    NSDateFormatter *d = [[NSDateFormatter alloc] init];
    if ([s Contains:@"."])
        [d setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.S"];
    else {
        [d setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return [d dateFromString:s];
}

@end

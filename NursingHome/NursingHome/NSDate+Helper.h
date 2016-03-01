//
//  NSDate+Helper.h
//  NursingHome
//
//  Created by Allen Brubaker on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)
-(NSString*) ToLongString;
-(NSString*) ToString:(NSString*)format;
-(NSString*) ToShortString;
-(NSString*) ToFriendlyString;
-(NSString*) ToFriendlyShortMonthString;
-(NSString*) ToISOString;

+(NSDate*) FromISOString:(NSString*)s;
@end

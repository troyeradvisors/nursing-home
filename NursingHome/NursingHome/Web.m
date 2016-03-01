//
//  Web.m
//  NursingHome
//
//  Created by Allen Brubaker on 29/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Web.h"

@implementation Web
+ (HomeService *)home
{
    static HomeService* s = nil;
    if (!s)
    {
        s = [[HomeService alloc] init];
    }
    return s;
}
+ (SpamService *)spam
{
    static SpamService* s = nil;
    if (!s)
    {
        s = [[SpamService alloc] init];
    }
    return s;
}
@end

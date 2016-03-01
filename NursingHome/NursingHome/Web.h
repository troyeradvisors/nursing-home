//
//  Web.h
//  NursingHome
//
//  Created by Allen Brubaker on 29/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeService.h"
#import "SpamService.h"

typedef enum { kLoading, kSubmitting, kReady, kComplete} StatusType; 

@interface Web : NSObject
+ (HomeService*)home;
+ (SpamService*)spam;
@end

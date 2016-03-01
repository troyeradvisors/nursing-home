//
//  Global.h
//  NursingHome
//
//  Created by Allen Brubaker on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Data.h"


extern const NSString* APP_NAME;
extern const NSString* SERVICE_URL;
extern const bool DISABLE_ADS;
extern const NSString* APP_SHARE_URL;
extern const int COMMENT_LOAD_SIZE;
extern const int PICTURE_LOAD_SIZE;
extern const bool SHOW_SPAM_MESSAGE;

@interface Global : NSObject

+ (Data*) data;
+ (AppDelegate*) App;
+ (NSString*) UserID;
+ (NSString*) ToStars:(double)rating Max:(double)max;
+ (NSString*) GenerateGUID;
+ (void) EulaDisplayed;
+ (bool) IsEulaRequired;
+(void) SetBackground:(UITableView*)table;
+(bool)IsCommentListInstructionsNeeded;
+ (void) DisplayedCommentList;

+ (bool) IsDeviceLong;
@end

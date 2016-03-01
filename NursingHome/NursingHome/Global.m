//
//  Global.m
//  NursingHome
//
//  Created by Allen Brubaker on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Global.h"

const NSString* APP_NAME = @"NursingHome";
const NSString* SERVICE_URL = @"troyeradvisorsdashboards.com/nursinghome/api";
const bool DISABLE_ADS = false;
const NSString* APP_SHARE_URL = @"http://NursingHomeApp.com";
const int PICTURE_LOAD_SIZE = 10;
const int COMMENT_LOAD_SIZE = 20;
const bool SHOW_SPAM_MESSAGE = false;


@implementation Global


+ (Data *)data
{
    static Data* myData = nil;
    if (!myData)
    {
        myData = [[Data alloc] init];
    }
    return myData;
}

+ (AppDelegate*)App
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

+ (NSString*)UserID
{
    static NSString* uid = nil, *storeKey = @"UserID";
    uid = [[self Settings] stringForKey:storeKey];
    //NSLog(@"CloudKey: %@", [[self CloudSettings] objectForKey:storeKey]);
    if (uid == nil)
    {
        uid = [Global GenerateGUID];
        [[self Settings] setObject:uid forKey:storeKey];
        [[self Settings] synchronize];
        [[self CloudSettings] setObject:uid forKey:storeKey];
        [[self CloudSettings] synchronize]; // synchronizes asynchronousy sometime in the future.
    }
    return uid;
}

+(void) SetBackground:(UITableView*)table 
{
    UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification-background.jpg"]];
    background.frame = table.frame;
    table.backgroundView = background;
    background.contentMode = UIViewContentModeScaleToFill;
}

+(NSString*) ToStars:(double)rating Max:(double)max
{
    int r = round(rating/max * 5);
    NSString* s = @"";
    for (int i=0; i<r; ++i)
    {
        s = [s stringByAppendingString:@"• "];
    }
    return s;
}

+ (NSString *)GenerateGUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString* uuid = [NSString stringWithString:(__bridge NSString*)string];
    CFRelease(string);
    return uuid;
}
+ (NSUbiquitousKeyValueStore*) CloudSettings {return [NSUbiquitousKeyValueStore defaultStore]; }
+ (NSUserDefaults*) Settings { return [NSUserDefaults standardUserDefaults]; }

+ (NSString*) EulaKey { return @"AgreedToEula"; }
+ (bool) IsEulaRequired
{
    
    return (![self.Settings boolForKey:self.EulaKey]);
}
+ (void) EulaDisplayed
{
    [self.Settings setBool:true forKey:self.EulaKey];
    [self.Settings synchronize];
}

+ (NSString*) CommentListInstructionKey { return @"CommentListInstructions"; }
+(bool)IsCommentListInstructionsNeeded
{
    return (![self.Settings boolForKey:self.CommentListInstructionKey]);
}

+ (void) DisplayedCommentList
{
    [self.Settings setBool:true forKey:self.CommentListInstructionKey];
    [self.Settings synchronize];
}

+ (bool) IsDeviceLong
{
    double height = [[UIScreen mainScreen] bounds].size.height;
    NSLog(@"%f", height);
    return height > 500;
}

@end


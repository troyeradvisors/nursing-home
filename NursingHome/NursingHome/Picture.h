//
//  Picture.h
//  NursingHome
//
//  Created by Allen Brubaker on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface Picture : NSObject

@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString* homeID;
@property (nonatomic) int16_t negativeVotes;
@property (nonatomic) int16_t positiveVotes;
@property (nonatomic, retain) NSString * caption;
@property (nonatomic, retain) NSDate * editDate;
@property (nonatomic, retain) NSNumber * vote;
@property (nonatomic) BOOL isMine;

@property (nonatomic, strong) NSString* HighQualityUrl;
@property (nonatomic, strong) UIImage* HighQualityImage;
@property (nonatomic, retain) UIImage* Content;

-(void)copy:(Picture*)p;
-(double)Score;
@end

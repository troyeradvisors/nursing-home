//
//  Comment.h
//  NursingHome
//
//  Created by Allen Brubaker on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Comment : NSObject

@property (nonatomic) int32_t id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *editDate;
@property (nonatomic) double friendlyRating;
@property (nonatomic) double responsiveRating;
@property (nonatomic) double rehabRating;
@property (nonatomic) double appealRating;
@property (nonatomic) double odorRating;
@property (nonatomic) double mealRating;

@property (nonatomic, retain) NSString* homeID;
@property (nonatomic, retain) NSString * content;
@property (nonatomic) int16_t positiveVotes;
@property (nonatomic) int16_t negativeVotes;
@property (nonatomic, retain) NSNumber * vote;
@property (nonatomic) BOOL isMine;

- (double) Score;
-(double)Rating;
@end

//
//  Summary.h
//  NursingHome
//
//  Created by Allen Brubaker on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Home.h"
#import "Summary.h"
#import "Picture.h"
#import "Comment.h"

@interface Summary : NSObject <MKAnnotation>

@property (nonatomic, retain) NSString* homeID;
@property(nonatomic,retain) NSString* name;
@property(nonatomic,retain) NSString* street;
@property(nonatomic) double longitude;
@property(nonatomic) double latitude;
@property(nonatomic,retain) NSNumber* healthInspectionRating;
@property(nonatomic,retain) NSString* pictureUrl;


@property (nonatomic, retain) NSNumber* userRating;
@property (nonatomic) int32_t userRatingCount;
@property (nonatomic, retain) UIImage* picture;

-(void) CopyForWebService:(Summary*)copy;

@property (nonatomic, retain) NSDate *commentCacheDate;
@property (nonatomic, retain) NSDate *pictureCacheDate;
@property (nonatomic) int32_t commentCacheSize;
@property (nonatomic) int32_t pictureCacheSize;


@property (nonatomic, readonly) double distance;
-(double) weightedRating;
@property (nonatomic) int rank;
@property (nonatomic) int row;
@property (nonatomic) int matchScore;
- (double) DistanceTo:(CLLocation*)l;

-(bool)NoMorePictures;
-(bool)NoMoreComments;


- (void)UpdateMyComment:(Comment*)c;

// Web Service
@property (nonatomic, strong) Home* home;
@property (nonatomic, strong) NSMutableArray* comments;
@property (nonatomic, strong) NSMutableArray* pictures;
@property (nonatomic, strong) Picture* myPicture;
@property (nonatomic, strong) Comment* myComment;
@property (nonatomic, strong) Comment* commentSummary;

// MKAnnotation Protocol (to be able to add to map)
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

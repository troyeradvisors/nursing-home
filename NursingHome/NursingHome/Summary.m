//
//  Summary.m
//  NursingHome
//
//  Created by Allen Brubaker on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Summary.h"


@implementation Summary

@synthesize homeID, userRating, userRatingCount, name, street, longitude, latitude, healthInspectionRating, pictureUrl, commentCacheDate, commentCacheSize, pictureCacheDate, pictureCacheSize, distance, rank, row, matchScore, picture;
// Web Service
@synthesize home, comments, pictures, myPicture, myComment;


-(NSMutableArray*)comments { if (comments == nil) comments = [NSMutableArray array]; return comments; }
-(NSMutableArray*)pictures { if (pictures == nil) pictures = [NSMutableArray array]; return pictures; }


-(bool)NoMorePictures
{
    return pictures.count + 1 < self.pictureCacheSize; // +1 for my picture
}
-(bool)NoMoreComments
{
    return comments.count + 1 < self.commentCacheSize; // + 1 for my comment
}

-(void) CopyForWebService:(Summary*)copy
{
    picture = [copy.picture copy];
    self.commentCacheDate = copy.commentCacheDate;
    self.commentCacheSize = copy.commentCacheSize;
    self.pictureCacheDate = copy.pictureCacheDate;
    self.pictureCacheSize = copy.pictureCacheSize;
    self.myPicture = copy.myPicture;
    self.myComment = copy.myComment;
    self.comments = copy.comments;
    self.pictures = copy.pictures;
    self.home = copy.home;
}

- (double) weightedRating
{
    if (self.healthInspectionRating == nil && self.userRatingCount == 0)
        return 0.0;
    else if (self.healthInspectionRating == nil && self.userRating > 0)
        return self.userRating.doubleValue;
    else if (self.healthInspectionRating != nil && self.userRatingCount == 0)
        return self.healthInspectionRating.doubleValue * 2;
    else return .5 * (self.healthInspectionRating.doubleValue *2 + self.userRating.doubleValue); // convert healthInspectionRating to a scale of 10 from 5.
}

- (double) DistanceTo:(CLLocation*)l
{
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:self.latitude longitude:self.longitude];
    distance = [loc distanceFromLocation:l] / 1609.344; // meters to miles
    return distance;
}


// MKAnnotation Protocol (for map)
@synthesize coordinate;
- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D c;
    c.latitude = self.latitude;
    c.longitude = self.longitude;
    return c;
}

- (void)UpdateMyComment:(Comment*)c
{
    Summary* h = self;
    int count = h.userRatingCount;
    [[Web home] LoadCommentSummary:h OnCompletion:^(Comment *cs) {
    
        if (h.myComment == nil)
        {
            if (h.comments == nil)
                h.comments = [NSMutableArray array];
            [h.comments addObject:c];
            h.myComment = c;
            
            h.userRating = [NSNumber numberWithDouble:((h.userRating==nil?0:h.userRating.doubleValue) * count + c.Rating) / (count+1)];
            cs.friendlyRating = (cs.friendlyRating * count + c.friendlyRating) / (count+1);
            cs.rehabRating = (cs.rehabRating * count + c.rehabRating) / (count+1);
            cs.responsiveRating = (cs.responsiveRating * count + c.responsiveRating) / (count+1);
            cs.mealRating = (cs.mealRating * count + c.mealRating) / (count+1);
            cs.odorRating = (cs.odorRating * count + c.odorRating) / (count+1);
            cs.appealRating = (cs.appealRating * count + c.appealRating) / (count+1);
            h.userRatingCount++;
        }
        else {
            h.userRating = [NSNumber numberWithDouble:(h.userRating==nil?0:h.userRating.doubleValue) + (c.Rating - h.myComment.Rating) / h.userRatingCount];
            cs.friendlyRating = cs.friendlyRating + (c.friendlyRating - h.myComment.friendlyRating) / count;
            cs.rehabRating = cs.rehabRating + (c.rehabRating - h.myComment.rehabRating) / count;
            cs.responsiveRating = cs.responsiveRating + (c.responsiveRating - h.myComment.responsiveRating) / count;
            cs.mealRating = cs.mealRating + (c.mealRating - h.myComment.mealRating) / count;
            cs.odorRating = cs.odorRating + (c.odorRating - h.myComment.odorRating) / count;
            cs.appealRating = cs.appealRating + (c.appealRating - h.myComment.appealRating) / count;
            [h.myComment copy:c];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:CommentPostedNotification object:self];
        
    } OnError:^(NSError *e) {
        
    }];
    
}



@end

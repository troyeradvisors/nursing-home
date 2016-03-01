//
//  TASummaryCell.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 17/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SummaryCell.h"

@implementation SummaryCell

@synthesize nursingHomeName;
@synthesize numReviews;
@synthesize rowNumber;
@synthesize photo;
@synthesize distance;
@synthesize rank;
@synthesize rankTotal;
@synthesize rating;
@synthesize imageLoadingOperation;


- (id) initWithCoder:(NSCoder *)aDecoder    
{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void) prepareForReuse
{
    [self.imageLoadingOperation cancel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)Update:(Summary*)h
{
    photo.image = h.myPicture != nil ? h.myPicture.Content : [UIImage imageNamed:@"Icon.png"]; // in case summary had no thumbnail and the user just posted his own picture and it should replace the thumbnail.
    imageLoadingOperation = [[Web home] LoadThumbnail:h OnCompletion:^(UIImage *pic)
    {
        photo.image = pic;
    } OnError:^(NSError *e) {}];
    
    
    rowNumber.text = [NSString stringWithFormat:@"%d", h.row + 1];
    
    double v;
    SortType sort = [Global data].HomeFilter.Sort;
    
    numReviews.text = @"";
    NSString* reviews = @"";
    switch (sort)
    {
        case kQuality: v = h.healthInspectionRating.intValue*2.0; break;
        case kUserRating: v = h.userRating != nil ? h.userRating.doubleValue : 0.0; reviews = [NSString stringWithFormat:@"%d",h.userRatingCount]; break;
        case kDistance:
        case kOverallRating: v = h.weightedRating; reviews = [NSString stringWithFormat:@"%d",h.userRatingCount]; break;
    }
    [rating Rating:v];
    
    //numReviews.text = [NSString stringWithFormat:@"%.1f %@", v, reviews];
    numReviews.text = [NSString stringWithFormat:@"%@ reviews", reviews];
    numReviews.hidden = sort == kQuality;
    
    nursingHomeName.text = [h.name Trim];
    distance.text =  h.distance < 10.0 ? [NSString stringWithFormat:@"%.1f mi", h.distance] : [NSString stringWithFormat:@"%.0f mi", h.distance];
    rank.text = [NSString stringWithFormat:@"%d", h.rank];

    int x = [rank.text length];
    NSMutableString* s = [[NSMutableString alloc] init];
    for (int i=0; i<x; ++i)
        [s appendString:@" "];
    rankTotal.text = [NSString stringWithFormat:@"%d / %d", h.rank, [Global data].FilteredHomes.count];


}


@end

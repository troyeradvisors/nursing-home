//
//  RatingControl.m
//  NursingHome
//
//  Created by Allen Brubaker on 08/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RatingControl.h"

@implementation RatingControl
@synthesize FullImage, HalfImage, EmptyImage;

- (id) initWithView:(UIView*)view
{
    return [self initWithFrame:view Full:@"star-full.png" Half:@"star-half.png" Empty:@"star-empty.png"];
}


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    self.userInteractionEnabled = false;
    [self Rating:0];
    [self setBackgroundColor:[UIColor clearColor]];
    return self;
}

- (id) initWithFrame:(UIView*)view Full:(NSString*)fullPath Half:(NSString*)halfPath Empty:(NSString*)emptyPath
{
    self = [self initWithFrame:view.frame];
    view.hidden = true;
    [view.superview addSubview:self];
    view.clipsToBounds = false;
    

    return self;
}

- (void) Rating:(double)r
{
    self.userInteractionEnabled = false;
    double size = MIN(self.frame.size.height, (self.frame.size.width) / 5.0);
    //NSLog(@"%@ %@ %@", self.FullImage, self.HalfImage, self.EmptyImage);
     if (self.FullImage==nil)
     {
         self.FullImage = [UIImage imageNamed:@"star-full.png"];
         self.HalfImage = [UIImage imageNamed:@"star-half.png"];
         self.EmptyImage = [UIImage imageNamed:@"star-empty.png"];
         [self setBackgroundColor:[UIColor clearColor]];
     }
    double x = round(r)/2.0;
    int full = x;
    for (UIView* view in self.subviews)
        [view removeFromSuperview];
    for (int i=0; i<5; ++i)
    {
        UIImage* m = i<full ? FullImage : i== full && full!=x ? HalfImage : EmptyImage;
        UIImageView *v = [[UIImageView alloc] initWithImage:m];
        v.frame = CGRectMake(size*i, 0, size, size);
        [self addSubview:v];
    }
    
}


@end

//
//  MapPin.m
//  NursingHome
//
//  Created by Allen Brubaker on 23/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapPin.h"
#import "MapCallout.h"

@implementation MapPin

@synthesize Callout;
@synthesize Root;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier  
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    Callout = [[MapCallout alloc] init];
    [self setPinColor:MKPinAnnotationColorGreen];
    return self;
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (Callout)
    {
        if (selected)
        {
            //[self.superview.superview.superview addSubview:Callout.view];
            [self animateIn:Callout.view];
            [Callout Update:self.annotation]; //For some reason adding the view to subview resets the contents.  Must manually update again!
            CGRect frame = Callout.detailButton.frame;
            frame.origin.x = self.frame.origin.x;
            frame.origin.y = self.frame.origin.y;
            //NSLog(@"%f %f", frame.origin.x, frame.origin.y);
            //CGPointMake(Callout.detailButton.frame.origin.x + self.frame.origin.x, Callout.detailButton.frame.origin.y + self.frame.origin.y);
            //frame.origin.x += self.frame.origin.x;
            //frame.origin.y += self.frame.origin.y;
        }
        else {
            [Callout.view removeFromSuperview];
        }
    }
}


- (void)animateIn:(UIView*)calloutView
{   
    float myBubbleWidth = calloutView.frame.size.width;
    float myBubbleHeight = calloutView.frame.size.height;
    
    calloutView.frame = CGRectMake(-myBubbleWidth*0.005+8, -myBubbleHeight*0.01-2, myBubbleWidth*0.01, myBubbleHeight*0.01);
    [self addSubview:calloutView];
    
    [UIView animateWithDuration:0.12 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^(void) {
        calloutView.frame = CGRectMake(-myBubbleWidth*0.55+8, -myBubbleHeight*1.1-2, myBubbleWidth*1.1, myBubbleHeight*1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^(void) {
            calloutView.frame = CGRectMake(-myBubbleWidth*0.475+8, -myBubbleHeight*0.95-2, myBubbleWidth*0.95, myBubbleHeight*0.95);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.075 animations:^(void) {
                calloutView.frame = CGRectMake(-round(myBubbleWidth/2-8), -myBubbleHeight-2, myBubbleWidth, myBubbleHeight);
            }];
        }];
    }];
}

-(void) dealloc
{
    Callout = nil;
}

@end

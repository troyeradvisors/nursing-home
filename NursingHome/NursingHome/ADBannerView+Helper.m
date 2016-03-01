//
//  ADBannerView+Helper.m
//  NursingHome
//
//  Created by Allen Brubaker on 8/29/12.
//
//

#import "ADBannerView+Helper.h"



@implementation ADBannerView (Helper)


/*
- (bool) IsOnScreen
{
    double origin = [self convertPoint:self.bounds.origin toView:nil].y;
    double height = [UIScreen mainScreen].bounds.size.height;
    //NSLog(@"y=%f height=%f", origin, height);
    return origin < height;
}*/

- (void) moveOffScreen:(UIView*)with
{
    CGRect frame = with.frame;
    frame.size.height += self.frame.size.height;
    CGRect adFrame = self.frame;
    adFrame.origin.y += self.frame.size.height;
    
    [UIView beginAnimations:@"Animation" context:NULL];
    with.frame = frame;
    self.frame = adFrame;
    [UIView commitAnimations];
}

- (void) moveOnScreen:(UIView*)with
{
    CGRect frame = with.frame;
    frame.size.height -= self.frame.size.height;
    CGRect adFrame = self.frame;
    adFrame.origin.y -= self.frame.size.height;
    [UIView beginAnimations:@"Animation" context:NULL];
        with.frame = frame;
        self.frame = adFrame;
    [UIView commitAnimations];
}

@end

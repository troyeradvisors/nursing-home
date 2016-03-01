//
//  UIImageView+Helper.m
//  NursingHome
//
//  Created by Allen Brubaker on 8/27/12.
//
//

#import "UIImageView+Helper.h"

@implementation UIImageView (Helper)

-(void)Modify:(double)cornerRadius Glossy:(bool)glossy
{
    if (cornerRadius >0)
    {
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }
    if (glossy)
        self.image = [UIImageView applyIconHighlightToImage:self.image];
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

static void addGlossPath(CGContextRef context, CGRect rect) {
    CGFloat quarterHeight = CGRectGetMidY(rect) / 2;
    CGContextSaveGState(context);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, -20, 0);
    
    CGContextAddLineToPoint(context, -20, quarterHeight);
    CGContextAddQuadCurveToPoint(context, CGRectGetMidX(rect), quarterHeight * 3, CGRectGetMaxX(rect) + 20, quarterHeight);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect) + 20, 0);
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)applyIconHighlightToImage:(UIImage *)icon {
    UIImage *newImage;
    CGContextRef context;
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    CGRect currentBounds = CGRectMake(0, 0, icon.size.width, icon.size.height);
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {1.0, 1.0, 1.0, 0.75, 1.0, 1.0, 1.0, 0.2};
    
    UIGraphicsBeginImageContext(icon.size);
    context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    addRoundedRectToPath(context, currentBounds, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    [icon drawInRect:currentBounds];
    
    addGlossPath(context, currentBounds);
    CGContextClip(context);
    
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, 2);
    
    CGContextDrawLinearGradient(context, glossGradient, topCenter, midCenter, 0);
    
    UIGraphicsPopContext();
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

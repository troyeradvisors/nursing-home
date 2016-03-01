//
//  RatingControl.h
//  NursingHome
//
//  Created by Allen Brubaker on 08/08/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingControl : UIControl
@property (strong, nonatomic) UIImage *FullImage, *HalfImage, *EmptyImage;

- (id) initWithView:(UIView*)view;
-(id) initWithFrame:(CGRect)frame;
- (id) initWithFrame:(UIView*)view Full:(NSString*)full Half:(NSString*)half Empty:(NSString*)empty;
- (void) Rating:(double)r;
@end

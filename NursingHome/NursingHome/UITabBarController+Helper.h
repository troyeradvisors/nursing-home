//
//  UITabBarController+Helper.h
//  NursingHome
//
//  Created by Allen Brubaker on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Helper)

-(void)Navigate:(int)index property:(NSString*)property object:(id)object;
-(void)Navigate:(int)index;

@end

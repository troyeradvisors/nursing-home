//
//  UITabBarController+Helper.m
//  NursingHome
//
//  Created by Allen Brubaker on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITabBarController+Helper.h"

@implementation UITabBarController (Helper)




-(void)Navigate:(int)index property:(NSString*)property object:(id)object
{
    
    UIViewController* c = [self.viewControllers objectAtIndex:index];
    self.selectedViewController = c;
    if (property)
        [c setValue:object forKey:property];
}

-(void)Navigate:(int)index
{
    [self Navigate:index property:nil object:nil];
}

@end

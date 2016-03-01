//
//  AddressController.h
//  NursingHome
//
//  Created by Allen Brubaker on 16/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKmlResult.h"

@protocol AddressControllerDelegate <NSObject>

-(void)AddressControllerSelected:(BSKmlResult*) r;

@end

@interface AddressController : UITableViewController
@property (strong, nonatomic) NSArray* Places;
@property (strong, nonatomic) id <AddressControllerDelegate> delegate;
@end

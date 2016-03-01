//
//  FilterBarController.h
//  NursingHome
//
//  Created by Allen Brubaker on 22/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

@interface FilterBarController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *labelSort;
@property (strong, nonatomic) IBOutlet UILabel *labelSearch;


@property (strong, nonatomic) IBOutlet UILabel *labelAddress;
-(void)Update:(Filter*)f;

@end

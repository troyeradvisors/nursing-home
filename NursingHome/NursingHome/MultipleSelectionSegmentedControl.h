//
//  MultipleSelectionSegmentedControl.h
//  NursingHome
//
//  Created by Allen Brubaker on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISegmentedControl+Extension.h"

@interface MultipleSelectionSegmentedControl :UISegmentedControl
@property (nonatomic) bool AtMostOne;
@property( nonatomic,strong) NSMutableSet *indices;
@property(nonatomic,strong) UIColor* SelectedTintColor;
-(id)initWithItems:(NSArray *)items;
-(id)initWithItems:(NSArray *)items AtMostOne:(bool)atMostOne SelectedTintColor:(UIColor*)color;
- (NSSet *) selectedSegmentIndices;
- (void) setSelectedSegmentIndices: (NSSet *) aSet;
- (void) setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex isReversed:(BOOL) r;
- (void) reset;
@end

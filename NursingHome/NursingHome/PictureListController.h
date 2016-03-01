//
//  PictureListController.h
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Summary.h"

typedef enum { kGrid, kList } ListType;
@interface PictureListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) Summary* home;
@property (nonatomic) bool LoadingData;
@property (weak, nonatomic) IBOutlet UIScrollView *Scroller;
@property (strong, nonatomic) IBOutlet UITableView *table;


@property (nonatomic) bool loadedAllPics;
- (IBAction)Zoom:(UIPinchGestureRecognizer *)sender;
@property (nonatomic) int GridColumns;
@end

//
//  CommentListController.h
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Summary.h"


@interface CommentListController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) Summary* home;
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)InstructionsTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *Instructions;

@property (strong, nonatomic) NSMutableArray* ExpandedCells;
@end

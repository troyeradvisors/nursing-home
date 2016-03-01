//
//  SortController.h
//  NursingHome
//
//  Created by Lion User on 26/09/2012.
//
//

#import <UIKit/UIKit.h>
#import "Filter.h"
@interface SortController : UITableViewController

@property (nonatomic, strong) Filter* filter;
@property (nonatomic) int SelectedRow;
- (IBAction)TipPressed:(id)sender;
@end

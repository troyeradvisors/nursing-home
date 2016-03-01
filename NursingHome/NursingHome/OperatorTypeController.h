//
//  OperatorTypeController.h
//  NursingHome
//
//  Created by Lion User on 27/10/2012.
//
//

#import <UIKit/UIKit.h>

@interface OperatorTypeController : UITableViewController
@property (nonatomic, strong) Filter* filter;
@property (nonatomic) NSMutableArray* SelectedRows;
- (IBAction)TipPressed:(id)sender;

@end

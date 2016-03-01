//
//  LocationFilterController.h
//  NursingHome
//
//  Created by Lion User on 27/10/2012.
//
//

#import <UIKit/UIKit.h>

@interface LocationFilterController : UITableViewController
@property (nonatomic, strong) Filter* filter;
@property (nonatomic) int SelectedRow;
- (IBAction)TipPressed:(id)sender;
@end

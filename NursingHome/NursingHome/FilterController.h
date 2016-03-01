//
//  TAFirstViewController.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"
#import "MultipleSelectionSegmentedControl.h"
#import "BSForwardGeocoder.h"
#import "BSKmlResult.h"
#import "AddressController.h"
#import "FilterDetailController.h"
#import "SSKeychain.h"

@interface FilterController : UIViewController <AddressControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) Filter* HomeFilter;
@property (strong, nonatomic) IBOutlet UIImageView *WelcomeImage;
@property (strong, nonatomic) IBOutlet UITextField *tbAddress;
@property (strong, nonatomic) IBOutlet UISegmentedControl *eRadius;
@property (weak, nonatomic) IBOutlet UIButton *NearbyButton;
@property (nonatomic) bool IsNearbyMe;
@property (weak, nonatomic) IBOutlet UIButton *SearchButton;
@property (weak, nonatomic) IBOutlet UILabel *SearchButtonText;
@property (nonatomic, retain) BSForwardGeocoder *forwardGeocoder;

- (IBAction)eRadiusPressed:(UISegmentedControl *)sender;
- (IBAction)LocationButtonPressed:(id)sender;
- (IBAction)NearbyButtonPressed:(id)sender;
- (IBAction)backgroundTap:(id) sender;
- (IBAction)addressChanged:(id)sender;
@end

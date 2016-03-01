//
//  WelcomeController.h
//  NursingHome
//
//  Created by Allen Brubaker on 8/27/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EulaController.h"

@protocol WelcomeControllerDelegate <NSObject>

-(void)WelcomeControllerSelected:(int) choice;

@end

@interface WelcomeController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *WelcomeImage;
- (IBAction)SearchNearby:(id)sender;
- (IBAction)SearchCustom:(id)sender;
@property (strong, nonatomic) id <WelcomeControllerDelegate> delegate;
@end

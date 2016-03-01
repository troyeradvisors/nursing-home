//
//  EulaController.h
//  NursingHome
//
//  Created by Allen Brubaker on 8/28/12.
//
//

#import <UIKit/UIKit.h>

@protocol EulaControllerDelegate <NSObject>

-(void)EulaControllerDone;

@end
@interface EulaController : UIViewController
- (IBAction)AgreeToEula:(id)sender;
@property (strong, nonatomic) id <EulaControllerDelegate> delegate;
@end

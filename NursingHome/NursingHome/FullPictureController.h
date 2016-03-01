//
//  FullPictureController.h
//  NursingHome
//
//  Created by Allen Brubaker on 8/21/12.
//
//

#import <UIKit/UIKit.h>
#import "Picture.h"
#import "MKNetworkKit.h"
#import "MKNetworkEngine.h"
#import "Summary.h"
#import "ShareHome.h"

@interface FullPictureController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) ShareHome* ShareButtons;
@property (strong, nonatomic) Picture* picture;
@property (weak, nonatomic) IBOutlet UIScrollView *ImageScroller;
@property (strong,nonatomic) Summary* home;
@property (strong, nonatomic) MKNetworkOperation* LoadOperation;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *BusyIndicator;
@property (strong, nonatomic) IBOutlet UILabel *Description;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *Votes;
@property (strong, nonatomic) IBOutlet UIButton *LikeButton;
@property (strong, nonatomic) IBOutlet UIButton *DislikeButton;
@property (strong, nonatomic) IBOutlet UIView *InfoPanel;
@property (strong, nonatomic) NSDate* ScrollTime;
@property (weak, nonatomic) IBOutlet UIButton *CloseButton;
@property (nonatomic) int CurrentPage;
- (IBAction)CloseWindow:(id)sender;
- (IBAction)BackgroundTap:(id)sender;
- (IBAction)Like:(id)sender;
- (IBAction)Dislike:(id)sender;
- (IBAction)ReportImage:(id)sender;
- (IBAction)ShareImage:(id)sender;
@end

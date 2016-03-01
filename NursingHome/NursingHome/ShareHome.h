//
//  ShareHome.h
//  NursingHome
//
//  Created by Allen on 3/12/13.
//
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Social/Social.h>
#import "KLExpandingSelect.h"
#import "Home.h"
#import "Summary.h"
#import "Picture.h"

@interface ShareHome : KLExpandingSelect <KLExpandingSelectDataSource, KLExpandingSelectDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, weak) Home* home;
@property (nonatomic, weak) Summary* summary;
@property (nonatomic, weak) Picture* picture;

- (id)init:(Summary*)s;
- (Home*)home;
-(void)ShareHome;
-(void)SharePicture:(UIImage*)p;

@end

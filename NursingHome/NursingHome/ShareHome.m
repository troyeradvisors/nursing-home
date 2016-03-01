//
//  ShareHome.m
//  NursingHome
//
//  Created by Allen on 3/12/13.
//
//

#import "ShareHome.h"


#define kIndexTwitter 0
#define kIndexClose 2
#define kIndexFavorite 4
#define kIndexEmail 1
#define kIndexFaceBook 3


@implementation ShareHome

@synthesize summary;

- (id)init:(Summary*)s
{
    self = [super initWithDelegate:self dataSource:self];
    if (self) {
        summary = s;
        [[Global App].CurrentView setExpandingSelect:self];
    }
    return self;
}


-(Home*)home { return summary.home; }

- (void)ShareHome
{
    [self expandItemsAtPoint:CGPointMake([Global App].CurrentView.frame.size.width/2.0, [Global App].CurrentView.frame.size.height/2.0)];
}
- (void)SharePicture:(Picture*)pic
{
    self.Picture = pic;
    [self ShareHome];
}

- (NSInteger)expandingSelector:(id) expandingSelect numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (KLExpandingPetal *)expandingSelector:(id) expandingSelect itemForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* imageName = indexPath.row == kIndexTwitter ? @"petal-twitter" : indexPath.row == kIndexEmail ? @"petal-email2" :  indexPath.row == kIndexFaceBook ? @"petal-facebook" : indexPath.row == kIndexClose ? @"petal-close" : nil;
    KLExpandingPetal* petal = [[KLExpandingPetal alloc] initWithImage:[UIImage imageNamed:imageName]];
    return petal;
}
// Called after the user changes the selection.
- (void)expandingSelector:(id)expandingSelect didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage* shareImage = self.picture.Content ?: summary.picture ?: [UIImage imageNamed:@"BigIcon.png"];
    NSData* shareData = UIImageJPEGRepresentation(shareImage,1.0);
    NSString* shareUrl = APP_SHARE_URL;
    
    if (indexPath.row == kIndexEmail) {
        MFMailComposeViewController* mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setMailComposeDelegate: self];
        [mailViewController setSubject:@"Check out this nursing home!"];
        [mailViewController setMessageBody:[NSString stringWithFormat:@"<p>I want to share this with you:</p><p>%@<br/>%@<br/>%@, %@ %@<br/>%@</p><p>Found with <a href=\"%@\">%@/a>, an iPhone App.</p>", [summary.name Trim], [summary.street Trim], [self.home.city Trim], self.home.stateCode, self.home.zipCode, [[NSString stringWithFormat:@"%@", self.home.phoneNumber] FormatPhoneNumber], shareUrl, APP_NAME] isHTML:YES];
        
        [mailViewController addAttachmentData: shareData
                                     mimeType:@"image/jpeg"
                                     fileName:[NSString stringWithFormat:@"%@.jpg", summary.name]];
        [[Global App].CurrentController presentViewController: mailViewController
                           animated: YES
                         completion: nil];
        return;
    }
    else {
        SLComposeViewController* shareViewController;
        
        switch (indexPath.row) {
            case kIndexEmail:
                break;
            case kIndexFaceBook:
                shareViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [shareViewController setInitialText:[NSString stringWithFormat:@"I want to share this with you:\n\n%@\n%@\n%@, %@ %@\n%@\n\nPosted from %@, an iPhone App.\n", [summary.name Trim], [summary.street Trim], [self.home.city Trim], self.home.stateCode, self.home.zipCode, [[NSString stringWithFormat:@"%@", self.home.phoneNumber] FormatPhoneNumber], APP_NAME ]];
                [shareViewController addImage: shareImage];
                break;
            case kIndexTwitter:
                shareViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [shareViewController setInitialText:[NSString stringWithFormat:@"Check out this nursing home: %@.\n", [summary.name Trim]]];
                break;
            case kIndexClose:
                [self collapseItems];
                
                return;
            default:
                break;
        }
        [shareViewController addURL:[NSURL URLWithString:shareUrl]];
        
        if ([SLComposeViewController isAvailableForServiceType:shareViewController.serviceType]) {
            [[Global App].CurrentController presentViewController:shareViewController
                               animated:YES
                             completion: nil];
        }
        else {
            UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle: @"Service Not Supported"
                                                                 message: @"You must go to device settings and configure the service"
                                                                delegate: nil
                                                       cancelButtonTitle: nil
                                                       otherButtonTitles: nil];
            [errorAlert show];
        }
    }
    
    
}

#pragma mark - MFMailComposerDelegate callback - Not required by KLExpandingSelect
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [[Global App].NavigationController dismissViewControllerAnimated:YES completion:nil];
    
}



@end

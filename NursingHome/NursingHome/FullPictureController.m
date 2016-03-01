//
//  FullPictureController.m
//  NursingHome
//
//  Created by Allen Brubaker on 8/21/12.
//
//

#import "FullPictureController.h"


@implementation FullPictureController
@synthesize BusyIndicator;
@synthesize Description;
@synthesize InfoPanel;
@synthesize home;
@synthesize Date, Votes, LikeButton, DislikeButton;
@synthesize LoadOperation;
@synthesize picture;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.CloseButton.alpha = InfoPanel.alpha = 0.0;
    self.CloseButton.transform = CGAffineTransformMakeRotation(180.0*M_PI/180.0);
    [self updateImageScroller];
    [self scrollToPicture:picture];
    [self LoadHighQualityPicture];
    [self UpdateView:picture];
    _ImageScroller.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageScroller) name:PictureRemovedNotification object:nil];

    self.ShareButtons = [[ShareHome alloc] init:home];
    [self.view addSubview:self.ShareButtons];

    
}


- (void) LoadHighQualityPicture
{
    [self.LoadOperation cancel]; // cancel loading of last picture if swiped left/right.
    
    [[Web home] LoadHighQualityPictureURL:picture OnCompletion:^(NSString *url) {
        self.LoadOperation = [[Web home] LoadHighQualityPicture:url Picture:picture OnCompletion:^(UIImage *image) {
                [self UpdateView:picture];
        } OnError:^(NSError *e) {}];
    } OnError:^(NSError *r) {}];
    
}


- (void) UpdateView:(Picture*)p
{
    
    self.picture = p;
    Date.text = [p.editDate ToFriendlyString];
    Votes.text = [NSString stringWithFormat:@"%.0f", p.Score];
    Description.text = p.caption;
    
    UIImageView* v = [[(UIScrollView*)[_ImageScroller.subviews objectAtIndex:_CurrentPage] subviews] objectAtIndex:0];
    v.image = p.Content;
    
    
    LikeButton.enabled = DislikeButton.enabled = true; // set this to true or else if this cell reuses one that used to be IsMine comment, the opacity gets screwy.
    if (p.isMine)
    {
        LikeButton.enabled = DislikeButton.enabled = false;
        LikeButton.alpha = DislikeButton.alpha = 0;
    }
    else if (p.vote != nil)
    {
        if (p.vote.boolValue)
        {
            LikeButton.alpha = 1.0;
            DislikeButton.alpha = .35;
        }
        else
        {
            LikeButton.alpha = .35;
            DislikeButton.alpha = 1.0;
        }
    }
    else
        LikeButton.alpha = DislikeButton.alpha = .35;
}

- (void) scrollToPicture:(Picture*)p
{
    [self scrollToPicture:p Animated:NO];
}

- (void) scrollToPicture:(Picture*)p Animated:(bool)anim
{
    int index=0;
    for (index=0; index<home.pictures.count; ++index)
        if ([home.pictures objectAtIndex:index] == p)
            break;
    [self scrollToIndex:index Animated:anim];
}
- (void) scrollToIndex:(int)index Animated:(bool)anim
{
    [self.ImageScroller setContentOffset:CGPointMake(index*self.ImageScroller.frame.size.width, 0) animated:anim];
}


- (void) LoadMoreData
{
    if (home.NoMorePictures) return;
    [[Web home] LoadPictures:home LoadMore:true OnCompletion:^(NSArray *pics)
     {
         [self updateImageScroller];
     } OnError:^(NSError *e) {
     }];
    
}

-(void) resize: (UIScrollView*)scroll
{
    scroll.zoomScale=1.0;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.ImageScroller) return;
    // Page Changed Detection
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page)
    {
        UIScrollView* scroll = [[self.ImageScroller subviews] objectAtIndex:previousPage];
        if (scroll.zoomScale > 1)
        {
            // delay while paging is shifting to the next page then set zoomScale down to 1.0 for more seamless movement.
            [self performSelector:@selector(resize:) withObject:scroll afterDelay:1.0];
        }
        
        _CurrentPage = previousPage = page;
        
        [self UpdateView:[home.pictures objectAtIndex:page]];
        [self LoadHighQualityPicture];
    }
    
    // Load more detection
    if ([[NSDate date] timeIntervalSinceDate:_ScrollTime] < 2) return;
    CGFloat width = _ImageScroller.frame.size.width;
    CGFloat contentXOffset = _ImageScroller.contentOffset.x;
    CGFloat distanceFromRightSide = _ImageScroller.contentSize.width - contentXOffset;
    if (distanceFromRightSide < width) // at end of table
    {
        _ScrollTime = [NSDate date];
        [self LoadMoreData];
    }
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateImageScroller];
    [self scrollToPicture:picture];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView.subviews objectAtIndex:0];
}


- (void)updateImageScroller
{
    _ImageScroller.bounces = false;
    _ImageScroller.delegate = self;
    for (UIView* view in _ImageScroller.subviews)
        [view removeFromSuperview];
    
    [_ImageScroller setCanCancelContentTouches:NO];
    
    int spacer = 0;
    CGFloat cx = spacer;
    for (Picture* p in home.pictures)
    {
        
        CGRect rect;
        rect.size = _ImageScroller.frame.size;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:rect];
        //scroll setContentSize:
        scroll.zoomScale=1.0;
        [scroll setMinimumZoomScale:1.0];
        [scroll setMaximumZoomScale:10.0];
        scroll.delegate = self;
        scroll.scrollEnabled=true;
        scroll.bounces=false;
        
        UIImageView* view = [[UIImageView alloc] initWithImage:p.Content];
        [view setContentMode:UIViewContentModeScaleAspectFit];
        view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        
        [scroll addSubview:view];
        
        [_ImageScroller addSubview:scroll];
        cx += rect.size.width+spacer;
    }

    [_ImageScroller setContentSize:CGSizeMake(cx, [_ImageScroller bounds].size.height)];
}



- (IBAction)Like:(id)sender
{
    [self Vote:true];
}

- (IBAction)Dislike:(id)sender
{
    [self Vote:false];
}

- (void)Vote:(bool) vote
{
    if (picture.vote != nil && picture.vote.boolValue == vote) // already voted this choice before.
        return;
    
    int sub = picture.vote != nil ? 1 : 0;
    picture.vote = picture.vote != nil ? nil : [NSNumber numberWithBool:vote];
    //picture.vote = [NSNumber numberWithBool:vote];
    if (vote)
    {
        if (picture.vote != nil)
            ++picture.positiveVotes;
        picture.negativeVotes -= sub;
    }
    else
    {
        if (picture.vote != nil)
            ++picture.negativeVotes;
        picture.positiveVotes -= sub;
    }
    
    [[Web home] PostPictureVote:picture.id Vote:picture.vote OnCompletion:^{}OnError:^(NSError *e) {}];
    [self UpdateView:self.picture];
}



- (void)viewDidUnload
{
    Description = Date = Votes = LikeButton = DislikeButton =  nil;
    self.ImageScroller = nil;
    [self setInfoPanel:nil];
    [self setDescription:nil];
    [self setBusyIndicator:nil];
    [self setCloseButton:nil];
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    bool rotating = (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return rotating;
}


- (IBAction)BackgroundTap:(id)sender {
    
    [UIView beginAnimations:(InfoPanel.alpha == 0.0 ? @"fade in" : @"fade out") context:nil];
    //[UIView setAnimationDuration:1.0];
    //if (InfoPanel.hidden) [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    //else [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    self.CloseButton.alpha = InfoPanel.alpha = InfoPanel.alpha==0.0 ? 1.0 : 0.0;
    [UIView commitAnimations];
}

- (IBAction)ReportImage:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc ] initWithTitle:@"Confirm Report" message:@"You are about to report an inappropriate picture. This will remove it from your device and flag for moderation." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.LoadOperation cancel];
    [[Web home] ReportPicture:self.picture Summary:self.home];
}

- (IBAction)ShareImage:(id)sender {
    [self.ShareButtons SharePicture:self.picture];
}

- (IBAction)CloseWindow:(id)sender {
    [self.LoadOperation cancel];
    [[NSNotificationCenter defaultCenter] postNotificationName:PicturePostedNotification object:self]; // update picture list in case more pictures were loaded (by swiping left).
    [self dismissModalViewControllerAnimated:true];
}
 
@end

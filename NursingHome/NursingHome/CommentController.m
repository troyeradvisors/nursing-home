//
//  CommentController.m
//  NursingHome
//
//  Created by Allen Brubaker on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentController.h"
#import "Comment.h"


@implementation CommentController
@synthesize SubmitMessage;
@synthesize ImageScroller;
@synthesize RatingScroller;
@synthesize Content;
@synthesize ContentTitle;
@synthesize home;
@synthesize StaffLabel;
@synthesize HelpfulLabel;
@synthesize RehabilitationLabel;
@synthesize AppealLabel;
@synthesize OdorLabel;
@synthesize MealLabel;
@synthesize HomeImage;
@synthesize StaffRating, HelpfulRating, RehabilitationRating, AppealRating, OdorRating, MealRating;


@synthesize HomeName;
@synthesize SubmitButton;

NSString* DefaultContentTitle = @"Title";
NSString* DefaultContent = @"Comment";
NSDate* ScrollTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    ScrollTime = [NSDate date];
    Content.delegate = ContentTitle.delegate = self;

    //Rating  = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(0, 110, 320, 153) andStars:5 isFractional:YES];
    StaffRating  = [self AddRatingControl:StaffLabel];
    HelpfulRating  = [self AddRatingControl:HelpfulLabel];
    RehabilitationRating  = [self AddRatingControl:RehabilitationLabel];
    AppealRating  = [self AddRatingControl:AppealLabel];
    OdorRating  = [self AddRatingControl:OdorLabel];
    MealRating  = [self AddRatingControl:MealLabel];
    [RatingScroller setContentSize:CGSizeMake(0, 306)];
    [RatingScroller flashScrollIndicators];
    
    Content.text = DefaultContent;
    ContentTitle.text = DefaultContentTitle;
    
    [self updateImageScroller]; // load images instantaneously even if it's not in cache below because we need to first load BigIcon.png and optionally replace with a thumbnail if one is available since it has already been downloaded for the home detail.
    
    HomeName.text = home.name;
    
    self.Status = kLoading;
    [[Web home] LoadMyComment:home OnCompletion:^(Comment* c)
    {
        [self UpdateView:c];
        self.Status = kReady;
        
    } 
    OnError:^(NSError *e) 
    {
        self.Status = kReady;
        SubmitMessage.text = e.description; 
    }];
    
    [[Web home] LoadPictures:home LoadMore:false OnCompletion:^(NSArray *pics)
     {
         [self updateImageScroller];
     } OnError:^(NSError *e) {}];
    
    
}

-(DLStarRatingControl*)AddRatingControl:(UILabel*)l
{
    double x = 117;
    double y = l.frame.origin.y + l.frame.size.height/2.0;
    double height = 50;
    double width = 200;
    DLStarRatingControl* rating = [[DLStarRatingControl alloc] initWithFrame:CGRectMake(x, y-height/2.0-2.0, width, height) andStars:5 isFractional:NO];
    rating.rating = 0.0;
    [self.RatingScroller insertSubview:rating atIndex:0];
    return rating;
}

-(void)UpdateView:(Comment*)c
{
    if (c == nil) return;
    Content.text = [c.content copy];
    ContentTitle.text = [c.title copy];
    StaffRating.rating = c.friendlyRating/2.0;
    HelpfulRating.rating  = c.responsiveRating/2.0;
    RehabilitationRating.rating = c.rehabRating/2.0;
    AppealRating.rating = c.appealRating/2.0;
    OdorRating.rating = c.odorRating/2.0;
    MealRating.rating = c.mealRating/2.0;
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

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if ([[NSDate date] timeIntervalSinceDate:ScrollTime] < 2) return;
    CGFloat width = scrollView.frame.size.width;
    CGFloat contentXOffset = scrollView.contentOffset.x;
    CGFloat distanceFromRightSide = scrollView.contentSize.width - contentXOffset;
    if (distanceFromRightSide < width) // at end of table
    {
        ScrollTime = [NSDate date];
        [self LoadMoreData];
    }
}

- (void)updateImageScroller
{
    HomeImage.hidden = home.pictures.count > 1;
    ImageScroller.hidden = !HomeImage.hidden;
    
    if (!HomeImage.hidden)
    {
        HomeImage.image = home.picture != nil ? home.picture : [UIImage imageNamed:@"BigIcon.png"]; // need to set this because the view gets reused.
        return;
    }
    
    if (ImageScroller.hidden) return;
    
    ImageScroller.delegate = self;
    for (UIView* view in ImageScroller.subviews)
        [view removeFromSuperview];
    
    
    [ImageScroller setCanCancelContentTouches:NO];
    
    ImageScroller.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    ImageScroller.backgroundColor = [UIColor clearColor];
    ImageScroller.clipsToBounds = NO;
    ImageScroller.scrollEnabled = YES;
    ImageScroller.pagingEnabled = YES;

    int spacer = 2;
    CGFloat cx = spacer;
    int i=0;
    for (Picture* p in home.pictures)
    {
        
        CGRect rect;
        rect.size.height = ImageScroller.frame.size.height;
        rect.size.width =rect.size.height;
        rect.origin.x = cx;
        rect.origin.y = 0;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //[button setBackgroundImage:p.Content forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.tag = i++;
        
        [button addTarget:self action:@selector(ImagePressed:) forControlEvents:UIControlEventTouchUpInside];

        UIImageView* view = [[UIImageView alloc] initWithImage:p.Content];
        [view setContentMode:UIViewContentModeScaleAspectFit];
        view.frame = rect;
        button.frame = rect;
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [ImageScroller addSubview:view];
        [ImageScroller addSubview:button];
        cx += rect.size.width+spacer;
    }
    
    
    [ImageScroller setContentSize:CGSizeMake(cx, [ImageScroller bounds].size.height)];
    ImageScroller.showsVerticalScrollIndicator = NO;
    ImageScroller.showsVerticalScrollIndicator = YES;
    ImageScroller.indicatorStyle = UIScrollViewIndicatorStyleBlack;
}

-(void)ImagePressed:(id)sender
{
    int tag = ((UIControl*) sender).tag;
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FullPictureController* d = [s instantiateViewControllerWithIdentifier:@"FullPictureController"];
    d.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    d.picture = [home.pictures objectAtIndex:tag];
    d.home = home;
    [self presentModalViewController:d animated:YES];
}


-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        if (keyboardShowing)
            [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y+160);
            } completion:^(BOOL finished) {}];
        keyboardShowing = false;
        return NO;
    }
    return YES;
}

bool keyboardShowing = false;
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (!keyboardShowing)
    {
        [UIView animateWithDuration:.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^
        {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y-160);
        } completion:^(BOOL finished) {}];
    }
    if ([textView.text isEqualToString:DefaultContent] || [textView.text isEqualToString:DefaultContentTitle]) 
        textView.text = @"";
    keyboardShowing = true;
}


- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView.text Trim] IsEmpty])
        textView.text = textView == Content ? DefaultContent : DefaultContentTitle;
}



- (void)setStatus:(StatusType)s
{
    if (s == kLoading)
    {
        SubmitMessage.text = @"Loading";
        [self EnableControls:false];
    }
    if (s == kSubmitting)
    {
        SubmitMessage.text = @"Submitting";
        SubmitButton.enabled = false;
    }
    if (s == kReady || s == kComplete)
    {
        [self EnableControls:true];
        SubmitMessage.text = s == kComplete ? @"Completed" : @"Submit";
    }
}

- (void)EnableControls:(bool)enable
{
    Content.editable = ContentTitle.editable = SubmitButton.enabled = enable;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)Submit:(id)sender 
{
    Content.text = [Content.text Trim];
    ContentTitle.text = [ContentTitle.text Trim];
    bool isValid = (![Content.text IsEqualNoCase:DefaultContent] && ![Content.text IsEmpty] && ![ContentTitle.text IsEqualNoCase:DefaultContentTitle] && ![ContentTitle.text IsEmpty] && (StaffRating.rating + HelpfulRating.rating + RehabilitationRating.rating + AppealRating.rating + OdorRating.rating + MealRating.rating) > 0.0);
    if (!isValid)
    {
       SubmitMessage.text = @"Comments and at least one rating is required";
       return;
    }
    
    bool isUpdated = home.myComment == nil || ![Content.text IsEqualNoCase:home.myComment.content] || ![ContentTitle.text IsEqualNoCase:home.myComment.title] || StaffRating.rating*2.0 != home.myComment.friendlyRating || HelpfulRating.rating*2.0 != home.myComment.responsiveRating || RehabilitationRating.rating*2.0 != home.myComment.rehabRating || AppealRating.rating*2.0 != home.myComment.appealRating || OdorRating.rating*2.0 != home.myComment.odorRating || MealRating.rating*2.0 != home.myComment.mealRating;
     
    if (!isUpdated)
    {
        SubmitMessage.text = @"Edit a field first";
        return;
    }
    
    Comment* c = [[Comment alloc] init];
    c.title = ContentTitle.text;
    c.content = Content.text;
    c.friendlyRating = StaffRating.rating*2.0;
    c.responsiveRating = HelpfulRating.rating*2.0;
    c.rehabRating = RehabilitationRating.rating*2.0;
    c.appealRating = AppealRating.rating*2.0;
    c.odorRating= OdorRating.rating*2.0;
    c.mealRating = MealRating.rating*2.0;
    
    self.Status = kSubmitting;
    
    [[Web spam] IsSpam:c.content OnCompletion:^(bool isSpam)
    {
        if (!isSpam)
        {
         [[Web home] PostComment:c Summary:home OnCompletion:^
         {
             self.Status = kComplete;
         }
         OnError:^(NSError *e)
         {
             self.Status = kComplete;
             SubmitMessage.text = e.description;
         }];
        }
        else
        {
            self.Status = kComplete;
            if (SHOW_SPAM_MESSAGE)
                SubmitMessage.text = @"Detected spam.";
        }
    
    } OnError:^(NSError *e)
    {
        self.Status = kComplete;
        //SubmitMessage.text = e.description;
        SubmitMessage.text = @"Error occurred. Please try again.";
    }];
    
     

}


- (void)viewDidUnload
{
    [self setContent:nil];
    [self setHomeImage:nil];
    [self setSubmitMessage:nil];
    [self setHomeName:nil];
    [self setContentTitle:nil];
    [self setSubmitButton:nil];
    StaffRating = HelpfulRating = RehabilitationRating = AppealRating = OdorRating = MealRating = nil;
    [self setImageScroller:nil];
    [self setRatingScroller:nil];
    [self setStaffLabel:nil];
    [self setHelpfulLabel:nil];
    [self setRehabilitationLabel:nil];
    [self setAppealLabel:nil];
    [self setOdorLabel:nil];
    [self setMealLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)BackgroundTap:(id)sender {
    //[Content resignFirstResponder];
    //[ContentTitle resignFirstResponder];
}
@end

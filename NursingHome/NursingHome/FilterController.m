//
//  TAFirstViewController.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 16/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterController.h"
#import "UITabBarController+Helper.h"
#import "MultipleSelectionSegmentedControl.h"
#import "AddressController.h"
#import "SummaryController.h"
#import <QuartzCore/QuartzCore.h>
#import "Summary.h"

@implementation FilterController
@synthesize SearchButton;
@synthesize SearchButtonText;
@synthesize NearbyButton;
@synthesize tbAddress;
@synthesize WelcomeImage;
@synthesize HomeFilter;
@synthesize eRadius;

@synthesize forwardGeocoder;
@synthesize IsNearbyMe;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self LoadEula];
    
    UIFont *font = [UIFont boldSystemFontOfSize:15.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:UITextAttributeFont];
    [eRadius setTitleTextAttributes:attributes forState:UIControlStateNormal];


    self.navigationItem.hidesBackButton = true;
    tbAddress.delegate = self;
    
    [self.tbAddress setValue:[UIColor darkGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    
    self.HomeFilter = [Global data].HomeFilter;
    
    [SearchButton.imageView Modify:10.0 Glossy:NO];
    SearchButton.imageView.layer.contentsRect = CGRectMake(0, 0, 1.0, .95);
    //SearchButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    SearchButton.imageView.contentMode = UIViewContentModeScaleToFill;
    
    
    
}

- (void)DoSearch
{
    //[SearchButton2 reset];
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    SummaryController* d = [s instantiateViewControllerWithIdentifier:@"SummaryController"];
    [Global data].HomeFilter = self.HomeFilter;
    [self.navigationController pushViewController:d animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    int r = arc4random() % 5;
    WelcomeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Welcome%d.jpg", r+1]];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void) LoadEula
{
    if ([Global IsEulaRequired])
    {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        EulaController* d = [s instantiateViewControllerWithIdentifier:@"EulaController"];
        d.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:d animated:NO];
        [Global EulaDisplayed];
    }
}

- (UIActionSheet*)ShowBusyIndicator
{
    UIActivityIndicatorView *progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(-12.4, -18, 25, 25)];
    progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                     UIViewAutoresizingFlexibleRightMargin |
                                     UIViewAutoresizingFlexibleTopMargin |
                                     UIViewAutoresizingFlexibleBottomMargin);
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Retrieving Addresses"
                                                      delegate:self
                                             cancelButtonTitle:@"Stop"
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:nil];
    
    [menu addSubview:progressView];
    [menu showInView:self.view];
    //[menu setBounds:CGRectMake(0,0,320, 175)];
    [progressView startAnimating];
    return menu;
}

// Clicked stop button on progress bar
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [actionSheet cancelButtonIndex]) return; // successful
    [self.forwardGeocoder.geocodeConnection cancel];
    self.tbAddress.text= @"";
    [self LocationButtonPressed:nil];
}

- (IBAction)addressChanged:(id)sender {
    [self LocationButtonPressed:nil]; // Update enabled status of button in case address is empty or something.
    tbAddress.text = [tbAddress.text Trim];
    if ([tbAddress.text IsEmpty])
        return;
        
	if (self.forwardGeocoder == nil) {
		self.forwardGeocoder = [[BSForwardGeocoder alloc] init]; // initWithDelegate self
	}
	
    // Forward geocode!
    UIActionSheet* busy = [self ShowBusyIndicator];
    
    [self.forwardGeocoder  forwardGeocodeWithQuery:self.tbAddress.text regionBiasing:nil viewportBiasing:nil success:^(NSArray *results)
    {
        [busy dismissWithClickedButtonIndex:0 animated:YES];
        [self forwardGeocodingDidSucceed:self.forwardGeocoder withResults:results];
    } 
    failure:^(int status, NSString *errorMessage) 
    {
        [busy dismissWithClickedButtonIndex:0 animated:YES];
        NSString* message = errorMessage;
        switch (status) {
            case G_GEO_NETWORK_ERROR: message = errorMessage; break;
            case G_GEO_BAD_KEY:message = @"The API key is invalid.";break;
            case G_GEO_UNKNOWN_ADDRESS:message = [NSString stringWithFormat:@"Could not find %@", @"searchQuery"];break;
            case G_GEO_TOO_MANY_QUERIES:message = @"Too many queries has been made for this API key.";break;
            case G_GEO_SERVER_ERROR:message = @"Server error, please try again.";break;
            default:break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        self.tbAddress.text= @"";
        [self LocationButtonPressed:nil];
        [alert show];
        
    }];
    
}

- (void)forwardGeocodingDidSucceed:(BSForwardGeocoder *)geocoder withResults:(NSArray *)results
{
    if ([results count] == 0)
    {
        tbAddress.text = @""; // It shouldn't ever come here but just in case (Error should be thrown for G_GEO_UNKNOWN_ADDRESS
        [self LocationButtonPressed:nil];
    }
    else if ([results count] == 1)
    {
        BSKmlResult *place = [results objectAtIndex:0];
        HomeFilter.AddressLocation = [[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
        tbAddress.text = place.address;
        [self LocationButtonPressed:nil];
    }
    else if ([results count] > 1)
    {
        
        //AddressController* d = [[AddressController alloc] init];
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        AddressController* c = [s instantiateViewControllerWithIdentifier:@"AddressController"];
        c.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        c.Places = results;
        c.delegate = self;
        [self.navigationController presentModalViewController:c animated:YES];
    }
    
    // Dismiss the keyboard
    [self.tbAddress resignFirstResponder];
}		

- (void)AddressControllerSelected:(BSKmlResult*)place
{
    HomeFilter.AddressLocation = [[CLLocation alloc] initWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    tbAddress.text = place.address;
    [self LocationButtonPressed:nil];
    [self dismissModalViewControllerAnimated:true];
}
    

- (void) setHomeFilter:(Filter *)filter
{
    HomeFilter = [filter copy];
    tbAddress.text = [HomeFilter.Address copy];
    
    eRadius.selectedSegmentIndex = (HomeFilter.Radius == 3 ? 0 : HomeFilter.Radius == 5 ? 1 : HomeFilter.Radius == 10 ? 2 : 3);
    IsNearbyMe = filter.IsNearbyMe;
    if (IsNearbyMe)
        [self NearbyButtonPressed:nil];
    else
        [self LocationButtonPressed:nil];
}

- (Filter*) HomeFilter
{
    int i;
    HomeFilter.Address = [tbAddress.text Trim];
    i = eRadius.selectedSegmentIndex;
    HomeFilter.Radius = (i == 0 ? 3 : i == 1 ? 5 : i == 2 ? 10 : 20);
    HomeFilter.IsNearbyMe = self.IsNearbyMe;
    return HomeFilter;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.destinationViewController isKindOfClass:[SummaryController class]])
    {
        [Global data].HomeFilter = self.HomeFilter;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return false;
}

- (IBAction)backgroundTap:(id)sender
{
    [tbAddress resignFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(UIView*)AdResizeView { return nil; }//self.WelcomeImage; }


- (void)viewDidUnload
{
    WelcomeImage = nil;
    tbAddress = nil;
    eRadius = nil;
    NearbyButton = nil;
    SearchButton = nil;
    SearchButtonText = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (IBAction)LocationButtonPressed:(id)sender
{
    isNearbyPressed = false;
    [NearbyButton setHighlighted:false];
    tbAddress.placeholder = @"Zip / City";
    IsNearbyMe = false;
    NearbyButton.imageView.layer.contentsRect = CGRectMake(0, 0, 0, 0); // hide image
    NearbyButton.alpha = .6;
    SearchButtonText.enabled = SearchButton.enabled = ![[tbAddress.text Trim] IsEmpty];
    tbAddress.enabled = true;
}
static bool isNearbyPressed = false;
- (IBAction)NearbyButtonPressed:(id)sender {
    
     if (isNearbyPressed)
     {
         isNearbyPressed = false;
         [self LocationButtonPressed:nil];
         return;
     }
    isNearbyPressed = true;
    [tbAddress resignFirstResponder];
    tbAddress.placeholder = @"Nearby";
    tbAddress.text = @"";
    //[self onTouchup:NearbyButton];
    
    NearbyButton.imageView.layer.contentsRect = CGRectMake(0, 0, 1.0, .95);//show image
    NearbyButton.alpha = .9;
    [NearbyButton.imageView Modify:9.0 Glossy:NO];
    NearbyButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    IsNearbyMe = true;
    SearchButtonText.enabled = SearchButton.enabled = true;
}

- (void)highlightButton:(UIButton *)b {
    [b setHighlighted:YES];
}

- (void)onTouchup:(UIButton *)sender {
    [self performSelector:@selector(highlightButton:) withObject:sender afterDelay:0.01];
}
- (IBAction)eRadiusPressed:(UISegmentedControl *)sender {
    
}
@end

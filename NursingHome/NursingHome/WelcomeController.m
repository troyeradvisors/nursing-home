//
//  WelcomeController.m
//  NursingHome
//
//  Created by Allen Brubaker on 8/27/12.
//
//

#import "WelcomeController.h"

@implementation WelcomeController

@synthesize WelcomeImage;
@synthesize delegate;

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

    [self LoadEula];
    
    int r = arc4random() % 5;
    WelcomeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Welcome%d.jpg", r+1]];
    [WelcomeImage Modify:9.0 Glossy:NO];
}



- (void) LoadEula
{
    static NSString* EulaKey = @"AgreedToEula";
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if (![settings boolForKey:EulaKey])
    {
        UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        EulaController* d = [s instantiateViewControllerWithIdentifier:@"EulaController"];
        d.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:d animated:NO];
        [settings setBool:true forKey:EulaKey];
        [settings synchronize];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}


- (IBAction)SearchNearby:(id)sender
{
    [delegate WelcomeControllerSelected:0];
    [self dismissModalViewControllerAnimated:true];
}

- (IBAction)SearchCustom:(id)sender
{
    [delegate WelcomeControllerSelected:1];
    [self dismissModalViewControllerAnimated:true];
}




- (void)viewDidUnload
{
    [self setWelcomeImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




@end

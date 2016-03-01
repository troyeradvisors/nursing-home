//
//  EulaController.m
//  NursingHome
//
//  Created by Allen Brubaker on 8/28/12.
//
//

#import "EulaController.h"

@interface EulaController ()

@end

@implementation EulaController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)AgreeToEula:(id)sender {
    [self dismissModalViewControllerAnimated:true];
    [self.delegate EulaControllerDone];
}


@end

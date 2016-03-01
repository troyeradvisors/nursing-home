//
//  PictureCell.m
//  NursingHome
//
//  Created by Thomas Strausbaugh on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PictureCell.h"

@implementation PictureCell

@synthesize LikeButton, DislikeButton, Description, Date, Votes, Image, home, Navigator;
@synthesize picture;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) UpdateView:(Picture *)p Summary:(Summary*)h Navigator:(PictureListController *)c
{
    Navigator = c;
    self.home = h;
    picture = p;
    Image.image = p.Content;
    Date.text = [p.editDate ToFriendlyString];
    Votes.text = [NSString stringWithFormat:@"%.0f", p.Score];
    Description.text = p.caption;
    
    LikeButton.enabled = DislikeButton.enabled = true; // set this to true or else if this cell reuses one that used to be IsMine comment, the opacity gets screwy.
    if (p.isMine)
    {
        LikeButton.enabled = DislikeButton.enabled = false;
        LikeButton.alpha = DislikeButton.alpha = .25;
    }
    else if (p.vote != nil)
    {
        if (p.vote.boolValue)
        {
            LikeButton.alpha = 1.0;
            DislikeButton.alpha = .25;
        }
        else
        {
            LikeButton.alpha = .25;
            DislikeButton.alpha = 1.0;
        }
    }
    else
        LikeButton.alpha = DislikeButton.alpha = .25;
   
    
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
    
    [self UpdateView:picture Summary:self.home Navigator:self.Navigator];
    
    [[Web home] PostPictureVote:picture.id Vote:picture.vote OnCompletion:^{}OnError:^(NSError *e) {}];
}

- (IBAction)ImagePressed:(id)sender {
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FullPictureController* d = [s instantiateViewControllerWithIdentifier:@"FullPictureController"];
    d.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    d.picture = self.picture;
    d.home = self.home;
    [Navigator presentModalViewController:d animated:YES];
}
@end

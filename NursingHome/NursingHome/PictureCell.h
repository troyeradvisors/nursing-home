//
//  PictureCell.h
//  NursingHome
//
//  Created by Thomas Strausbaugh on 01/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picture.h"
#import "FullPictureController.h"
#import "Summary.h"
#import "PictureListController.h"
@interface PictureCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *Description;
@property (strong, nonatomic) Summary* home;
@property (strong,nonatomic) PictureListController* Navigator;
@property (strong, nonatomic) IBOutlet UILabel *Date;
@property (strong, nonatomic) IBOutlet UILabel *Votes;
@property (strong, nonatomic) IBOutlet UIImageView *Image;
@property (strong, nonatomic) IBOutlet UIButton *LikeButton;
@property (strong, nonatomic) IBOutlet UIButton *DislikeButton;
- (IBAction)Like:(id)sender;
- (IBAction)Dislike:(id)sender;
@property (strong, nonatomic) Picture *picture;
- (IBAction)ImagePressed:(id)sender;
- (void)UpdateView:(Picture*)p Summary:(Summary*)h Navigator:(PictureListController*)c;
@end

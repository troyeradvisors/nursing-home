//
//  Picture.m
//  NursingHome
//
//  Created by Allen Brubaker on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Picture.h"


@implementation Picture

@synthesize id, homeID, negativeVotes, positiveVotes, caption, editDate, vote, isMine;
@synthesize Content, HighQualityUrl, HighQualityImage;

-(double)Score { return self.positiveVotes-self.negativeVotes; }


-(void)copy:(Picture*)p
{
    //self.id = p.id;
    self.homeID = [p.homeID copy];
    //self.negativeVotes = p.negativeVotes;
    //self.positiveVotes = p.positiveVotes;
    Content = [p.Content copy];
    self.caption = [p.caption copy];
    self.editDate = [p.editDate copy];
    self.vote = p.vote;
    self.isMine = p.isMine;
}


-(UIImage*)Content
{
    return HighQualityImage ?: Content;
}

@end

//
//  Comment.m
//  NursingHome
//
//  Created by Allen Brubaker on 12/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Comment.h"
@implementation Comment

@synthesize id, title, editDate, homeID, content, positiveVotes, negativeVotes, vote, isMine, rehabRating, appealRating, odorRating, mealRating;


-(double)Score { return self.positiveVotes - self.negativeVotes; }

-(void)copy:(Comment*)p
{
    //self.id = p.id;
    self.homeID = [p.homeID copy];
    //self.negativeVotes = p.negativeVotes;
    //self.positiveVotes = p.positiveVotes;
    self.content = [p.content copy];
    self.title = [p.title copy];
    self.friendlyRating = p.friendlyRating;
    self.responsiveRating = p.responsiveRating;
    self.rehabRating = p.rehabRating;
    self.appealRating = p.appealRating;
    self.odorRating = p.odorRating;
    self.mealRating = p.mealRating;
    self.editDate = [p.editDate copy];
    self.vote = p.vote;
    self.isMine = p.isMine;
}
-(double)Rating
{
    double sum = _friendlyRating+_responsiveRating+rehabRating+appealRating+odorRating+mealRating;
    if (sum == 0) return 0;
    return (_friendlyRating+_responsiveRating+rehabRating+appealRating+odorRating+mealRating)/((_friendlyRating==0?0:1)+(_responsiveRating==0?0:1)+(rehabRating==0?0:1)+(appealRating==0?0:1)+(odorRating==0?0:1)+(mealRating==0?0:1));
}



@end

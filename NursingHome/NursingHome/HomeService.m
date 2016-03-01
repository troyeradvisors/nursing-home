//
//  HomeService.m
//  NursingHome
//
//  Created by Allen Brubaker on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeService.h"
#import "Home.h"
#import "Summary.h"
#import "NSData+Base64.h"
#import "MKNetworkKit.h"


@implementation HomeService

-(id)init
{
    self = [super initWithHostName:SERVICE_URL];
    //customHeaderFields:[NSDictionary dictionaryWithObjectsAndKeys:@"application/json", @"accept", nil]];
    [self useCache];

    return self;
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"HomeServiceCache"];
    return cacheDirectoryName;
}

-(MKNetworkOperation*) LoadThumbnail:(Summary*)summary OnCompletion:(ImageResponseBlock)completion OnError:(ErrorBlock)error
{
    
    MKNetworkOperation* op = [self imageAtURL:[NSURL URLWithString:summary.pictureUrl] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache)
    {
        summary.picture = fetchedImage;
        completion(summary.picture);
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {}];
    return op;
}


-(void) LoadSummaries:(double)latitude Longitude:(double)longitude Radius:(double)radius Filter:(Filter*)filter OnCompletion:(ListResponseBlock)completion OnError:(ErrorBlock)error
{
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithDouble:latitude], @"latitude",
                            [NSNumber numberWithDouble:longitude], @"longitude",
                            [NSNumber numberWithDouble:radius], @"radius",
                            filter.IsMedicaid?@"true":@"false", @"IsMedicaid",
                            filter.IsMedicare?@"true":@"false", @"IsMedicare",
                            filter.IsInHospital?@"true":@"false", @"IsInHospital",
                            filter.IsInRetirementCommunity?@"true":@"false", @"IsInRetirementCommunity",
                            filter.IsForProfit?@"true":@"false", @"IsForProfit",
                            filter.IsNonProfit?@"true":@"false", @"IsNonProfit",
                            filter.IsGovernment?@"true":@"false", @"IsGovernment",
                            filter.ForProfitIndividualOwned?@"true":@"false", @"ForProfitIndividualOwned",
                            filter.NonProfitFaithBased?@"true":@"false", @"NonProfitFaithBased",
                            filter.IncludeChainOwned?@"true":@"false", @"IncludeChainOwned",
                            filter.IncludeSpecialFocus?@"true":@"false", @"IncludeSpecialFocus",
                            filter.IncludeCountyOwned?@"true":@"false", @"IncludeCountyOwned",
                            nil];
                            
    MKNetworkOperation *op = [self operationWithPath:@"Summary" params:params httpMethod:@"GET"];
    NSLog(@"%@", op);
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         NSMutableArray* downloads = [[NSMutableArray alloc] init];
         for (NSDictionary* response in completedOperation.responseJSON)
         {
             Summary* s = [[Summary alloc] init];
             s.homeID = [[response objectForKey:@"HomeID"] uppercaseString];
             s.userRating = [response objectForKey:@"UserRating"];
             s.userRatingCount = [(NSNumber*)[response objectForKey:@"UserRatingCount"] intValue];
             s.pictureUrl = [response objectForKey:@"ContentUrl"];
             s.healthInspectionRating = [response objectForKey:@"HealthInspectionRating"];
             s.latitude = [(NSNumber*)[response objectForKey:@"Latitude"] doubleValue];
             s.longitude = [(NSNumber*)[response objectForKey:@"Longitude"] doubleValue];
             s.name = [response objectForKey:@"Name"];
             s.street = [response objectForKey:@"Street"];
             
             [downloads addObject:s];
         }
         
         //[Global data].AllHomes = [NSMutableArray arrayWithArray:downloads];
         
         completion(downloads);
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
         error(e);
     }];
    
    
    [self enqueueOperation:op ];
}



-(void) LoadHome:(Summary*)summary OnComplete:(HomeResponseBlock)completion OnError:(ErrorBlock)error
{
    MKNetworkOperation *op = [self operationWithPath:@"Facility" params:[NSDictionary dictionaryWithObjectsAndKeys:summary.homeID, @"id", nil] httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        if ([completedOperation.responseJSON count] == 0) return;
        
        NSDictionary* response = completedOperation.responseJSON;
    
        Home* h = [[Home alloc] init];
        h.id = [[response objectForKey:@"ID"] uppercaseString];
        h.categoryType = [response objectForKey:@"CategoryType"];
        h.certifiedBedCount =  [response objectForKey:@"CertifiedBedCount"];
        h.city = [response objectForKey:@"City"];
        h.councilType = [response objectForKey:@"CouncilType"];
        h.countyCode = [response objectForKey:@"CountyCode"];
        h.countyName = [response objectForKey:@"CountyName"];
        h.fireSurveyDate = [NSDate FromISOString:[response objectForKey:@"FireSurveyDate"]];
        h.hasQualitySurvey = [response objectForKey:@"HasQualitySurvey"];
        h.healthInspectionRating = [response objectForKey:@"HealthInspectionRating"];
        h.healthSurveyDate = [NSDate FromISOString:[response objectForKey:@"HealthSurveyDate"]];
        h.isInContinuingCareRetirementCommunity = [response objectForKey:@"IsInContinuingCareRetirementCommunity"];
        h.isInHospital = [response objectForKey:@"IsInHospital"];
        h.isMultipleNursingHomeOwnership = [response objectForKey:@"IsMultipleNursingHomeOwnership"];
        h.isSpecialFocusFacility = [response objectForKey:@"IsSpecialFocusFacility"];
        h.latitude = [response objectForKey:@"Latitude"];
        h.longitude = [response objectForKey:@"Longitude"];
        h.name = [response objectForKey:@"Name"];
        h.nursingRating = [response objectForKey:@"NursingRating"];
        h.overallRating = [response objectForKey:@"OverallRating"];
        h.ownershipType = [response objectForKey:@"OwnershipType"];
        h.phoneNumber = [response objectForKey:@"PhoneNumber"];
        h.qualityRating = [response objectForKey:@"QualityRating"];
        h.registeredNurseRating = [response objectForKey:@"RegisteredNurseRating"];
        h.residentCount = [response objectForKey:@"ResidentCount"];
        h.sprinklerStatus = [response objectForKey:@"SprinklerStatus"];
        h.stateCode = [response objectForKey:@"StateCode"];
        h.street = [response objectForKey:@"Street"];
        h.zipCode = [response objectForKey:@"ZipCode"];
        h.certifiedNurseAssistantHoursPerResidentDay = [response objectForKey:@"CertifiedNurseAssistantHoursPerResidentDay"];
        h.registeredNurseHoursPerResidentDay = [response objectForKey:@"RegisteredNurseHoursPerResidentDay"];
        h.licensedNurseHoursPerResidentDay = [response objectForKey:@"LicensedNurseHoursPerResidentDay"];
        h.licensedStaffHoursPerResidentDay = [response objectForKey:@"LicensedStaffHoursPerResidentDay"];
        
        summary.home = h;
        completion(h);

    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
        error(e);
    }];
    
    [self enqueueOperation:op];
}

-(void) LoadStateAverage:(NSString*)state OnCompletion:(StateAverageResponseBlock)completion OnError:(ErrorBlock)error
{
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"StateAverage/%@", state] params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
        
        NSDictionary* response = completedOperation.responseJSON;
        
        if (response.count == 0) return;
        
        StateAverage* h = [[StateAverage alloc] init];
        h.stateCode = [response objectForKey:@"StateCode"];
        h.certifiedNurseAssistantHoursPerResidentDay = [response objectForKey:@"CertifiedNurseAssistantHoursPerResidentDay"];
        h.registeredNurseHoursPerResidentDay = [response objectForKey:@"RegisteredNurseHoursPerResidentDay"];
        h.licensedNurseHoursPerResidentDay = [response objectForKey:@"LicensedNurseHoursPerResidentDay"];
        h.licensedStaffHoursPerResidentDay = [response objectForKey:@"LicensedStaffHoursPerResidentDay"];
        h.occupancy = [response objectForKey:@"Occupancy"];
     
        completion(h);
        
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
        error(e);
    }];
    
    [self enqueueOperation:op ];
    
}



-(void) UpdateVotes:(NSArray*)to From:(NSArray*)from
{
    NSArray* sorts = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:true]]; // id might need to be NSNumeric instead of int
    NSArray* bb = [to sortedArrayUsingDescriptors:sorts];
    NSArray* aa = [from sortedArrayUsingDescriptors:sorts];
    
    // 2 fingers
    for (int i=0,j=0; i<aa.count && j<bb.count; )
    {
        id a = [aa objectAtIndex:i], b = [bb objectAtIndex:j]; 
        int aID = (int)[a valueForKey:@"id"], bID = (int)[b valueForKey:@"id"];
        if (aID == bID)
        {
            NSNumber* vote = [a valueForKey:@"vote"];
            [b setValue:vote forKey:@"vote"];         
            ++i; ++j;
        }
        else if (aID < bID)
            ++i;
        else 
            ++j;
    }
     
}

-(void) LoadComments:(Summary*)home LoadMore:(bool)loadMore OnCompletion:(ListResponseBlock)completion OnError:(ErrorBlock)error
{
 
    if (home.NoMoreComments)
    {
        completion(home.comments);
        return;
    }
    
    int skip = !loadMore ? 0 : home.commentCacheSize;
    int take = COMMENT_LOAD_SIZE;
    
    NSString* path = [NSString stringWithFormat:@"Comment?HomeID=%@&IncludeMyVotes=%@&Skip=%d&Take=%d", home.homeID, Global.UserID, skip, take];
    MKNetworkOperation *op = [self operationWithPath:path params:nil httpMethod:@"GET"];
    
    NSLog(@"%@", op);
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
         NSMutableArray* comments = [[NSMutableArray alloc] init];
         for (NSDictionary* response in completedOperation.responseJSON)
         {
             Comment* comment = [[Comment alloc] init];
             comment.id = [(NSNumber*)[response objectForKey:@"ID"] intValue];
             comment.homeID = [[response objectForKey:@"HomeID"] uppercaseString];
             
             comment.friendlyRating = [(NSNumber*)[response objectForKey:@"FriendlyRating"] doubleValue];
             comment.rehabRating = [(NSNumber*)[response objectForKey:@"RehabilitationRating"] doubleValue];
             comment.appealRating = [(NSNumber*)[response objectForKey:@"PhysicalAppealSafetyRating"] doubleValue];
             comment.odorRating = [(NSNumber*)[response objectForKey:@"OdorRating"] doubleValue];
             comment.mealRating = [(NSNumber*)[response objectForKey:@"MealExperienceRating"] doubleValue];
             comment.responsiveRating = [(NSNumber*)[response objectForKey:@"ResponsiveRating"] doubleValue];
             
             comment.editDate = [NSDate FromISOString:[response objectForKey:@"EditDate"]];
             comment.title = [response objectForKey:@"Title"];
             comment.content = [response objectForKey:@"Content"];
             comment.positiveVotes = [(NSNumber*)[response objectForKey:@"PositiveVotes"] intValue];
             comment.negativeVotes = [(NSNumber*)[response objectForKey:@"NegativeVotes"] intValue];
             comment.isMine =  [[response objectForKey:@"UserID"] IsEqualNoCase:Global.UserID];
             comment.vote = [response objectForKey:@"MyVote"];
             
             [comments addObject:comment];
         }

        
         // merge with existing comments (there could be duplicates because of the asynchronous nature of take/skip and default ordering at server being score and not unique ID)
         int size = home.comments.count;
         bool found;
         for (Comment *c in comments)
         {
             if (c.isMine)
                 home.myComment = c;
             found = false;
             for (int i=0; i<size; ++i)
             {
                 if (((Comment*)[home.comments objectAtIndex:i]).id == c.id)
                 {
                     //c.vote = ((Comment*)[home.comments objectAtIndex:i]).vote;
                     [home.comments replaceObjectAtIndex:i withObject:c];
                     found = true;
                     break;
                 }
             }
             if (!found)
                [home.comments addObject:c];
            
         }
        
        home.commentCacheSize = MAX(home.commentCacheSize,skip+take);
        
        if (home.comments>0)
            [[Global data] SortByScore:home.comments];
        
        NSLog(@"CommentCacheSize=%d NoMoreComments=%d", home.commentCacheSize, home.NoMoreComments);
        
        completion(home.comments);
     
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *er) {
         error(er);
     }];
    
    [self enqueueOperation:op ];
}


-(void) LoadHighQualityPictureURL:(Picture*)p OnCompletion:(StringResponseBlock)completion OnError:(ErrorBlock)error
{
    MKNetworkOperation* op = [self operationWithPath:[NSString stringWithFormat:@"Picture/%d", p.id] params:nil httpMethod:@"GET"];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
         NSDictionary* response = completedOperation.responseJSON;
         p.HighQualityUrl = [response objectForKey:@"ContentUrl"];
        completion(p.HighQualityUrl);
        
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
         
         error(e);
     }];
    
    [self enqueueOperation:op];
}


-(MKNetworkOperation*) LoadHighQualityPicture:(NSString*)url Picture:(Picture*)p OnCompletion:(ImageResponseBlock)completion OnError:(ErrorBlock)error
{
    MKNetworkOperation *op = [self imageAtURL:[NSURL URLWithString:p.HighQualityUrl] completionHandler:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache)
               {
                   p.HighQualityImage = fetchedImage;
                   completion(fetchedImage);
               } errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {error(e);}];

    return op;
}


-(void) LoadPictures:(Summary*)home LoadMore:(bool)loadMore OnCompletion:(ListResponseBlock)completion OnError:(ErrorBlock)error
{
    if (home.NoMorePictures)
    {
        (completion(home.pictures));
        return;
    };
    
    int skip = home.pictureCacheSize;
    int take = PICTURE_LOAD_SIZE;
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"Picture?HomeID=%@&IncludeMyVotes=%@&Skip=%d&Take=%d", home.homeID, Global.UserID, skip, take] params:nil httpMethod:@"GET"];
    NSLog(@"%@", op);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
     
        NSMutableArray* pictures = [[NSMutableArray alloc] init];
        for (NSDictionary* response in completedOperation.responseJSON)
        {
            Picture* picture = [[Picture alloc] init];
            picture.id = [(NSNumber*)[response objectForKey:@"ID"] intValue];
            picture.homeID = [[response objectForKey:@"HomeID"] uppercaseString];
            //picture.contentData = [NSData dataWithBase64EncodedString:(NSString*)[response objectForKey:@"Content"]];
            picture.Content = [UIImage imageWithData:[NSData dataWithBase64EncodedString:(NSString*)[response objectForKey:@"Content"]]];
            picture.editDate = [NSDate FromISOString:[response objectForKey:@"EditDate"]];
            picture.caption = [response objectForKey:@"Caption"];
            picture.positiveVotes = [(NSNumber*)[response objectForKey:@"PositiveVotes"] intValue];
            picture.negativeVotes = [(NSNumber*)[response objectForKey:@"NegativeVotes"] intValue];
            picture.isMine =  [[response objectForKey:@"UserID"] IsEqualNoCase:Global.UserID];
            picture.vote = [response objectForKey:@"MyVote"];
            
            [pictures addObject:picture];
        }
        // merge with existing comments (there could be duplicates because of the asynchronous nature of take/skip and default ordering at server being score and not unique ID)
        int size = home.pictures.count;
        bool found;
        for (Picture *p in pictures)
        {
            if (p.isMine)
                home.myPicture = p;
            found = false;
            for (int i=0; i<size; ++i)
            {
                if (((Picture*)[home.pictures objectAtIndex:i]).id == p.id)
                {
                    //p.vote = ((Picture*)[home.pictures objectAtIndex:i]).vote;
                    [home.pictures replaceObjectAtIndex:i withObject:p];
                    found = true;
                    break;
                }
            }
            if (!found)
                [home.pictures addObject:p];
        }
        
        home.pictureCacheSize = MAX(home.pictureCacheSize,skip+take);
        
        NSLog(@"PictureCacheSize=%d NoMorePics=%d", home.pictureCacheSize, home.NoMorePictures);
        if (pictures.count > 0)
             [[Global data] SortByScore:home.pictures];
         completion(home.pictures);
        
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
         error(e);
     }];
    
    [self enqueueOperation:op ];
}

-(void) LoadMyPicture:(Summary*)summary OnCompletion:(PictureResponseBlock)completion OnError:(ErrorBlock)error
{
    if (summary.myPicture != nil)
    {
        completion(summary.myPicture);
        return;
    }
    

    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            summary.homeID, @"homeID",
                            Global.UserID, @"userID", nil];

    
    MKNetworkOperation *op = [self operationWithPath:@"Picture" params:params httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
    
        
        [completedOperation responseJSONWithOptions:NSJSONReadingAllowFragments completionHandler:^(id response) {
            
            if (response == [NSNull null]) { completion(summary.myPicture); return; }
            
            Picture* picture = [[Picture alloc] init];
            picture.id = [(NSNumber*)[response objectForKey:@"ID"] intValue];
            picture.homeID = [[response objectForKey:@"HomeID"] uppercaseString];
            //picture.contentData = [NSData dataWithBase64EncodedString:(NSString*)[response objectForKey:@"Content"]];
            picture.Content = [UIImage imageWithData:[NSData dataWithBase64EncodedString:(NSString*)[response objectForKey:@"Content"]]];
            picture.editDate = [NSDate FromISOString:[response objectForKey:@"EditDate"]];
            picture.caption = [response objectForKey:@"Caption"];
            picture.positiveVotes = [(NSNumber*)[response objectForKey:@"PositiveVotes"] intValue];
            picture.negativeVotes = [(NSNumber*)[response objectForKey:@"NegativeVotes"] intValue];
            picture.isMine =  [[response objectForKey:@"UserID"] IsEqualNoCase:Global.UserID];
            
            summary.myPicture = picture;
            [summary.pictures addObject:picture];
            [[NSNotificationCenter defaultCenter] postNotificationName:PicturePostedNotification object:self];
            completion(picture);
        }];
        
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
         error(e);
     }];

    [self enqueueOperation:op forceReload:true];


}

-(void) LoadMyComment:(Summary*)summary OnCompletion:(CommentResponseBlock)completion OnError:(ErrorBlock)error
{
    if (summary.myComment != nil)
    {
        completion(summary.myComment);
        return;
    }
    
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            summary.homeID, @"homeID",
                            Global.UserID, @"userID", nil];
    
    MKNetworkOperation *op = [self operationWithPath:@"Comment" params:params httpMethod:@"GET"];
    NSLog(@"%@", op);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        
            [completedOperation responseJSONWithOptions:NSJSONReadingAllowFragments completionHandler:^(id response) {
            
            if (response == [NSNull null]) { completion(summary.myComment); return; }
                
            Comment* comment = [[Comment alloc] init];
            comment.id = [(NSNumber*)[response objectForKey:@"ID"] intValue];
            comment.homeID = [[response objectForKey:@"HomeID"] uppercaseString];
                comment.friendlyRating = [(NSNumber*)[response objectForKey:@"FriendlyRating"] doubleValue];
                comment.rehabRating = [(NSNumber*)[response objectForKey:@"RehabilitationRating"] doubleValue];
                comment.appealRating = [(NSNumber*)[response objectForKey:@"PhysicalAppealSafetyRating"] doubleValue];
                comment.odorRating = [(NSNumber*)[response objectForKey:@"OdorRating"] doubleValue];
                comment.mealRating = [(NSNumber*)[response objectForKey:@"MealExperienceRating"] doubleValue];
                comment.responsiveRating = [(NSNumber*)[response objectForKey:@"ResponsiveRating"] doubleValue];
                
            comment.editDate = [NSDate FromISOString:[response objectForKey:@"EditDate"]];
            comment.title = [response objectForKey:@"Title"];
            comment.content = [response objectForKey:@"Content"];
            comment.positiveVotes = [(NSNumber*)[response objectForKey:@"PositiveVotes"] intValue];
            comment.negativeVotes = [(NSNumber*)[response objectForKey:@"NegativeVotes"] intValue];
            comment.isMine =  [[response objectForKey:@"UserID"] IsEqualNoCase:Global.UserID];
            
            summary.myComment = comment;
            [summary.comments addObject:comment];
            [[NSNotificationCenter defaultCenter] postNotificationName:CommentPostedNotification object:self];
            completion(comment);
        }];
    }
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
                    error(e);
                }];
    
    [self enqueueOperation:op forceReload:true];
}


-(void) LoadCommentSummary:(Summary*)summary OnCompletion:(CommentResponseBlock)completion OnError:(ErrorBlock)error
{
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            summary.homeID, @"id", nil];
    
    MKNetworkOperation *op = [self operationWithPath:@"CommentSummary" params:params httpMethod:@"GET"];
    NSLog(@"%@", op);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        
        [completedOperation responseJSONWithOptions:NSJSONReadingAllowFragments completionHandler:^(id response) {
            
            if (response == [NSNull null]) { summary.commentSummary = [[Comment alloc] init]; completion(summary.commentSummary); return; }
            
            Comment* comment = [[Comment alloc] init];
            //comment.id = [(NSNumber*)[response objectForKey:@"ID"] intValue];
            comment.homeID = [[response objectForKey:@"HomeID"] uppercaseString];
            comment.friendlyRating = [(NSNumber*)[response objectForKey:@"FriendlyRating"] doubleValue];
            comment.rehabRating = [(NSNumber*)[response objectForKey:@"RehabilitationRating"] doubleValue];
            comment.appealRating = [(NSNumber*)[response objectForKey:@"PhysicalAppealSafetyRating"] doubleValue];
            comment.odorRating = [(NSNumber*)[response objectForKey:@"OdorRating"] doubleValue];
            comment.mealRating = [(NSNumber*)[response objectForKey:@"MealExperienceRating"] doubleValue];
            comment.responsiveRating = [(NSNumber*)[response objectForKey:@"ResponsiveRating"] doubleValue];
            
            summary.commentSummary = comment;
            completion(comment);
        }];
    }
                errorHandler:^(MKNetworkOperation *completedOperation, NSError *e) {
                    error(e);
                }];
    
    [self enqueueOperation:op];
}



-(void) PostComment:(Comment*)c Summary:(Summary*)h OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error
{
    c.HomeID = h.homeID;
    c.isMine = true;
    c.editDate = [NSDate date];
    NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:
                          Global.UserID, @"UserID",
                          h.homeID, @"HomeID",
                          [NSNumber numberWithInt:c.id], @"ID",
                          [c.editDate ToISOString], @"EditDate",
                          c.title, @"Title",
                          c.content, @"Content",
                          [NSNumber numberWithDouble:c.friendlyRating], @"FriendlyRating",
                          [NSNumber numberWithDouble:c.rehabRating], @"RehabilitationRating",
                          [NSNumber numberWithDouble:c.appealRating], @"PhysicalAppealSafetyRating",
                          [NSNumber numberWithDouble:c.odorRating], @"OdorRating",
                          [NSNumber numberWithDouble:c.mealRating], @"MealExperienceRating",
                          [NSNumber numberWithDouble:c.responsiveRating], @"ResponsiveRating",
                          nil];
    [self Post:post Path:@"Comment" OnCompletion:^
     {
         [h UpdateMyComment:c];
         completion();
     }OnError:error];
}

-(void) PostPicture:(Picture*)p Summary:(Summary*)h OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error
{
    p.HomeID = h.homeID;
    p.isMine = true;
    p.editDate = [NSDate date];
    NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:
                          Global.UserID, @"UserID",
                          h.homeID, @"HomeID",
                          [NSNumber numberWithInt:p.id], @"ID",
                          UIImageJPEGRepresentation([p.Content FixRotation], 1.0).base64EncodedString, @"Content",
                       [p.editDate ToISOString], @"EditDate",
                       p.caption, @"Caption",
                          nil];
    
    [self Post:post Path:@"Picture" OnCompletion:^
     {
         if (h.myPicture == nil)
         {
             [[Global data] Add:p];
             if (h.pictures == nil) 
                 h.pictures = [NSMutableArray array];
             [h.pictures addObject:p];
             h.myPicture = p;
             if (h.picture == nil)
                 h.picture = p.Content;
         }
         else {
             [h.myPicture copy:p];
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:PicturePostedNotification object:self];
         completion();
     } OnError:error];
}

- (void) ReportPicture:(Picture*)p Summary:(Summary*)h
{
    if (h.pictures == nil) return;
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"Picture/%d?report=true", p.id] params:nil httpMethod:@"GET"];
    [self enqueueOperation:op];
    
    [h.pictures removeObject:p];
    [[NSNotificationCenter defaultCenter] postNotificationName:PictureRemovedNotification object:self];
}

	
-(void) PostPictureVote:(int)pid Vote:(NSNumber*)vote OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error
{
    
    NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:
                          Global.UserID, @"UserID",
                          [NSNumber numberWithInt:pid], @"PictureID",
                          vote, @"Vote",
                          nil];
    if (vote == nil)
        [self Delete:post Path:@"PictureVote" OnCompletion:completion OnError:error];
    else
        [self Post:post Path:@"PictureVote" OnCompletion:completion OnError:error];                      
}

-(void) PostCommentVote:(int)cid Vote:(NSNumber*)vote OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error
{
    NSDictionary* post = [NSDictionary dictionaryWithObjectsAndKeys:
                      Global.UserID, @"UserID",
                      [NSNumber numberWithInt:cid], @"CommentID",
                      vote, @"Vote",
                      nil];
    if (vote == nil)
        [self Delete:post Path:@"CommentVote" OnCompletion:completion OnError:error];
    else
        [self Post:post Path:@"CommentVote" OnCompletion:completion OnError:error];
}

-(void) Post:(NSDictionary*)post Path:(NSString*)path OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error
{
    MKNetworkOperation *op = [self operationWithPath:path params:post httpMethod:@"POST"];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completion();
         
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *er) {
         NSLog(@"%@", er);
         error(er);
     }];
    [[Global data] Save];
    [self enqueueOperation:op ];

}

-(void) Delete:(NSDictionary*)delete Path:(NSString*)path OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error
{
    MKNetworkOperation *op = [self operationWithPath:path params:delete httpMethod:@"DELETE"];
    op.postDataEncoding = MKNKPostDataEncodingTypeJSON;
    NSLog(@"%@", op);
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         completion();
     } errorHandler:^(MKNetworkOperation *completedOperation, NSError *er) {
         
         NSLog(@"%@", er);
         error(er);
     }];
    
    [self enqueueOperation:op ];
    
}
                          
                          
@end

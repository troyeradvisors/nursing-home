//
//  HomeService.h
//  NursingHome
//
//  Created by Allen Brubaker on 26/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "Home.h"
#import "Summary.h"
#import "MKNetworkKit.h"
#import "Comment.h"
#import "Picture.h"
#import "StateAverage.h"
#import <UIKit/UIKit.h>

typedef void (^ImageResponseBlock) (UIImage*);
typedef void (^ListResponseBlock) (NSArray*);
typedef void (^ListBoolResponseBlock) (NSArray*, bool);
typedef void (^HomeResponseBlock) (Home*);
typedef void (^ErrorBlock) (NSError*);
typedef void (^ErrorHomeBlock) (Home*, NSError*);
typedef void (^EmptyBlock)();
typedef void (^CommentResponseBlock) (Comment*);
typedef void (^PictureResponseBlock) (Picture*);
typedef void (^StateAverageResponseBlock) (StateAverage*);
typedef void (^StringResponseBlock)(NSString*);

typedef void (^ProgressBlock) (double, NSString*);

@interface HomeService : MKNetworkEngine

-(id)init;
-(MKNetworkOperation*) LoadThumbnail:(Summary*)summary OnCompletion:(ImageResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadSummaries:(double)latitude Longitude:(double)longitude Radius:(double)radius Filter:(Filter*)filter OnCompletion:(ListResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadHome:(Summary*)summary OnComplete:(HomeResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadStateAverage:(NSString*)state OnCompletion:(StateAverageResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadComments:(Summary*)s LoadMore:(bool)loadMore OnCompletion:(ListResponseBlock)completion OnError:(ErrorBlock)error;

-(void) LoadHighQualityPictureURL:(Picture*)p OnCompletion:(StringResponseBlock)completion OnError:(ErrorBlock)error;

-(MKNetworkOperation*) LoadHighQualityPicture:(NSString*)url Picture:(Picture*)p OnCompletion:(ImageResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadPictures:(Summary*)s LoadMore:(bool)loadMore OnCompletion:(ListResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadMyPicture:(Summary*)summary OnCompletion:(PictureResponseBlock)completion OnError:(ErrorBlock)error;

-(void) LoadCommentSummary:(Summary*)summary OnCompletion:(CommentResponseBlock)completion OnError:(ErrorBlock)error;
-(void) LoadMyComment:(Summary*)summary OnCompletion:(CommentResponseBlock)completion OnError:(ErrorBlock)error;
-(void) PostPicture:(Picture*)picture Summary:(Summary*)s OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error;
-(void) PostComment:(Comment*)comment Summary:(Summary*)s OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error;
-(void) PostPictureVote:(int)pid Vote:(NSNumber*)vote OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error;
- (void) ReportPicture:(Picture*)p Summary:(Summary*)s;
-(void) PostCommentVote:(int)cid Vote:(NSNumber*)vote OnCompletion:(EmptyBlock)completion OnError:(ErrorBlock)error;

@end

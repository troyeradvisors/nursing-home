//
//  SpamService.h
//  NursingHome
//
//  Created by Allen Brubaker on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MKNetworkEngine.h"
typedef void (^BoolBlock) (bool);

@interface SpamService : MKNetworkEngine
-(id)init;
-(void) IsSpam:(NSString*)text OnCompletion:(BoolBlock)completion OnError:(ErrorBlock)error;


@end

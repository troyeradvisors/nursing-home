//
//  SpamService.m
//  NursingHome
//
//  Created by Allen Brubaker on 10/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpamService.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation SpamService

-(id)init
{
    self = [super initWithHostName:@"2dbb30e0154c.rest.akismet.com"];
    return self;
}

-(void) IsSpam:(NSString*)text OnCompletion:(BoolBlock)completion OnError:(ErrorBlock)error
{
    // Need to test manually because I'm getting some weird missing required field: blog error
    NSDictionary* parms = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"http://troyeradvisorsdashboards.com/services/nursinghome", @"blog",
                          [self getIPAddress], @"user_ip",
                          @"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3", @"user_agent",
                          @"comment", @"comment_type",
                           text, @"comment_content",
                          nil];
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"1.1/comment-check"] params:parms httpMethod:@"POST"];
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         NSString* response = completedOperation.responseString;
          NSLog(@"Akismet: %@", response);
         bool isSpam = [response IsEqualNoCase:@"true"];
         completion(isSpam);
     }
             onError:^(NSError* error)
     {
     }];
    
    [self enqueueOperation:op];
}

// Get IP Address
- (NSString *)getIPAddress {    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];               
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
} 

@end

//
//  NSString+Extension.h
//  NursingHome
//
//  Created by Allen Brubaker on 15/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
- (NSString*)ToNormalized;
- (bool) IsEmpty;
- (NSString*)FormatPhoneNumber;
- (bool) Contains:(NSString*)substring;
- (NSString*) Trim;
- (bool) IsEqualNoCase:(NSString*)s;
- (int) Distance:(NSString*)s;
@end

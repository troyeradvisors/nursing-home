//
//  NSManagedObjectContextHelper.h
//  NursingHome
//
//  Created by Allen Brubaker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (Extension)

- (NSArray*)Query:(NSString*)newEntityName;
- (NSArray *)Query:(NSString *)newEntityName
                         Predicate:(id)stringOrPredicate;

- (NSArray *)Query:(NSString *)newEntityName 
                              Sort:(NSSortDescriptor*) sort 
                         Predicate:(id)stringOrPredicate, ...;
@end

//
//  NSManagedObjectContextHelper.m
//  NursingHome
//
//  Created by Allen Brubaker on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContextHelper.h"

@implementation NSManagedObjectContext (Extension)

- (NSArray*)Query:(NSString*)newEntityName
{
    return [self Query:newEntityName Sort:nil Predicate:nil];
}

- (NSArray *)Query:(NSString *)newEntityName
     Predicate:(id)stringOrPredicate
{
    return [self Query:newEntityName Sort:nil Predicate:stringOrPredicate];
}


- (NSArray *)Query:(NSString *)newEntityName 
                              Sort:(NSSortDescriptor*) sort 
                         Predicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:newEntityName inManagedObjectContext:self];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    if (sort)
        [request setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    if (stringOrPredicate)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            NSString* s = stringOrPredicate;
            if (![s isEqualToString:@""])
            {
                va_list variadicArguments;
                va_start(variadicArguments, stringOrPredicate);
                predicate = [NSPredicate predicateWithFormat:stringOrPredicate
                                                   arguments:variadicArguments];
                va_end(variadicArguments);
            }
        }
        else
        {
            NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],@"Second parameter passed to %s is of unexpected class %@", sel_getName(_cmd), [stringOrPredicate class]);
            predicate = (NSPredicate *)stringOrPredicate;
        }
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:[error description]];
    }
    
    return results;
    //return [NSSet setWithArray:results];
}



@end

//
//  NSString+Extension.m
//  NursingHome
//
//  Created by Allen Brubaker on 15/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString*) ToNormalized
{
    bool firstLetter = true;
    NSMutableString *m = [NSMutableString stringWithString:self]; 
    for (int i=0; i<m.length; ++i)
    {
        char c = [m characterAtIndex:i];
        if (c == ' ')
            firstLetter = true;
        else if (!firstLetter)
            [m replaceCharactersInRange:NSMakeRange(i,1) withString:[NSString stringWithFormat:@"%c",tolower(c)]];
        else
            firstLetter = false;
    }
    return m;
}

- (bool) IsEmpty
{
    return [self length] == 0;
}

- (NSString*) Trim 
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (bool) IsEqualNoCase:(NSString*)s
{
    return [self caseInsensitiveCompare:s] == NSOrderedSame;
}
            
-(NSString*) FormatPhoneNumber
{
    if (self.length == 10)
    {
        return [NSString stringWithFormat:@"(%c%c%c) %c%c%c-%c%c%c%c", [self characterAtIndex:0], [self characterAtIndex:1], [self characterAtIndex:2], [self characterAtIndex:3], [self characterAtIndex:4], [self characterAtIndex:5], [self characterAtIndex:6], [self characterAtIndex:7], [self characterAtIndex:8], [self characterAtIndex:9]]; 
    }
    return self;
}

-(bool) Contains:(NSString*)substring
{
    return [self rangeOfString:substring].location != NSNotFound;
}

/// minimum between three values
int minimum(int a,int b,int c)
{
	int min=a;
	if(b<min)
		min=b;
	if(c<min)
		min=c;
	return min;
}


-(int) Distance:(NSString *) string
{
	int *d; // distance vector
	int i,j,k; // indexes
	int cost, distance;
    
	int n = [self length];
	int m = [string length];
    NSString *s1 = [self lowercaseString], *s2 = [string lowercaseString];
    
	if( n!=0 && m!=0 ){
        
		d = malloc( sizeof(int) * (++n) * (++m) );
        
		for( k=0 ; k<n ; k++ )
			d[k] = k;
		for( k=0 ; k<m ; k++ )
			d[k*n] = k;
        
		for( i=1; i<n ; i++ ) {
			for( j=1 ;j<m ; j++ ) {
				if( [s1 characterAtIndex:i-1]  == [s2 characterAtIndex:j-1])
					cost = 0;
				else
					cost = 1;
				d[j*n+i]=minimum(d[(j-1)*n+i]+1,d[j*n+i-1]+1,d[(j-1)*n+i-1]+cost);
			}
		}
		distance = d[n*m-1];
		free(d);
		return distance;
	}
    
	return -1; // error
}

@end

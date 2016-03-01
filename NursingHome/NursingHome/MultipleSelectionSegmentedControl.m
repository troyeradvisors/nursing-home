//
//  MultipleSelectionSegmentedControl.m
//  NursingHome
//
//  Created by Allen Brubaker on 10/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MultipleSelectionSegmentedControl.h"

@implementation MultipleSelectionSegmentedControl

@synthesize AtMostOne;
@synthesize indices;
@synthesize SelectedTintColor;

-(id)initWithItems:(NSArray *)items { return [self initWithItems:items AtMostOne:false SelectedTintColor:nil]; }
-(id)initWithItems:(NSArray *)items AtMostOne:(bool)atMostOne SelectedTintColor:(UIColor*)color
{
    self = [super initWithItems:items];
    if (self) {
        color = self.SelectedTintColor;
        for (int i=0; i<self.numberOfSegments; ++i)
            [self setTag:i forSegmentAtIndex:i];
        [self setSegmentedControlStyle:UISegmentedControlStyleBar];
        [self addTarget:self action:@selector(segmentPushed:) forControlEvents:UIControlEventValueChanged];
        self.indices = [NSMutableSet set] ;
        AtMostOne = atMostOne;
    }
    return self;
}
         
         
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) segmentPushed:(id)sender
{
    [self setSelectedSegmentIndex:[self selectedSegmentIndex] isReversed:YES]; // For some unknown reason it reverses index but only when a segment has just been pushed.
}


- (NSSet *) selectedSegmentIndices
{
    return self.indices;
}

- (void) setSelectedSegmentIndices: (NSSet *) aSet
{
    for (NSNumber* value in aSet)
    {
        [self setSelectedSegmentIndex: [value integerValue]] ;
    }
}


- (void) reset
{
    for (int i = 0; i< [self subviews].count; ++i)
    {
        [[[self subviews] objectAtIndex:i] setTintColor:[self tintColor]];
        [super setSelectedSegmentIndex: -1] ;
    }
    indices = [NSMutableSet set];
}

-(void) setSelectedSegmentIndex:(NSInteger)anIndex
{
    [self setSelectedSegmentIndex:anIndex isReversed:NO];
}

- (void) setSelectedSegmentIndex: (NSInteger) anIndex isReversed:(BOOL)r
{
    if ( self.indices == nil ) self.indices = [NSMutableSet set] ;
    
    
    if ( anIndex >= 0 )
    {
        NSNumber *indexNumber ;

        indexNumber = [NSNumber numberWithInt: anIndex] ;
        if (r)
            anIndex = [self numberOfSegments] - 1 - anIndex;
        
        if ( ! [self.indices containsObject: indexNumber] )
        {
            if (AtMostOne)
                [self reset];
            //[self setTintColor:[UIColor greenColor] forTag:anIndex];
            //[[[self subviews] objectAtIndex:anIndex] setTintColor:[[UIColor alloc] initWithRed:.465359 green:.556275 blue:.69107 alpha:1.0]];
            [[[self subviews] objectAtIndex:anIndex] setTintColor:self.SelectedTintColor ?: [self tintColor]];
            [self.indices addObject: indexNumber];
            [super setSelectedSegmentIndex: -1];
        }
        else
        {
            if (AtMostOne)
                [self reset];
            //[self setTintColor:[self tintColor] forTag:anIndex];
            [[[self subviews] objectAtIndex:anIndex] setTintColor:[self tintColor]];
            [self.indices removeObject: indexNumber] ;
            [super setSelectedSegmentIndex: -1] ;
        }

    }
    
}

@end

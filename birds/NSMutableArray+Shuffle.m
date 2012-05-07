//
//  NSMutableArray+Shuffle.m
//  birds
//
//  Created by GANDZIOSHIN ARTEM on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

@implementation NSMutableArray (Shuffle)

/*
 * Fisher/Yates Shuffle (Knuth Shuffle)
 */
- (void) shuffle {
    for (NSInteger i = [self count] - 1; i > 0; --i) {
        [self exchangeObjectAtIndex: random() % (i + 1)
                  withObjectAtIndex: i]; 
    }
}

@end

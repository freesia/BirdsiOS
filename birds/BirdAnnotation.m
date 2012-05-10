//
//  BirdAnnotation.m
//  birds
//
//  Created by Gureva Ekaterina on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirdAnnotation.h"

@implementation BirdAnnotation


@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize iD;
@synthesize image;


- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andSubtitle:(NSString *)sbTitl andID:(int)i andImage:(NSString *)im{
	self = [super init];
	title = ttl;
	coordinate = c2d;
    subtitle=sbTitl;
    self.iD=i;
    self.image=im;
	return self;
}



@end

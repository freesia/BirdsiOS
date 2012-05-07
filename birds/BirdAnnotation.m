//
//  BirdAnnotation.m
//  birds
//
//  Created by Gureva Ekaterina on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BirdAnnotation.h"

@implementation BirdAnnotation


@synthesize name;
@synthesize longitudeString;
@synthesize latitudeString;
@synthesize speciesName;
@synthesize longitude;
@synthesize latitude;


-(id)initWithName:(NSString *)n longtitude:(NSString *)l latitude:(NSString *)lat speciesName:(NSString *)spec {
	self.name = n;
	self.longitudeString = l;
	self.latitudeString = lat;
    self.speciesName=spec;
	return self;
}
- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self convertWithString:latitudeString];
    theCoordinate.longitude = [self convertWithString:longitudeString];
    return theCoordinate; 
}
- (NSNumber *)latitude {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:latitudeString];
    return myNumber;
}
- (NSNumber *)longitude {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:longitudeString];
    return myNumber;
}
- (NSString *)title
{
    return name;
}


- (NSString *)subtitle
{
    return speciesName;
}

-(double)convertWithString: (NSString *)string {
   
    double myNumber = [string doubleValue];
    
    return myNumber;
}
@end

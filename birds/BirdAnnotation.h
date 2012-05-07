//
//  BirdAnnotation.h
//  birds
//
//  Created by Gureva Ekaterina on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface BirdAnnotation : NSObject <MKAnnotation>
{

    NSString *name;
    NSString *latitudeString;
    NSString *longtitudeString;
    NSString *speciesName;
}


@property (nonatomic) NSNumber *latitude;
@property (nonatomic) NSNumber *longitude;
@property (nonatomic) NSString *latitudeString;
@property (nonatomic) NSString *longitudeString;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *speciesName;

-(id)initWithName:(NSString *)n longtitude:(NSString *)l latitude:(NSString *)lat speciesName:(NSString *)spec;
-(double)convertWithString: (NSString *)string;
@end

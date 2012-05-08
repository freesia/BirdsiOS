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

    NSString *title;

    NSString *subtitle;
    
   
	CLLocationCoordinate2D coordinate;
}

@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d andSubtitle:(NSString *)sbTitl;

@end

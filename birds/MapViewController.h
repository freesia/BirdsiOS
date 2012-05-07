//
//  MapViewViewController.h
//  birds
//
//  Created by Gureva Ekaterina on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate> {
    MKMapView *map;
    NSMutableArray *annotationsArray;

}
@property (nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) NSMutableArray *annotationsArray;
@end

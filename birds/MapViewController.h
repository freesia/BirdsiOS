//
//  MapViewViewController.h
//  birds
//
//  Created by Gureva Ekaterina on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
    MKMapView *map;
    NSMutableArray *annotationsArray;
    
    CLLocationManager *locationManager;

}
@property (nonatomic, strong) IBOutlet MKMapView *mapView;

@property (nonatomic) NSMutableArray *annotationsArray;

@property (nonatomic) CLLocationManager *locationManager;

- (void)showDetails:(id)sender;

@end

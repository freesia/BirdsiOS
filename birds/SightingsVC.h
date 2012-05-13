//
//  SightingsVC.h
//  birds
//
//  Created by Gureva Ekaterina on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "DetailTabController.h"
#import "MapViewController.h"

@interface SightingsVC : UIViewController
 <CLLocationManagerDelegate> {
    CLLocationManager    *locationManager;
    
    CLLocation           *startingPoint;
    
    UILabel *latitudeLabel;
    UILabel *longitudeLabel;
    UILabel *horizontalAccuracyLabel;
    UILabel *altitudeLabel;
    UILabel *verticalAccuracyLabel;
    UILabel *distanceTraveledLabel;
    DetailTabController *detailVC;
    CLLocationDegrees longDegrees;
    CLLocationDegrees latDegrees;
     MapViewController *mapVC;
     
    
}
@property (nonatomic)  DetailTabController *detailVC;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *startingPoint;
@property (nonatomic) IBOutlet UILabel *latitudeLabel;
@property (nonatomic) IBOutlet UILabel *longitudeLabel;
@property (nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (nonatomic) IBOutlet UILabel *altitudeLabel;
@property (nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (nonatomic) IBOutlet UILabel *distanceTraveledLabel;

-(IBAction)SightingButtonPresssed;
@end
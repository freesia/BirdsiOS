//
//  SightingsVC.m
//  birds
//
//  Created by Gureva Ekaterina on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SightingsVC.h"
#import "birdsAppDelegate.h"
#import "DetailTabController.h"
#import "MapViewController.h"
#import "Bird.h"

@implementation SightingsVC
@synthesize locationManager;
@synthesize startingPoint;
@synthesize latitudeLabel;
@synthesize longitudeLabel;
@synthesize horizontalAccuracyLabel;
@synthesize altitudeLabel;
@synthesize verticalAccuracyLabel;
@synthesize distanceTraveledLabel;
@synthesize detailVC;

#pragma mark -
- (void)viewDidLoad {
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.locationManager = nil;
    self.latitudeLabel = nil;
    self.longitudeLabel = nil;
    self.horizontalAccuracyLabel = nil;
    self.altitudeLabel = nil;
    self.verticalAccuracyLabel = nil;
    self.distanceTraveledLabel = nil;
    [super viewDidUnload];
}


#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    
    if (startingPoint == nil)
        self.startingPoint = newLocation;

    NSString *latitudeString = [[NSString alloc] initWithFormat:@"%g°", 
                                newLocation.coordinate.latitude];
    longDegrees=newLocation.coordinate.longitude;
    latDegrees=newLocation.coordinate.latitude;
    latitudeLabel.text = latitudeString;
   
    
    NSString *longitudeString = [[NSString alloc] initWithFormat:@"%g°", 
                                 newLocation.coordinate.longitude];
    longitudeLabel.text = longitudeString;

    
    NSString *horizontalAccuracyString = [[NSString alloc]
                                          initWithFormat:@"%gm", 
                                          newLocation.horizontalAccuracy];
    horizontalAccuracyLabel.text = horizontalAccuracyString;
   
    
    NSString *altitudeString = [[NSString alloc] initWithFormat:@"%gm", 
                                newLocation.altitude];
    altitudeLabel.text = altitudeString;

    
    NSString *verticalAccuracyString = [[NSString alloc]
                                        initWithFormat:@"%gm", 
                                        newLocation.verticalAccuracy];
    verticalAccuracyLabel.text = verticalAccuracyString;

    
    CLLocationDistance distance = [newLocation distanceFromLocation:startingPoint];
    NSString *distanceString = [[NSString alloc]
                                initWithFormat:@"%gm", distance];
    distanceTraveledLabel.text = distanceString;

}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
    
    NSString *errorType = (error.code == kCLErrorDenied) ? 
    @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Error getting Location" 
                          message:errorType 
                          delegate:nil 
                          cancelButtonTitle:@"Okay" 
                          otherButtonTitles:nil];
    [alert show];

    
}
-(void) writeBirdsLocationsIntoDatabase {
    ///appDelegate
    birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
	// Setup the database object
	sqlite3 *database;
	
	sqlite3_stmt    *statement;
    sqlite3_stmt    *statement2;
        
   		
	// Open the database from the users filessytem
	if(sqlite3_open([appDelegate.databasePath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
         
            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO loc (image, speciesName, longtitude, latitude, name, id) VALUES (\"%@\", \"%@\",\"%g\",\"%g\", \"%@\",\"%d\")", detailVC.image, detailVC.speciesName, longDegrees, latDegrees, detailVC.name, detailVC.Id];
            
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(database, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate readAnimalsFromDatabase];
                int sight;
                for (int i=0; i<appDelegate.animals.count; i++) {
                    Bird *animal = (Bird *)[appDelegate.animals objectAtIndex:i];
                    if (animal.iD==detailVC.Id) {
                        sight=animal.sight;
                        sight++;
                    }
                }

              //  int s=detailVC.sight+1;
                
                NSString *insertSisht =[NSString stringWithFormat:@"UPDATE BIRDS SET SIGHTS=\"%d\" where id=\"%d\"",sight,detailVC.Id];
                const char *insert=[insertSisht UTF8String];
                sqlite3_prepare_v2(database, insert, -1, &statement2, NULL);
                if (sqlite3_step(statement2)==SQLITE_DONE) {
                   NSLog( @"OLOL vse putem");
                } else {
                NSLog(@"NIFIGA NE PUTEM");
                }
                NSLog(@"Birds added");
             
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Bird's location added!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
                
                sqlite3_close(database);
             
               
            } else {
                NSLog(@"Failed to add Bird") ;
            			
			}
		
        sqlite3_finalize(statement);
        sqlite3_finalize(statement2);
		
	}
}
-(IBAction)SightingButtonPresssed {
    [self writeBirdsLocationsIntoDatabase];
}
@end

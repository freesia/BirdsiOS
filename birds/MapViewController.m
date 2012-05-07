//
//  MapViewViewController.m
//  birds
//
//  Created by Gureva Ekaterina on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "birdsAppDelegate.h"
#import "BirdAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView;
@synthesize annotationsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
        annotationsArray=[[NSMutableArray alloc] init];
        annotationsArray=appDelegate.birdLocations;
        [self gotoLocation];
        [self.mapView addAnnotations:annotationsArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"Map";
    [self gotoLocation];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 29.76257;
    newRegion.center.longitude = -95.45177;
    newRegion.span.latitudeDelta =0.006;
    newRegion.span.longitudeDelta = 0.006;
    
    [self.mapView setRegion:newRegion animated:YES];
    
}
@end

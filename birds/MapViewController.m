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
@synthesize locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"Map";
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    locationManager.distanceFilter = kCLDistanceFilterNone;
//    [locationManager startUpdatingLocation];
//    CLLocationDegrees latitude = locationManager.location.coordinate.latitude;
//    CLLocationDegrees longitude = locationManager.location.coordinate.longitude;
//    NSLog(@"%f",latitude);
//    NSLog(@"%f",longitude);
//   [locationManager stopUpdatingLocation];

    [self gotoLocation];
    birdsAppDelegate *appDelegate = (birdsAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    annotationsArray=appDelegate.birdLocations;
    NSLog(@"%d", annotationsArray.count);
    [self.mapView addAnnotations:self.annotationsArray];
    
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
+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 33.0f;
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[BirdAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"BirdAnnotation";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                             reuseIdentifier:@"BirdAnnotation"];
            annotationView.canShowCallout = YES;
            
            UIImage *flagImage = [UIImage imageNamed:@"pin.png"];
            
            CGRect resizeRect;
            
            resizeRect.size = flagImage.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){0.0f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [flagImage drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            annotationView.image = resizedImage;
            annotationView.opaque = NO;
            
            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]];
            annotationView.leftCalloutAccessoryView = sfIconView;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            rightButton.tintColor=[UIColor brownColor];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            annotationView.rightCalloutAccessoryView=rightButton;
                        
            return annotationView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
- (void)showDetails:(id)sender
{
    
}
@end

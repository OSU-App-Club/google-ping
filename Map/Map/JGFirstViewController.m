//
//  JGFirstViewController.m
//  Map
//
//  Created by Jonah George on 2/21/14.
//  Copyright (c) 2014 Jonah George. All rights reserved.
//

#import "JGFirstViewController.h"

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface JGFirstViewController () <CLLocationManagerDelegate>

@end

@implementation JGFirstViewController

    CLLocationManager *manager;
    GMSCameraPosition *camera;
    CLLocation *currentLocation;
    GMSMarker *marker;
    GMSMapView *mapView;
    //NSMutableArray *towers;

    double corvallis_x = 44.5708;
    double corvallis_y = -123.2760;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView.myLocationEnabled = YES;
    self.view = mapView;

    // Creates a marker in the center of the map, make sure the mapView_ is created, and
    // has the camera position set.
//    marker = [[GMSMarker alloc] init];
    //marker.icon = [GMSMarker markerImageWithColor:[UIColor blackColor]];
//    marker.icon = [UIImage imageNamed:@"house"];
//    marker.position = CLLocationCoordinate2DMake(44.5708, -123.2760);
//    marker.title = @"Corvallis";
//    marker.snippet = @"Oregon";
//    marker.map = mapView;
    
    
//    srandom(time(NULL));
//    
//    towers = [NSMutableArray array];
//
//    for (int i = 0; i < 25; i++) {
//        double x = arc4random() % 100;
//        double y = arc4random() % 100;
//        
//        //CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake(corvallis_x + x, corvallis_y + y);
//        
//        GMSCircle *tower = [[GMSCircle alloc] init];
//        //GMSCircle *tower = [GMSCircle circleWithPosition:circleCenter radius:5];
//        tower.position = CLLocationCoordinate2DMake(corvallis_x + x, corvallis_y + y);
//        tower.fillColor = [UIColor colorWithRed:5 green:0 blue:0 alpha:1];
//        tower.strokeColor = [UIColor redColor];
//        tower.strokeWidth = 2;
//        tower.map = mapView;
//        
//        [towers addObject:tower];
//
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", newLocation);
    
    currentLocation = newLocation;

    camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:8];
//    camera = [GMSCameraPosition cameraWithLatitude:44.5708 longitude:-123.2760 zoom:15];
    [mapView setCamera:camera];
    
    [manager stopUpdatingLocation];
}

@end

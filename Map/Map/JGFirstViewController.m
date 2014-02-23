//
//  JGFirstViewController.m
//  Map
//
//  Created by Jonah George on 2/21/14.
//  Copyright (c) 2014 Jonah George. All rights reserved.
//

#import "JGFirstViewController.h"
#import <CoreLocation/CoreLocation.h>

#define API_KEY @"AIzaSyDMMwC23Q-Qb9cJUY35ehoWCJdxQaclgC8"

@interface JGFirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) GMSMapView *mapView;

@end

@implementation JGFirstViewController

    CLLocationManager *manager;
    GMSCameraPosition *camera;
    CLLocation *currentLocation;
    NSURL *url;
    NSData *data;
    NSString *ret;

    double latitude = 44.5708;
    double longitude = -123.2760;
    int count = 15;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Setup GPS
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    [self.view addSubview: self.mapView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView clear];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update UI in some way.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        marker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        marker.map = self.mapView;
    });
    
    camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:13];
    [self.mapView setCamera:camera];
    
    [self queryPlacesAPI: @"library" color:[UIColor greenColor] coordinate:&coordinate image:[UIImage imageNamed:@"library"]];
    [self queryPlacesAPI: @"post_office" color:[UIColor blackColor] coordinate:&coordinate image:[UIImage imageNamed:@"postal"]];
    [self queryPlacesAPI: @"church" color:[UIColor orangeColor] coordinate:&coordinate image:[UIImage imageNamed:@"church"]];
    [self queryPlacesAPI: @"night_club" color:[UIColor blueColor] coordinate:&coordinate  image:[UIImage imageNamed:@"dancinghall"]];
    [self queryPlacesAPI: @"bus_station" color:[UIColor yellowColor] coordinate:&coordinate  image:[UIImage imageNamed:@"bus"]];
    [self queryPlacesAPI: @"movie_theater" color:[UIColor purpleColor] coordinate:&coordinate image:[UIImage imageNamed:@"cinema"]];
    [self queryPlacesAPI: @"laundry" color:[UIColor whiteColor] coordinate:&coordinate  image:[UIImage imageNamed:@"laundromat"]];
    [self queryPlacesAPI: @"restaurant" color:[UIColor redColor] coordinate:&coordinate image:[UIImage imageNamed:@"restaurant"]];
    [self queryPlacesAPI: @"university" color:[UIColor cyanColor] coordinate:&coordinate image:[UIImage imageNamed:@"university"]];
}

#pragma mark CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"Location: %@", newLocation);
    
    currentLocation = newLocation;

    camera = [GMSCameraPosition cameraWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude zoom:10];
//    camera = [GMSCameraPosition cameraWithLatitude:corvallis_x longitude:corvallis_y zoom:15];
    [self.mapView setCamera:camera];
    
    [manager stopUpdatingLocation];
}

- (void)queryPlacesAPI:(NSString *)type color:(UIColor *)color coordinate:(CLLocationCoordinate2D *)coordinate image:(UIImage *)image
{
    
    NSString *latitude = [NSString stringWithFormat:@"%.20f", coordinate->latitude];
    NSString *longitude = [NSString stringWithFormat:@"%.20f", coordinate->longitude];

    
    NSString *urlAsString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=%@,%@&radius=5000&types=%@&sensor=false&key=%@", latitude, longitude, type, API_KEY];
    
    //NSLog(@"%@", urlAsString);
    
    NSString *encodedString = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:encodedString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)  {
                               
                               
                               NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                               
                               NSArray *results = [parsedObject valueForKey:@"results"];
                               
                               if (results && results[0]) {
                               
                                   NSArray *geo = [results[0] valueForKey:@"geometry"];
                                   NSArray *loc = [geo valueForKey:@"location"];
                                   
                                   NSString *lat = [loc valueForKey:@"lat"];
                                   NSString *lng = [loc valueForKey:@"lng"];
                                   
//                                   CLLocation *departure = [[CLLocation alloc] initWithLatitude:coordinate->latitude longitude:coordinate->longitude];
//                                   CLLocation *destination = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lng doubleValue]];
//                                   CLLocationDistance distance = [destination distanceFromLocation:departure];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       // Update UI in some way.
                                       GMSMarker *marker = [[GMSMarker alloc] init];
                                       marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                                       marker.icon = image;
//                                       marker.snippet = [NSString stringWithFormat:@"%f km away", (distance/1000)];
                                       marker.map = self.mapView;
                                       
//                                       // Draw line
//                                       GMSMutablePath *path = [GMSMutablePath path];
//                                       [path addLatitude:[latitude doubleValue] longitude:[longitude doubleValue]]; // Departure
//                                       [path addLatitude:[lat doubleValue] longitude:[lng doubleValue]]; // Destination
//                                       GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
//                                       polyline.strokeWidth = 1.f;
//                                       polyline.geodesic = YES;
//                                       polyline.map = self.mapView;
                                   });
                                   
                               }
                               
                           }];
}



@end

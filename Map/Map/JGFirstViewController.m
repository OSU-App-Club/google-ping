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

#define IOS_API_KEY     @"AIzaSyDyytOykBL6UJMgeOzx25xK9BF9BbVfRhc"
#define BROWSER_API_KEY @"AIzaSyDMMwC23Q-Qb9cJUY35ehoWCJdxQaclgC8"

@protocol requestHandlerDelegate <NSObject>

- (void) fetchingGroupsFailedWithError: (NSError *) error;
- (void) receivedGroupsJSON: (NSData *) data;

@end

@interface requestHandler : NSObject <requestHandlerDelegate>

@end

@implementation requestHandler

- (void) fetchingGroupsFailedWithError: (NSError *) error
{
    NSLog(@"%@", error);
}


- (void) receivedGroupsJSON: (NSData *) data
{
    NSLog(@"%@", data);
}

@end


@interface JGFirstViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) GMSMapView *mapView;
@property (weak, nonatomic) id<requestHandlerDelegate> delegate;

@end

@implementation JGFirstViewController

    CLLocationManager *manager;
    GMSCameraPosition *camera;
    CLLocation *currentLocation;
    NSURL *url;
    NSData *data;
    NSString *ret;

    double corvallis_x = 44.5708;
    double corvallis_y = -123.2760;
    int count = 15;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [self.view addSubview: self.mapView];

//    srandom(time(NULL));
//    
//    for (int i = 0; i < count; i++) {
//        
//        double x = arc4random() % 100;
//        double y = arc4random() % 100;
//        
//        GMSMarker *marker = [[GMSMarker alloc] init];
//        marker.position = CLLocationCoordinate2DMake((corvallis_x - 1) + x/100, (corvallis_y - 1) + y/100);
////        marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
////        marker.title = @"Corvallis";
////        marker.snippet = @"Oregon";
//        marker.map = self.mapView;
//    }
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=44.5708,-123.2760&radius=5000&types=food|cafe&sensor=false&keyword=vegetarian&key=%@", BROWSER_API_KEY];
    NSString *encodedString = [urlAsString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:encodedString];
    
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)  {
//                               NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

//                               NSLog(@"result:  %@ %lu %@", result, (unsigned long)[data length], error);
                               NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                               
                               NSArray *results = [parsedObject valueForKey:@"results"];
                               NSLog(@"Count %d", results.count);
                               
                               for (NSDictionary *result in results) {
                                   
                                   NSArray *geo = [result valueForKey:@"geometry"];
                                   NSArray *loc = [geo valueForKey:@"location"];
                                   
                                   NSString *lat = [loc valueForKey:@"lat"];
                                   NSString *lng = [loc valueForKey:@"lng"];
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       // Update UI in some way.
                                       GMSMarker *marker = [[GMSMarker alloc] init];
                                       marker.position = CLLocationCoordinate2DMake([lat doubleValue], [lng doubleValue]);
                                       marker.map = self.mapView;
                                   });

                               }
                           }];
    
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
//    camera = [GMSCameraPosition cameraWithLatitude:corvallis_x longitude:corvallis_y zoom:15];
    [self.mapView setCamera:camera];
    
    [manager stopUpdatingLocation];
}

// Places API here

//- (void)searchGroupsAtCoordinate:(CLLocationCoordinate2D)coordinate
//- (void) queryPlaces
//{
//
//}

@end

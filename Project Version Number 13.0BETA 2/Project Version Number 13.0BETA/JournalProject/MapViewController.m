//
//  MapViewController.m
//  JournalProject
//
//  Created by John S. Nelson on 11/19/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import "MapViewController.h"
#import "NewPostController.h"
#import "SWRevealViewController.h"



@interface MapViewController ()


@end

@implementation MapViewController

@synthesize geoPoint, mapView,post, sidebarButton,foodPlacemark,geocodeString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    mapView.delegate = self;
    
    // Extract the PFGeoPoint
    PFGeoPoint *geoPoint = post[@"location"];

    // Extract the title, subtitle and coordinate

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    /*
    NSLog(@" %f, %f", geoPoint.latitude, geoPoint.longitude);
    [self.navigationItem setRightBarButtonItem:nil];
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"Title"]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    //*/
    [self ConvertPostLocation:[[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude]];

    //NSLog(@" %f, %f", foodPlacemark.location.coordinate.longitude,foodPlacemark.location.coordinate.latitude);

    
    //NSLog(@" %f, %f", foodPlacemark.location.coordinate.longitude,foodPlacemark.location.coordinate.latitude);
}

-(void) ConvertPostLocation: (CLLocation*) location
{

    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarks, NSError* error)
     {
         if (placemarks && placemarks.count > 0)
         {
             
             CLPlacemark* topResult = [placemarks objectAtIndex:placemarks.count - 1];
             //foodPlacemark = topResult;
             //code to retrieve
             NSString *alpha = [NSString stringWithFormat:@"%@ %@",[topResult locality], [topResult administrativeArea]];
             geocodeString = alpha;
             //NSLog(@"geocodeString is %@",geocodeString);
             [self geocodePostLocation:alpha];
             

         }
     }];
}
-(void) geocodePostLocation:(NSString*) string
{
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:string completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks && placemarks.count > 0)
        {
            CLPlacemark* topResult = [placemarks objectAtIndex:0];
            foodPlacemark = topResult;
            MKCoordinateRegion zoomregion = MKCoordinateRegionMakeWithDistance(foodPlacemark.location.coordinate, 100000, 100000);
            [self.mapView setRegion:[self.mapView regionThatFits:zoomregion] animated:YES];
            [self.mapView addAnnotation:[[MKPlacemark alloc] initWithPlacemark:foodPlacemark]];
            //NSLog(@" %f, %f", foodPlacemark.location.coordinate.longitude,foodPlacemark.location.coordinate.latitude);
        }
    }];
    
}
-(void) viewDidAppear:(BOOL)animated
{
    if (self.navigationController.navigationBar.backItem == NULL)
    {
        sidebarButton.target = self.revealViewController;
        sidebarButton.action = @selector(revealToggle:);
        [self.navigationItem setLeftBarButtonItem:sidebarButton];
    }
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:72.0/255.0 green:145.0/255.0 blue:116.0/255.0 alpha:1.0]];
    //optional, i don't want my bar to be translucent
    //   [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [super viewDidAppear:animated];
    [self addPin];
    
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        MKPinAnnotationView* pinView = (MKPinAnnotationView*) [mapView dequeueReusableAnnotationViewWithIdentifier:@"foodAnnotation"];
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"foodAnnotation"];
            pinView.pinColor =  MKPinAnnotationColorGreen;
        }
        else
        {
            pinView.annotation = annotation;
            pinView.pinColor = MKPinAnnotationColorPurple;
        }
        
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
        pinView.canShowCallout = YES;
        return pinView;
    }
    return nil;
}

-(void)goBack{
    [self performSegueWithIdentifier:@"sw_rear" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)display
{
    [mapView setShowsUserLocation:YES];
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 400, 600);
    
    [mapView setRegion:region animated:YES];

}


-(void) addPin
{
    CLLocationCoordinate2D loc;
    loc.longitude = geoPoint.longitude;
    loc.latitude = geoPoint.latitude;
    MKPointAnnotation* mk = [[MKPointAnnotation alloc] init];
    mk.coordinate = loc;
    [mapView addAnnotation:mk];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

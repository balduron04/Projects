//
//  MapViewController.h
//  JournalProject
//
//  Created by John S. Nelson on 11/19/14.
//  Copyright (c) 2014 John S. Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface MapViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *MapTableView;

@property PFGeoPoint *geoPoint;
@property CLPlacemark* foodPlacemark;
@property PFObject *post;
@property NSString *geocodeString;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@end

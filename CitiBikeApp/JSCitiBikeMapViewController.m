//
//  JSCitiBikeMapViewController.m
//  CitiBikeApp
//
//  Created by James Scherer on 1/4/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//



#import "JSCitiBikeMapViewController.h"
#import "JSMapLocationMarker.h"

@interface JSCitiBikeMapViewController () <NSURLSessionDataDelegate, MKMapViewDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *stations;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) int mapZoomLevel;

@end

@implementation JSCitiBikeMapViewController

-(instancetype)init {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    [self fetchFeed];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    MKCoordinateRegion newRegion;
    
    newRegion.center.latitude = 40.6928;
    newRegion.center.longitude = -73.9903;
    
    newRegion.span.latitudeDelta = .2f;
    newRegion.span.longitudeDelta = .2f;
    
    [self.mapView setShowsPointsOfInterest:NO];
    [self.mapView setRegion:newRegion animated:NO];
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.mapZoomLevel = [self calculateZoomLevel:self.mapView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //NSLog(@"%@", [locations lastObject]);
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    CLLocationCoordinate2D coord = self.mapView.userLocation.location.coordinate;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 1000.0, 1000.0);
    
    [self.mapView setRegion:region animated:YES];
    
    
}

-(void)fetchFeed {
    
    NSString *requestString = @"https://www.citibikenyc.com/stations/json";
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        self.stations = jsonObject[@"stationBeanList"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addMarkers];
        });
        
    }];
    
    [dataTask resume];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKAnnotationView *annotationView = nil;
    
    if ([annotation isKindOfClass:[JSMapLocationMarker class]])
    {
        
        JSMapLocationMarker *tempMarker = annotation;
        
        
        annotationView = [JSMapLocationMarker createViewAnnotationForMapView:self.mapView annotation:annotation];
        
        if (self.mapZoomLevel >= 16) {
            
            annotationView.canShowCallout = YES;
            
            if (tempMarker.capacity >= 70 && tempMarker.capacity <= 90) {
                // provide the annotation view's image
                annotationView.image = [UIImage imageNamed:@"citibike_map_pin_70.png"];
            }
            else if (tempMarker.capacity <= 69 && tempMarker.capacity >= 50) {
                annotationView.image = [UIImage imageNamed:@"citibike_map_pin_50.png"];
                
            }
            else if (tempMarker.capacity <= 49 && tempMarker.capacity >= 30) {
                annotationView.image = [UIImage imageNamed:@"citibike_map_pin_30.png"];
            }
            else if (tempMarker.capacity <= 29) {
                annotationView.image = [UIImage imageNamed:@"citibike_map_pin_0.png"];
            }
            else {
                annotationView.image = [UIImage imageNamed:@"citibike_map_pin.png"];
            }
        }
        else {
            
            annotationView.canShowCallout = NO;
            
            if (tempMarker.capacity >= 70) {
                // provide the annotation view's image
                annotationView.image = [UIImage imageNamed:@"marker_zoomed_good.png"];
            }
            else if (tempMarker.capacity <= 69 && tempMarker.capacity >= 50) {
                annotationView.image = [UIImage imageNamed:@"marker_zoomed_good.png"];
                
            }
            else if (tempMarker.capacity <= 49 && tempMarker.capacity >= 30) {
                annotationView.image = [UIImage imageNamed:@"marker_zoomed_good.png"];
            }
            else if (tempMarker.capacity <= 29 && tempMarker.capacity >= 10) {
                annotationView.image = [UIImage imageNamed:@"marker_zoomed_low.png"];
            }
            else {
                annotationView.image = [UIImage imageNamed:@"marker_zoomed_empty.png"];
            }
        }
        
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        [detailButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        annotationView.rightCalloutAccessoryView = detailButton;
        
        return annotationView;
        
    }
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
        CLLocationCoordinate2D  coord = CLLocationCoordinate2DMake([[view annotation] coordinate].latitude, [[view annotation] coordinate].longitude);
        
        MKCoordinateRegion pinRegion = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
        
        [self.mapView setRegion:pinRegion animated:YES];
        
        NSLog(@"Lat: %f Long: %f", [[view annotation] coordinate].latitude, [[view annotation] coordinate].longitude);
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    
    NSLog(@"Zoom Level: %d", [self calculateZoomLevel:mapView]);
    
    if ([self calculateZoomLevel:mapView] != self.mapZoomLevel) {
        [self removeAllAnnotations];
        [self addMarkers];
    }
    else
        NSLog(@"Nothing Changed");
    
    NSLog(@"Map Delta: %f, Long Deklta: %f", self.mapView.region.span.longitudeDelta, self.mapView.region.span.longitudeDelta);

    
    self.mapZoomLevel = [self calculateZoomLevel:mapView];
    
}

-(void)addMarkers {
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    NSLog(@"%@", self.stations[1]);
    
    for (int i = 0; i < self.stations.count; ++i) {
        
        NSDictionary *tempDict = self.stations[i];
        JSMapLocationMarker *loc = [[JSMapLocationMarker alloc] init];
        float calc = 0;
        int capacity = 0;
        
        NSString *latString = tempDict[@"latitude"];
        NSString *longString = tempDict[@"longitude"];
        NSString *availDocks = tempDict[@"availableDocks"];
        NSString *availBikes = tempDict[@"availableBikes"];
        
        float latitude = [latString floatValue];
        float longitude = [longString floatValue];
        float docks = [availDocks floatValue];
        float bikes = [availBikes floatValue];
        
        CLLocationCoordinate2D tempMarkerLocation;
        tempMarkerLocation.latitude = latitude;
        tempMarkerLocation.longitude = longitude;
        
        if(bikes == 0 && docks == 0)
            capacity = 0;
        else
            calc = bikes/(bikes+docks) * 100;
        
        capacity = (int)roundf(calc);
        
        loc.stationName = tempDict[@"stationName"];
        loc.stationInfo = [NSString stringWithFormat:@"Bikes: %@   Docks: %@", availBikes, availDocks];
        loc.where = tempMarkerLocation;
        loc.docks = (int)roundf(docks);
        loc.bikes = bikes;
        loc.capacity = capacity;
        
        [annotations addObject:loc];
        
    }
    
    [self.mapView addAnnotations:annotations];
    
}

-(void)buttonAction:(id)sender {
    
    
    
}

-(int)calculateZoomLevel:(MKMapView*)mapView {
    
    int zoomLevel = 20;
    
    int zoomScale = mapView.visibleMapRect.size.width / mapView.bounds.size.width;
    double zoomExponent = log(zoomScale);
    zoomLevel = (int)(20 - ceil(zoomExponent));
    
    return zoomLevel;
    
}

-(void)removeAllAnnotations {
    
    id userAnnotation = self.mapView.userLocation;
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
}


@end

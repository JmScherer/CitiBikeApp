//
//  JSMapLocationMarker.h
//  CitiBikeApp
//
//  Created by James Scherer on 1/4/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface JSMapLocationMarker : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D where;
@property (nonatomic, copy) NSString *stationName;
@property (nonatomic, copy) NSString *stationInfo;
@property (nonatomic) int bikes;
@property (nonatomic) int docks;
@property (nonatomic) int capacity;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end

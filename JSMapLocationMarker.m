//
//  JSMapLocationMarker.m
//  CitiBikeApp
//
//  Created by James Scherer on 1/4/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//

#import "JSMapLocationMarker.h"

@implementation JSMapLocationMarker

-(id)initMarker {
    
    self = [super init];
    return self;
}

-(NSString*)title {
    return _stationName;
}

-(CLLocationCoordinate2D)coordinate{
    return _where;
}

-(NSString*)subtitle {
    return _stationInfo;
}

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([JSMapLocationMarker class])];
    if (returnedAnnotationView == nil)
    {
        
        returnedAnnotationView =
        [[MKAnnotationView alloc] initWithAnnotation:annotation
                                     reuseIdentifier:NSStringFromClass([JSMapLocationMarker class])];
        
        returnedAnnotationView.canShowCallout = YES;
        
    }
    else
    {
        returnedAnnotationView.annotation = annotation;
    }
    return returnedAnnotationView;
}

@end

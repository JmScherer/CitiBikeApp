//
//  JSCitiBikeMapViewController.h
//  CitiBikeApp
//
//  Created by James Scherer on 1/4/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface JSCitiBikeMapViewController : UIViewController <CLLocationManagerDelegate> {
}

@property (nonatomic, retain) CLLocationManager *locationManager;

@end

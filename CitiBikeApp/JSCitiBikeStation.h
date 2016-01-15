//
//  JSCitiBikeStation.h
//  CitiBikeApp
//
//  Created by James Scherer on 1/12/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JSCitiBikeStation : NSManagedObject

@property (nonatomic) float altitude;
@property (nonatomic) int availableBikes;
@property (nonatomic) int availableDocks;
@property (nonatomic, strong) NSString *city;
@property (nonatomic) int stationID;
@property (nonatomic, strong) NSString *landMark;
@property (nonatomic, strong) NSDate *lastCommunicationTime;
@property (nonatomic) float latitude;
@property (nonatomic, strong) NSString *location;
@property (nonatomic) float longitude;
@property (nonatomic) int postalCode;
@property (nonatomic, strong) NSString *stAddress1;
@property (nonatomic, strong) NSString *stAddress2;
@property (nonatomic) int statusKey;
@property (nonatomic, strong) NSString *statusValue;
@property (nonatomic) int testStation;
@property (nonatomic) int totalDocks;

@end

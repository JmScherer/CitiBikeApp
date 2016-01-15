//
//  JSCitiBikeStationStore.h
//  CitiBikeApp
//
//  Created by James Scherer on 1/12/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSCitiBikeStation;

@interface JSCitiBikeStationStore : NSObject

@property (nonatomic, strong) NSArray *allStations;

+(instancetype)sharedStore;

+(void)preloadStations;

@end

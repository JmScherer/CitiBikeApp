//
//  JSCitiBikeStationStore.m
//  CitiBikeApp
//
//  Created by James Scherer on 1/12/16.
//  Copyright © 2016 James Scherer. All rights reserved.
//

#import "JSCitiBikeStationStore.h"
#import "Reachability.h"


@import CoreData;

@interface JSCitiBikeStationStore ()

@property (nonatomic) NSMutableArray *privateStations;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@property (nonatomic) Reachability *hostReachable;

@end

@implementation JSCitiBikeStationStore

+(instancetype)sharedStore {
    
    static JSCitiBikeStationStore *stationStore = nil;
    
    if(!stationStore) {
        stationStore = [[self alloc] initPrivate];
    }
    
    return stationStore;
    
}

-(instancetype)initPrivate {
    
    self = [super init];
    
    if(self) {
        
        _model = [NSManagedObjectModel mergedModelFromBundles:[NSBundle allBundles]];
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSURL *path = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"Database.sqlite"];
        
        NSError *error = nil;
        
        if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:path options:nil error:&error]) {
            
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
            
        }
        
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_context setPersistentStoreCoordinator:psc];
        
    }
    
    return self;
}


-(instancetype)init {
    
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[JSCitiBikeStationStore sharedStore]" userInfo:nil];
    
    return nil;
    
}

-(void)loadAllStations {
 
    if(!self.privateStations) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"Station" inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSError *error = nil;
        
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if(!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateStations = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(void)saveAllStations {
    
    
    
}

-(void)preloadStations {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CitiBikeStations" ofType:@"plist"];
    
    NSError *error;
    
    NSArray *stations = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:path] options:kCFPropertyListImmutable format:nil error:&error];
    
    
    
    
}

@end
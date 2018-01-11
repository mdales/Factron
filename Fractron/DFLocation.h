//
//  DFLocation.h
//  Fractron
//
//  Created by Michael Dales on 11/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "BRUBaseDefines.h"

@interface DFLocation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;

BRU_DEFAULT_INIT_UNAVAILABLE(nonnull)

- (nonnull instancetype)initLocationWithName:(nonnull NSString *)name
                                    latitude:(nonnull NSNumber *)latitude
                                   longitude:(nonnull NSNumber *)longitude;


@end

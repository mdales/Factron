//
//  DFLocation.m
//  Fractron
//
//  Created by Michael Dales on 11/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import "BRUAsserts.h"

#import "DFLocation.h"

@implementation DFLocation

BRU_DEFAULT_INIT_UNAVAILABLE_IMPL

- (nonnull instancetype)initLocationWithName:(nonnull NSString *)name
                                    latitude:(nonnull NSNumber *)latitude
                                   longitude:(nonnull NSNumber *)longitude
{
    BRUParameterAssert(name);
    BRUParameterAssert(latitude);
    BRUParameterAssert(longitude);
    
    self = [super init];
    if (nil != self) {
        _title = [name copy];
        _coordinate.latitude = [latitude doubleValue];
        _coordinate.longitude = [longitude doubleValue];
    }
    return self;
}


@end

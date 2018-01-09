//
//  DFMandelbrot.m
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import "BRUARCUtils.h"

#import "DFMandelbrot.h"

@interface DFMandelbrot ()


@end

@implementation DFMandelbrot

- (nonnull instancetype)initWithIterations: (NSInteger)iterations
                                dimensions: (NSSize)dimensions
                                    region: (NSRect)region
{
    self = [super init];
    if (nil != self) {
        _iterations = iterations;
        _dimensions = dimensions;
        _region = region;
    }
    
    return self;
}

- (BOOL)startGenerationWithError: (NSError * _Nullable * _Nullable)error
                        callback: (void (^ _Nonnull )(DFMandelbrot* _Nonnull generator, NSImage * _Nonnull image))callback
{
    NSParameterAssert(callback);
    
    // create an array for the data
    NSMutableData *data = [[NSMutableData alloc] initWithLength: self.dimensions.width * self.dimensions.height * sizeof(NSInteger)];
    NSAssert(data, @"Failed to allocate data!"); // docs imply this never fails
    
    BRU_weakify(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^() {
        BRU_strongify(self);
        if (nil == self) {
            return;
        }
        
        
    });
    
    return YES;
}

@end

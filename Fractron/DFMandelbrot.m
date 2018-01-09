//
//  DFMandelbrot.m
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import "BRUARCUtils.h"

#import "DFMandelbrot.h"

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

- (NSInteger)calculateInterationsForPoint: (NSPoint)c
{
    NSPoint z = c;
    for (NSInteger i = 0; i < self.iterations; i++) {
        NSPoint old = z;
        z.x = (old.x * old.x) - (old.y * old.y) + c.x;
        z.y = (2 * old.x * old.y) + c.y;
        if (((z.x * z.x) + (z.y * z.y)) > 4.0) {
            return i;
        }
    }
    return -1;
}

- (BOOL)startGenerationWithError: (NSError * _Nullable * _Nullable)error
                        callback: (void (^ _Nonnull )(DFMandelbrot* _Nonnull generator, NSData * _Nonnull imageData))callback
{
    NSParameterAssert(callback);
    
    BRU_weakify(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^() {
        BRU_strongify(self);
        if (nil == self) {
            return;
        }
    
        NSMutableData *data = [[NSMutableData alloc] initWithLength: self.dimensions.width * self.dimensions.height];
        NSAssert(data, @"Failed to allocate data!"); // docs imply this never fails
        uint8_t *p = (uint8_t*)data.bytes;
        
        double x_skip = self.region.size.width / self.dimensions.width;
        double y_skip = self.region.size.height / self.dimensions.height;
        
        for (NSInteger x = 0; x < self.dimensions.width; x++) {
            for (NSInteger y = 0; y < self.dimensions.height; y++) {
                NSPoint fractalPoint = NSMakePoint(self.region.origin.x + (x_skip * x), self.region.origin.y + (y_skip * y));
                NSInteger escape = [self calculateInterationsForPoint: fractalPoint];
                if (escape >= 0) {
                    p[x + (y * (NSInteger)self.dimensions.width)] = 196 - (uint8_t)(escape % 128);
                } else {
                    p[x + (y * (NSInteger)self.dimensions.width)] = 0;
                }
            }
        }
        
        callback(self, data);
    });
    
    return YES;
}

@end

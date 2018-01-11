//
//  DFMandelbrot.m
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import "BRUARCUtils.h"
#import "BRUAsserts.h"

#import "DFMandelbrot.h"

@implementation DFMandelbrot

BRU_DEFAULT_INIT_UNAVAILABLE_IMPL

- (nonnull instancetype)initWithIterations:(NSUInteger)iterations
                                dimensions:(NSSize)dimensions
                                    region:(NSRect)region
{
    self = [super init];
    if (nil != self) {
        _iterations = iterations;
        _dimensions = dimensions;
        _region = region;
    }
    
    return self;
}

- (nonnull NSString*)description
{
    return [NSString stringWithFormat:@"<DFMandelbrot: %@ in %@ with %lu iterations>", NSStringFromRect(self.region),
            NSStringFromSize(self.dimensions), (unsigned long)self.iterations];
}

+ (NSInteger)calculateIterationsForPoint:(NSPoint)c
                              iterations:(NSUInteger)iterations
{
    NSPoint z = c;
    for (NSUInteger i = 0; i < iterations; i++) {
        NSPoint old = z;
        z.x = (old.x * old.x) - (old.y * old.y) + c.x;
        z.y = (2 * old.x * old.y) + c.y;
        if (((z.x * z.x) + (z.y * z.y)) > 4.0) {
            return (NSInteger)i;
        }
    }
    return -1;
}

+ (void)generateRow:(NSUInteger)y
           fractalY:(CGFloat)fractalY
           fractalX:(CGFloat)fractalX
             x_skip:(CGFloat)x_skip
             buffer:(uint8_t*)p
              width:(NSUInteger)width
         iterations:(NSUInteger)iterations
{
    for (NSUInteger x = 0; x < width; x++) {
        NSPoint fractalPoint = NSMakePoint(fractalX + (x_skip * x), fractalY);
        NSInteger escape = [DFMandelbrot calculateIterationsForPoint:fractalPoint
                                                          iterations:iterations];
        if (escape >= 0) {
            p[x + (y * width)] = 196 - (uint8_t)(escape % 128);
        } else {
            p[x + (y * width)] = 63;
        }
    }
}

- (BOOL)startGeneration:(void (^ _Nonnull )(DFMandelbrot* _Nonnull generator, NSData * _Nonnull imageData))callback
{
    BRUParameterAssert(callback);
    
    BRU_weakify(self);
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^() {
        BRU_strongify(self);
        if (nil == self) {
            return;
        }
    
        NSMutableData *data = [[NSMutableData alloc] initWithLength:(NSUInteger)(self.dimensions.width * self.dimensions.height)];
        BRUAssert(data, @"Failed to allocate data!"); // docs imply this never fails
        uint8_t *p = (uint8_t*)data.bytes;
        
        double x_skip = self.region.size.width / self.dimensions.width;
        double y_skip = self.region.size.height / self.dimensions.height;
        
        for (NSUInteger y = 0; y < self.dimensions.height; y++) {
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^() {
                BRU_strongify(self);
                if (nil == self) {
                    return;
                }
            
                [DFMandelbrot generateRow:y
                                 fractalY:self.region.origin.y + (y_skip * y)
                                 fractalX:self.region.origin.x
                                   x_skip:x_skip
                                   buffer:p
                                    width:(NSUInteger)self.dimensions.width
                               iterations:self.iterations];
                
                callback(self, data);
            });
        }
    });
    
    return YES;
}

@end

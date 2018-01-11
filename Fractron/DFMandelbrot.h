//
//  DFMandelbrot.h
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRUBaseDefines.h"

/**
 * Mandelbrot generator class. Uses GCD internally to make generation concurrent, and off the main thread.
 */
@interface DFMandelbrot : NSObject

@property (nonatomic, readonly) NSUInteger iterations;
@property (nonatomic, readonly) NSRect region;

BRU_DEFAULT_INIT_UNAVAILABLE(nonnull);

/**
 * Construct a representation of a mandelbrot.
 *
 * @param iterations How many iterations to run of the algorithm per pixel. More iterations increase accuracy by decrease performance.
 * @param region The area of the mandelbrot to be rendered into the image.
 */
- (nonnull instancetype)initWithIterations:(NSUInteger)iterations
                                    region:(NSRect)region;

/**
 * Will start the actual calculation of the image, and call the callback possibly multiple times whilst the image is generated.
 *
 * @param dimensions The bitmap image size to be generated.
 * @param callback A callback to be invoked when there is an update to the image being generated. Can be called multiple times
 *                 so as to give progressive updates. The data contains a greyscale 8bpp bitmap at the dimensions specified.
 */
- (BOOL)generateBitmapWithSize:(NSSize)dimensions
                      callback:(void (^ _Nonnull )(DFMandelbrot* _Nonnull generator, NSSize dimensions, NSData * _Nonnull imageData))callback;
@end

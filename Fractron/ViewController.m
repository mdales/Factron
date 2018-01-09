//
//  ViewController.m
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import "BRUARCUtils.h"

#import "ViewController.h"
#import "DFMandelbrot.h"

@interface ViewController()

@property (atomic, strong, readwrite, nullable) DFMandelbrot *mandelbrot;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mandelbrot = [[DFMandelbrot alloc] initWithIterations:256
                                                    dimensions:self.imageView.frame.size
                                                        region:NSMakeRect(-0.0, -0.7, 0.1, 0.1)];
    BRU_weakify(self);
    [self.mandelbrot startGenerationWithError:nil
                                     callback:^(DFMandelbrot* _Nonnull generator, NSData * _Nonnull imageData)
    {
        NSParameterAssert(generator);
        NSParameterAssert(imageData);
        
        dispatch_async(dispatch_get_main_queue(), ^() {
            BRU_strongify(self);
            if (nil == self) {
                return;
            }
            
            unsigned char *p = (unsigned char *)imageData.bytes;
            NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&p
                                                                                 pixelsWide:generator.dimensions.width
                                                                                 pixelsHigh:generator.dimensions.height
                                                                              bitsPerSample:8
                                                                            samplesPerPixel:1
                                                                                   hasAlpha:NO
                                                                                   isPlanar:NO
                                                                             colorSpaceName:NSCalibratedWhiteColorSpace
                                                                                bytesPerRow:generator.dimensions.width
                                                                               bitsPerPixel:8];

            NSImage * image = [[NSImage alloc] initWithSize:generator.dimensions];
            [image addRepresentation:imageRep];
            
            self.imageView.image = image;
        });
    }];
}


@end

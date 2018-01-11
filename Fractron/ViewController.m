//
//  ViewController.m
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import "BRUARCUtils.h"
#import "BRUAsserts.h"

#import "ViewController.h"
#import "DFMandelbrot.h"

@interface ViewController()

@property (atomic, strong, readwrite, nullable) DFMandelbrot *mandelbrot;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self generateNewFractal:nil];
}

- (IBAction)generateNewFractal:(__unused __nullable id)sender
{
    // Initally just work with first screen. We'll figure out what to do with others later.
    NSScreen *screen = [[NSScreen screens] firstObject];
    if (nil == screen) {
        NSLog(@"No screens present, not generating anything");
        return;
    }
    NSSize screenSize = NSMakeSize(screen.frame.size.width * screen.backingScaleFactor,
                                   screen.frame.size.height * screen.backingScaleFactor);
    
    self.mandelbrot = [[DFMandelbrot alloc] initWithIterations:1000
                                                        region:NSMakeRect(-2.0, -2.0, 4.0, 4.0)];
    BRU_weakify(self);
    [self.mandelbrot generateBitmapWithSize:screenSize
                                   callback:^(DFMandelbrot* _Nonnull generator, NSSize dimensions, NSData * _Nonnull imageData)
     {
         BRUParameterAssert(generator);
         BRUParameterAssert(imageData);
         
         dispatch_async(dispatch_get_main_queue(), ^() {
             BRU_strongify(self);
             if (nil == self) {
                 return;
             }
             
             unsigned char *p = (unsigned char *)imageData.bytes;
             NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:&p
                                                                                  pixelsWide:(NSInteger)dimensions.width
                                                                                  pixelsHigh:(NSInteger)dimensions.height
                                                                               bitsPerSample:8
                                                                             samplesPerPixel:1
                                                                                    hasAlpha:NO
                                                                                    isPlanar:NO
                                                                              colorSpaceName:NSCalibratedWhiteColorSpace
                                                                                 bytesPerRow:(NSInteger)dimensions.width
                                                                                bitsPerPixel:8];
             
             NSImage * image = [[NSImage alloc] initWithSize:dimensions];
             [image addRepresentation:imageRep];
             
             self.imageView.image = image;
         });
     }];
}

@end

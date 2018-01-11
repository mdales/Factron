//
//  LocationProjectionTests.m
//  FractronTests
//
//  Created by Michael Dales on 11/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DFMandelbrot.h"

@interface LocationProjectionTests : XCTestCase

@end

@implementation LocationProjectionTests

- (void)testLocationSanity {
    
    // Load the data from the plist
    NSString *path = [[NSBundle bundleForClass:[self class]] resourcePath];
    NSString *locationDataPath = [path stringByAppendingPathComponent:@"Locations.plist"];
    NSArray<NSDictionary *> *locationData = [NSArray arrayWithContentsOfFile:locationDataPath];
    
    for (NSDictionary *location in locationData) {
        // high level overview
        DFMandelbrot *m = [[DFMandelbrot alloc] initWithIterations:256
                                                            region:NSMakeRect([location[@"Latitude"] doubleValue] / 90.0,
                                                                              [location[@"Longitude"] doubleValue] / 45.0,
                                                                              0.1, 0.1)];
        XCTAssertNotNil(m, @"Failed to generate mandelbrot");
        NSSize testSize = NSMakeSize(16.0, 16.0);
        __block NSData *data = nil;
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSError *err = nil;
        BOOL res = [m generateBitmapWithSize:testSize
                                       error:&err
                                    callback:^(DFMandelbrot* _Nonnull generator, NSSize dimensions, NSData * _Nonnull imageData) {
                                        data = imageData;
                                        dispatch_semaphore_signal(sem);
                                    }];
        XCTAssertTrue(res, @"Error starting generation: %@", err);
        XCTAssertNil(err, @"Got unexpected error");
        
        // we get an update per line rendered, so need to wait for all to complete
        for (NSUInteger i = 0; i < (NSUInteger)testSize.height; i++) {
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        }
        XCTAssertNotNil(data, @"Failed to get image data from %@", m);
        XCTAssertEqual(data.length, (NSUInteger)(testSize.width * testSize.height));
        
        BOOL variance = NO;
        // we'd expect some variance in this image
        uint8_t *p = (uint8_t*)data.bytes;
        uint8_t val = p[0];
        for (NSUInteger i = 1; i < data.length; i++) {
            variance = val != p[i];
            if (NO != variance) {
                break;
            }
        }
        XCTAssertEqual(variance, YES, @"Did not get expected variance in %@", location);
    }
}

@end

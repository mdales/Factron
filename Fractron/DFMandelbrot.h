//
//  DFMandelbrot.h
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFMandelbrot : NSObject

@property (nonatomic, readonly) NSInteger iterations;
@property (nonatomic, readonly) NSSize dimensions;
@property (nonatomic, readonly) NSRect region;

- (nonnull instancetype)initWithIterations: (NSInteger)interations
                                dimensions: (NSSize)dimensions
                                    region: (NSRect)region;

- (BOOL)startGenerationWithError: (NSError * _Nullable * _Nullable)error
                        callback: (void (^ _Nonnull )(DFMandelbrot* _Nonnull generator, NSData * _Nonnull imageData))callback;

@end

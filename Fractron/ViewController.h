//
//  ViewController.h
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MapKit/MapKit.h>

@interface ViewController : NSViewController <MKMapViewDelegate>

@property (nonatomic, readwrite, weak, nullable) IBOutlet NSImageView *imageView;
@property (nonatomic, readwrite, weak, nullable) IBOutlet MKMapView *mapView;

- (IBAction)generateNewFractal:(__nullable id)sender;

@end


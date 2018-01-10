//
//  ViewController.h
//  Fractron
//
//  Created by Michael Dales on 09/01/2018.
//  Copyright © 2018 Digital Flapjack. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (nonatomic, readwrite, weak, nullable) IBOutlet NSImageView *imageView;

- (IBAction)generateNewFractal:(__nullable id)sender;


@end


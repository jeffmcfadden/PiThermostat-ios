//
//  InterfaceController.h
//  PiThermostat-Shed WatchKit Extension
//
//  Created by Jeff McFadden on 4/13/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

- (IBAction)imHot:(id)sender;
- (IBAction)imCold:(id)sender;

@end

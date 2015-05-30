//
//  ViewController.h
//  PiThermostat-Shed
//
//  Created by Jeff McFadden on 4/11/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import <UIKit/UIKit.h>
@import PiThermostatKit;

@interface ThermostatViewController : UIViewController {
    PiThermostat * _thermostat;
}

@property (nonatomic) PiThermostat *thermostat;

- (void)refresh;

@end


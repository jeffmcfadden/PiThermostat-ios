//
//  ViewController.m
//  PiThermostat-Shed
//
//  Created by Jeff McFadden on 4/11/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import "ThermostatViewController.h"


@interface ThermostatViewController ()

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic) IBOutlet UILabel *labelCurrentTemperature;
@property (nonatomic) IBOutlet UILabel *labelTargetTemperature;

@end

@implementation ThermostatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.isRefreshing = NO;
}

- (void)setThermostat:(PiThermostat *)thermostat
{
    _thermostat = thermostat;
}

- (PiThermostat *)thermostat
{
    return _thermostat;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refresh];
}

- (void)refresh
{
    if (self.isRefreshing) {
        return;
    }
    
    self.isRefreshing = YES;
    [self.thermostat refreshWithCompletion:^(PiThermostat *thermostat, NSError *error){
        
        self.thermostat = thermostat;
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            self.labelCurrentTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.currentTemperature];
            self.labelTargetTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.targetTemperature];

            self.navigationItem.title = self.title = [NSString stringWithFormat:@"%@", thermostat.name];
            
        });
        
        self.isRefreshing = NO;
    }];
}

- (IBAction)imHot:(id)sender
{
    if (self.isRefreshing) {
        return;
    }
    
    self.isRefreshing = YES;
    [self.thermostat imHotWithCompletion:^(PiThermostat *thermostat, NSError *error){
        self.thermostat = thermostat;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.labelCurrentTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.currentTemperature];
            self.labelTargetTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.targetTemperature];
            
        });
        
        self.isRefreshing = NO;
    }];
}

- (IBAction)imCold:(id)sender
{
    if (self.isRefreshing) {
        return;
    }

    self.isRefreshing = YES;
    [self.thermostat imColdWithCompletion:^(PiThermostat *thermostat, NSError *error){
        self.thermostat = thermostat;

        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.labelCurrentTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.currentTemperature];
            self.labelTargetTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.targetTemperature];
            
        });
        
        self.isRefreshing = NO;
    }];
}

@end

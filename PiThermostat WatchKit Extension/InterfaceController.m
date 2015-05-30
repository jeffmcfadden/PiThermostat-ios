//
//  InterfaceController.m
//  PiThermostat-Shed WatchKit Extension
//
//  Created by Jeff McFadden on 4/13/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import "InterfaceController.h"
@import PiThermostatKit;

@interface InterfaceController()

@property (nonatomic) PiThermostat *thermostat;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic) IBOutlet WKInterfaceLabel *labelCurrentTemperature;
@property (nonatomic) IBOutlet WKInterfaceLabel *labelTargetTemperature;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    self.isRefreshing = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.201.183"];
    NSString *username = @"thermostat";
    NSString *password = @"TaDj3PmWiyt^wLE7";
    
    self.thermostat = [[PiThermostat alloc] initWithURL:url username:username password:password];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [self refresh];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)refresh
{
    if (self.isRefreshing) {
        return;
    }
    
    self.isRefreshing = YES;
    [self.thermostat refreshWithCompletion:^(PiThermostat *thermostat, NSError *error){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.labelCurrentTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.currentTemperature];
            self.labelTargetTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.targetTemperature];
            
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.labelCurrentTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.currentTemperature];
            self.labelTargetTemperature.text = [NSString stringWithFormat:@"%0.1f", thermostat.targetTemperature];
            
        });
        
        self.isRefreshing = NO;
    }];
}


@end




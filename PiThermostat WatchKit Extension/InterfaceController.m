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

    if (context != nil && [context isKindOfClass:[NSDictionary class]]) {
        self.thermostat = [[PiThermostat alloc] initWithDictionary:context];
    }
    
    // Configure interface objects here.
    self.isRefreshing = NO;
}

static BOOL first = YES;

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if (first) {
        [WKInterfaceController openParentApplication:@{@"initialLaunch": @YES} reply:^(NSDictionary *replyInfo, NSError *error){
            
            if (error) {
                NSLog( @"Error: %@", error );
            }
            
            NSMutableArray *controllers = [@[] mutableCopy];
            NSMutableArray *contexts    = [@[] mutableCopy];
            
            for (NSDictionary *tDict in replyInfo[@"thermostats"]) {
                [controllers addObject:@"pageController"];
                [contexts addObject:tDict];
            }
            
            [WKInterfaceController reloadRootControllersWithNames:controllers contexts:contexts];
        }];

        first = NO;
    }else{
        [self refresh];
    }
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
            
            [self setTitle:[NSString stringWithFormat:@"%@", thermostat.name]];
            
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




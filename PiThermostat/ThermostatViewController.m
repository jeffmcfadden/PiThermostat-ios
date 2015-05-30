//
//  ViewController.m
//  PiThermostat-Shed
//
//  Created by Jeff McFadden on 4/11/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import "ThermostatViewController.h"

@import PiThermostatKit;

@interface ThermostatViewController ()

@property (nonatomic) PiThermostat *thermostat;

@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic) IBOutlet UILabel *labelCurrentTemperature;
@property (nonatomic) IBOutlet UILabel *labelTargetTemperature;

@end

@implementation ThermostatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.isRefreshing = NO;
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.201.183"];
    NSString *username = @"thermostat";
    NSString *password = @"TaDj3PmWiyt^wLE7";
    
    self.thermostat = [[PiThermostat alloc] initWithURL:url username:username password:password];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

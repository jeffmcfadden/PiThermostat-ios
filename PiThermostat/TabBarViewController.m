//
//  TabBarViewController.m
//  PiThermostat
//
//  Created by Jeff McFadden on 5/30/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import "Constants.h"
#import "TabBarViewController.h"
#import "ThermostatViewController.h"
#import "EditThermostatViewController.h"
@import PiThermostatKit;

@interface TabBarViewController () <EditThermostatViewControllerDelegate>

@property (nonatomic) EditThermostatViewController *editNewThermostatViewController;

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSavedThermostats];
}

- (void)loadSavedThermostats
{
    NSArray *thermostats = [[NSUserDefaults standardUserDefaults] objectForKey:kPTSavedThermostatsPreferenceKey];
    
    NSMutableArray *vcs = [@[] mutableCopy];
    
    for (NSDictionary *d in thermostats) {
        
        NSURL *url = [NSURL URLWithString:d[@"url"]];
        
        PiThermostat *t = [[PiThermostat alloc] initWithURL:url username:d[@"username"] password:d[@"password"]];
        
        ThermostatViewController *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"thermostatViewController"];
        
        tvc.thermostat = t;
        
        [vcs addObject:tvc];
    }
    
    self.editNewThermostatViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"editThermostatViewController"];
    self.editNewThermostatViewController.title = @"New";
    self.editNewThermostatViewController.delegate = self;
    [vcs addObject:self.editNewThermostatViewController];

    self.viewControllers = vcs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    for (UIViewController *vc in self.viewControllers) {
        
        if ([vc isKindOfClass:[ThermostatViewController class]]) {
            [((ThermostatViewController *)vc) refresh];
        }
        
    }
}

- (void)saveThermostats
{
    NSMutableArray *thermostatDictionaries = [@[] mutableCopy];
    
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:[ThermostatViewController class]]) {
            PiThermostat *t = [((ThermostatViewController *)vc) thermostat];
            [thermostatDictionaries addObject:[t dictionaryRepresentation]];
        }
    }

    
    [[NSUserDefaults standardUserDefaults] setObject:thermostatDictionaries forKey:kPTSavedThermostatsPreferenceKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark EditThermostatViewControllerDelegate
- (void)editThermostatViewController:(EditThermostatViewController *)editThermostatViewController finishedWithThermostatData:(NSDictionary *)data
{
    if (editThermostatViewController == self.editNewThermostatViewController) {
        PiThermostat *t = [[PiThermostat alloc] initWithURL:data[@"url"] username:data[@"username"] password:data[@"password"]];
        
        ThermostatViewController *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"thermostatViewController"];
        
        tvc.thermostat = t;
        
        NSMutableArray *vcs = [@[] mutableCopy];
        
        for (UIViewController *vc in self.viewControllers) {
            if (vc != self.editNewThermostatViewController) {
                [vcs addObject:vc];
            }
        }
        
        [vcs addObject:tvc];
        
        [vcs addObject:self.editNewThermostatViewController];
        
        [self setViewControllers:vcs animated:YES];
        
        [self setSelectedViewController:tvc];
        
        [self saveThermostats];
    }
}

- (void)editThermostatViewControllerCancelled:(EditThermostatViewController *)editThermostatViewController
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

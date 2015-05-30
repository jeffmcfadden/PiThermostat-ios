//
//  EditThermostatViewController.m
//  PiThermostat
//
//  Created by Jeff McFadden on 5/30/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import "EditThermostatViewController.h"

@interface EditThermostatViewController ()


@end

@implementation EditThermostatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)save:(id)sender
{
    NSDictionary *data = @{
                           @"url"      : [NSString stringWithFormat:@"%@", self.urlField.text],
                           @"username" : [NSString stringWithFormat:@"%@", self.usernameField.text],
                           @"password" : [NSString stringWithFormat:@"%@", self.passwordField.text]
                           };
    
    [self resignFirstResponder];
    
    [self.delegate editThermostatViewController:self finishedWithThermostatData:data];
}

- (IBAction)cancel:(id)sender
{
    [self.delegate editThermostatViewControllerCancelled:self];
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

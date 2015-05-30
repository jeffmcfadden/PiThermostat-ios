//
//  EditThermostatViewController.h
//  PiThermostat
//
//  Created by Jeff McFadden on 5/30/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditThermostatViewController;

@protocol EditThermostatViewControllerDelegate <NSObject>

- (void)editThermostatViewController:(EditThermostatViewController *)editThermostatViewController finishedWithThermostatData:(NSDictionary *)data;
- (void)editThermostatViewControllerCancelled:(EditThermostatViewController *)editThermostatViewController;

@end

@interface EditThermostatViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *urlField;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (weak) id<EditThermostatViewControllerDelegate>delegate;

@end

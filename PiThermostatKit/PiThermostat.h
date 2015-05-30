//
//  PiThermostat.h
//  PiThermostat-Shed
//
//  Created by Jeff McFadden on 4/13/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PiThermostat : NSObject <NSCopying>

@property (nonatomic, assign, readonly) CGFloat currentTemperature;
@property (nonatomic, assign, readonly) CGFloat targetTemperature;

- (id)initWithURL:(NSURL *)url username:(NSString *)username password:(NSString *)password;

- (void)refreshWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock;

- (void)imHotWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock;
- (void)imColdWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock;

@end

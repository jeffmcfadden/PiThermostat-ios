//
//  PiThermostat.h
//  PiThermostat-Shed
//
//  Created by Jeff McFadden on 4/13/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTThermostatMode) {
    PTThermostatModeOff,
    PTThermostatModeFan,
    PTThermostatModeHeat,
    PTThermostatModeCool,
    PTThermostatModeUnknown
};

@interface PiThermostat : NSObject <NSCopying>

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, assign, readonly) CGFloat currentTemperature;
@property (nonatomic, assign, readonly) CGFloat targetTemperature;
@property (nonatomic, assign, readonly) PTThermostatMode currentMode;

- (id)initWithURL:(NSURL *)url username:(NSString *)username password:(NSString *)password;

- (void)refreshWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock;

- (void)imHotWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock;
- (void)imColdWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock;

- (NSDictionary *)dictionaryRepresentation;

@end

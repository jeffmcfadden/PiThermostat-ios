//
//  PiThermostat.m
//  PiThermostat-Shed
//
//  Created by Jeff McFadden on 4/13/15.
//  Copyright (c) 2015 ForgeApps. All rights reserved.
//

#import "PiThermostat.h"

@interface PiThermostat()

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end

@implementation PiThermostat

- (id)initWithURL:(NSURL *)url username:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.url = [url copy];
        self.username = [username copy];
        self.password = [password copy];
    }
    return self;
}

- (void)updateFromJSONData:(NSDictionary *)jsonData
{
    _name               = jsonData[@"name"];
    _currentTemperature = [jsonData[@"current_temperature"] doubleValue];
    _targetTemperature  = [jsonData[@"target_temperature"] doubleValue];
    
    NSString *modeString = jsonData[@"mode"];
    
    PTThermostatMode mode = PTThermostatModeUnknown;
    if ([modeString isEqualToString:@"off"]) {
        mode = PTThermostatModeOff;
    }else if ([modeString isEqualToString:@"fan"]){
        mode = PTThermostatModeFan;
    }else if ([modeString isEqualToString:@"cool"]){
        mode = PTThermostatModeCool;
    }else if ([modeString isEqualToString:@"heat"]){
        mode = PTThermostatModeHeat;
    }
    
    _currentMode = mode;
}

- (void)refreshWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/thermostats/1.json", self.url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    request.HTTPMethod = @"GET";
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    /* This works fine, but Apple doesn't like it apparently:
     * This worked for me but note the class reference says this: "The NSURLConnection class and NSURLSession classes are designed to handle various aspects of the HTTP protocol for you. As a result, you should not modify the following headers: Authorization, Connection, Host, WWW-Authenticate"
     *
     * But I don't care.
     */
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSLog(@"Response: %@", response );
        
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog( @"Body: %@", strData );
        
        NSError *err;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        
        [self updateFromJSONData:json];
        
        if (err != nil) {
            NSLog( @"Error: %@", err );
        }else{
            NSLog( @"JSON: %@", json );
        }
        
        completionBlock([self copy], [err copy]);
    }];
    
    [task resume];
}

- (void)imHotWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/thermostats/1/im_hot", self.url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    

    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    request.HTTPMethod = @"POST";

    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSLog(@"Response: %@", response );
        
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog( @"Body: %@", strData );
        
        NSError *err;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        
        [self updateFromJSONData:json];
        
        if (err != nil) {
            NSLog( @"Error: %@", err );
        }else{
            NSLog( @"JSON: %@", json );
        }
        
        completionBlock([self copy], [err copy]);
        
    }];
    
    [task resume];
}

- (void)imColdWithCompletion:(void(^)(PiThermostat *thermostat, NSError *error))completionBlock
{
    NSString *requestURLString = [NSString stringWithFormat:@"%@/thermostats/1/im_cold", self.url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURLString]];
    
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", self.username, self.password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    request.HTTPMethod = @"POST";
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        NSLog(@"Response: %@", response );
        
        NSString *strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog( @"Body: %@", strData );
        
        NSError *err;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];

        [self updateFromJSONData:json];
        
        if (err != nil) {
            NSLog( @"Error: %@", err );
        }else{
            NSLog( @"JSON: %@", json );
        }
        
        completionBlock([self copy], [err copy]);
        
    }];
    
    [task resume];

}

#pragma mark

- (NSDictionary *)dictionaryRepresentation
{
    return @{
             
             @"name" : self.name,
             @"url" : self.url,
             @"username" : self.username,
             @"password" : self.password,
             @"currentTemperature" : [NSNumber numberWithDouble:self.currentTemperature],
             @"targetTemperature"  : [NSNumber numberWithDouble:self.targetTemperature],
             @"currentMode"        : [NSNumber numberWithInteger:self.currentMode]
             
             };
}

#pragma mark

//I HATE THIS

- (id)copyWithZone:(NSZone *)zone
{
    PiThermostat *new = [[[self class] allocWithZone:zone] initWithURL:self.url username:self.username password:self.password];
    
    new->_name = [_name copyWithZone:zone];
    new->_currentTemperature = _currentTemperature;
    new->_targetTemperature  = _targetTemperature;
    new->_currentMode  = _currentMode;
    
    return new;
}


@end

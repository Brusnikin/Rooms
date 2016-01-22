//
//  HTTPClient.m
//  Rooms
//
//  Created by Brusnikin on 21.01.16.
//  Copyright © 2016 Brusnikinapps. All rights reserved.
//

#import "HTTPClient.h"
#import "Room.h"

@interface HTTPClient ()

@property (nonatomic) NSURLSession *session;

@end

static NSString *baseURL = @"https://line.ezzi.com/api/v1/hr/hello_carl";

@implementation HTTPClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:configuration];
    }
    return self;
}

- (void)getRoomListFromServer:(void(^)(BOOL result)) success
                    onFailure:(void(^)(NSError *error)) failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:baseURL]];
    
    NSDictionary *mail = @{@"email" : @"brusnikinapps@gmail.com"};
    
    NSError *error;
    NSData *HTTPBody = [NSJSONSerialization dataWithJSONObject:mail options:0 error:&error];
    request.HTTPBody = HTTPBody;
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    [[_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data,
                                                               NSURLResponse * _Nullable response,
                                                               NSError * _Nullable error) {
        
        NSError *jsonError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!jsonError && !error) {
            
            for (NSDictionary *item in json) {
                [Room addNewRoomFromList:item];
            }
            success(YES);
        }
        
    }] resume];
}


@end

//
//  NetworkManager.m
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 27.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@end

@implementation NetworkManager

+ (NetworkManager*) sharedManager {
    
    static NetworkManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"http://api.mymemory.translated.net"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        
    }
    return self;
}

- (void) postTranslationText:(NSString*) text
                withLanguage:(NSString*) language
                   onSuccess:(void(^)(id result)) success
                   onFailure:(void(^)(NSError* error, id responseObject)) failure{
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     text,          @"q",
     language,      @"langpair",
     nil];
    
    
    [self.requestOperationManager
     POST:@"get"
     parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"JSON: %@", responseObject);
         
         if (success) {
             success(responseObject);
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         
         
         if (failure) {
             failure(error, operation.responseObject);
         }
         
     }];
}

@end

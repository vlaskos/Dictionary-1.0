//
//  NetworkManager.h
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 27.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager*) sharedManager;

- (void) postTranslationText:(NSString*) text
                    withLanguage:(NSString*) language
                    onSuccess:(void(^)(id result)) success
                    onFailure:(void(^)(NSError* error, id responseObject)) failure;

@end

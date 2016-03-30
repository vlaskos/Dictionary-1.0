//
//  AppDelegate.m
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 25.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Words.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Words"];

    
    BOOL wasLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:@"addDataToDB"];
    if (!wasLaunched) {
    
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            Words *word1 = [Words MR_createEntityInContext:localContext];
            
            word1.rootWord = @"Car";
            word1.translatedWord = @"Автомобиль";
            
            Words *word2 = [Words MR_createEntityInContext:localContext];
            
            word2.rootWord = @"Doll";
            word2.translatedWord = @"Кукла";
            
            Words *word3 = [Words MR_createEntityInContext:localContext];
            
            word3.rootWord = @"Мир";
            word3.translatedWord = @"World";
            
            Words *word4 = [Words MR_createEntityInContext:localContext];
            
            word4.rootWord = @"Мужчина";
            word4.translatedWord = @"Man";
            
            Words *word5 = [Words MR_createEntityInContext:localContext];
            
            word5.rootWord = @"People";
            word5.translatedWord = @"Люди";
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"addDataToDB"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        } completion:nil];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

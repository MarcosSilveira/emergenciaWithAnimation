//
//  DCAppDelegate.m
//  Doacoes
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCAppDelegate.h"
#import "DCLoginViewController.h"
#import "DCConfigs.h"
#import "DCMapasViewController.h"

@implementation DCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window.tintColor = [UIColor colorWithRed:(107/255.0) green:0 blue:(2/255.0) alpha:1];
    
    
    
    if(launchOptions != nil)
    {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if(userInfo != nil)
        {
            float latitude = [[userInfo objectForKey:@"lat"] floatValue];
            float longitude =[[userInfo objectForKey:@"log"]floatValue];
            MKPointAnnotation *amigo;
            amigo.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
            
            UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
//            [navController popToRootViewControllerAnimated:NO];
            
            
            DCLoginViewController *dcvc = (DCLoginViewController *)navController.viewControllers[0];
            dcvc.coordenada = CLLocationCoordinate2DMake(latitude, longitude);
        }
    }
    else
    {
        
    }
    
    
    return YES;
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    float latitude = [[userInfo objectForKey:@"lat"] floatValue];
    float longitude =[[userInfo objectForKey:@"log"]floatValue];
    MKPointAnnotation *amigo;
    amigo.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    
    
    if(application.applicationState == UIApplicationStateInactive)
    {
        UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
        [navController popToRootViewControllerAnimated:NO];
        
        
        DCLoginViewController *dcvc = (DCLoginViewController *)navController.viewControllers[0];
        dcvc.coordenada = CLLocationCoordinate2DMake(latitude, longitude);
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    
    _pushId = [[[[newDeviceToken description]
                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
                stringByReplacingOccurrencesOfString:@">" withString:@""]
               stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", _pushId);
    
    [[NSUserDefaults standardUserDefaults]setObject:_pushId forKey:@"token"];
    
    
    //chamar WS passando usuario e token
//    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
//    NSString *savedToken = [[NSUserDefaults standardUserDefaults]stringForKey:@"token"];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

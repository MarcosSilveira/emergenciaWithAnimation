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

@implementation DCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    self.window.tintColor = [UIColor colorWithRed:(107/255.0) green:0 blue:(2/255.0) alpha:1];
    
    return YES;
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
  
    NSString *pushId = [[[[newDeviceToken description]
                          stringByReplacingOccurrencesOfString:@"<" withString:@""]
                         stringByReplacingOccurrencesOfString:@">" withString:@""]
                        stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@", pushId);
    
    
    //chamar WS passando usuario e token
    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
    
    
    //Aqui deve atualizar o token ao contato
    if(savedUserName!=nil){
        DCConfigs *config=[[DCConfigs alloc] init];
        
        NSString* newStr = [[NSString alloc] initWithData:newDeviceToken
                                                  encoding:NSUTF8StringEncoding];
        
        NSString *ur = [NSString stringWithFormat:@"http://%@:8080/Emergencia/vincular.jsp?login=%@&token=%@",config.ip,savedUserName,newStr];
        NSLog(@"URL: %@",ur);
        
        
        NSURL *urs = [[NSURL alloc] initWithString:ur];
        NSData* data = [NSData dataWithContentsOfURL:urs];
        if (data != nil) {
            
            NSError *jsonParsingError = nil;
            NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            //OBjeto Array
            
            NSNumber *res = [resultado objectForKey:@"vincular"];
            NSNumber *teste=[[NSNumber alloc] initWithInt:1];
            
            
            if([res isEqualToNumber:teste]){
                NSLog(@"Cadastro ok");
            }
        }
    }
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

//
//  AppDelegate.m
//  iMoods
//
//  Created by Thibault Le Cornec on 05/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    
    /* ========== Lecture/Paramètrage des préférences de l'application ========== */
    NSUserDefaults *appSettings = [NSUserDefaults standardUserDefaults];
    NSString *deviceName = [appSettings stringForKey:@"device_name_pref"];
    NSString *serviceName = [appSettings stringForKey:@"service_name_pref"];
    NSString *servicePort = [appSettings stringForKey:@"service_port_pref"];
    
    //  Si les champs sont vident, affectation d'une valeur par défaut et enregistrement de celle-ci dans les réglages
    if (deviceName == nil || [deviceName isEqual:@""])
    {
        deviceName = [[UIDevice currentDevice] name];
        [appSettings setObject:deviceName forKey:@"device_name_pref"];
    }
    
    if (serviceName == nil || [serviceName isEqual:@""])
    {
        serviceName = @"imoods";
        [appSettings setObject:serviceName forKey:@"service_name_pref"];
    }
    
    if (servicePort == nil || [servicePort isEqual:@""])
    {
        servicePort = @"9090";
        [appSettings setObject:servicePort forKey:@"service_port_pref"];
    }
//    NSLog(@"%@", deviceName);  NSLog(@"%@", serviceName);  NSLog(@"%@", servicePort);
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    /* ========== Création vue principale ========== */
    FriendsTableViewController *friends = [[FriendsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:friends];
    [friends release];
    
    [[self window] setRootViewController:navigationController];
    [navigationController release];
    
    
    /* ========== Création vue secondaire ========== */
    MyMoodViewController *moodViewController = [[MyMoodViewController alloc] init];
    [friends setMoodViewController:moodViewController];
    [self setTheMoodView:(MyMoodView*)[moodViewController view]];
    
    /* ========== DataManager ========== */
    DataManager *dataManager = [[DataManager alloc] init];
    
    [friends setDataManager:dataManager];               //  Donne à la vue principale (UITableViewController) la référence vers le dataSource
    [[friends tableView] setDataSource:dataManager];    //  Donne à la UITableView son dataSource
    [moodViewController setDataManager:dataManager];    //  Donne à la vue secondaire la référence vers le dataSource
    
    //  Donne au DataManager la référence vers le UITableViewController
    //  (il peux ainsi accéder à sa tableView et demander des reloadData)
    [dataManager setFriends:friends];
    [dataManager release];
    
    [self.window makeKeyAndVisible];
    return YES;
}





/* ************************************************** */
/* ---------------- Gestion Affichage --------------- */
/* ************************************************** */
#pragma mark - Gestion Affichage

#pragma mark |--> Changement de statusBarFrame (UIApplicationDelegate)
// Permet de redimensionner la vue lorsque la frame de la statusBar change
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    //  Lorsque cette méthode est appellée elle donne les nouvelles dimensions de la statusBar
    //      mais si on passe en paramètre d'orientation l'orientation actuelle de l'application
    //      celle-ci ayant pas encore fait sa rotation on passe alors l' "ANCIENNE" orientation.
    //  On ne peut pas non plus passer directement la valeur de l'orientation du iDevice car
    //      car ça ne correspond pas exactement aux valeurs d'orientation de l'interface.
    //      On passe donc une valeur 1 pour l'orientation portrait et 3 pour le paysage en fonction
    //      de l'orientation du iDevice (0 ou 1 pour le portrait, 3 ou 4 pour le paysage).
    //  On peut se baser sur l'orientation du iDevice car l'appel de cette méthode se fait justement
    //      parce-que le iDevice a déjà changé d'orientation ou que la frame de la statusBar change
    //      donc l'orientation du iDevice au moment où la demande (ci-dessus) est bien la "nouvelle"
    //      orientation.
    if (([[UIDevice currentDevice] orientation] == 0) || ([[UIDevice currentDevice] orientation] == 1) || ([[UIDevice currentDevice] orientation] == 2))
    {
        [_theMoodView setViewForOrientation:1
                         withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
    else if (([[UIDevice currentDevice] orientation] == 3) || ([[UIDevice currentDevice] orientation] == 4))
    {
        [_theMoodView setViewForOrientation:3
                         withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
}





/* ************************************************** */
/* --------------- Gestion multi-tâche -------------- */
/* ************************************************** */
#pragma mark - Gestion multi-tâches

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

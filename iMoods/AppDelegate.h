//
//  AppDelegate.h
//  iMoods
//
//  Created by Thibault Le Cornec on 05/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "FriendsTableViewController.h"
#import "MyMoodViewController.h"
#import "MyMoodView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

////////// Propriétés //////////

@property (strong, nonatomic) UIWindow *window;

//  Permet au AppDelegate de référencer la vue de choix d'humeur
//  Permet au AppDelegate de faire appel à la méthode 
//      setViewForOrientation:withStatusBarFrame: de MyMoodView
@property (retain) MyMoodView *theMoodView;

@end

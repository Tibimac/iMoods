//
//  FriendsTableViewController.h
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyMoodViewController.h"
@class DataManager;

@interface FriendsTableViewController : UITableViewController <UITableViewDelegate>

////////// Propriétés //////////

//  Référence l'objet DataManager contenant les services etc..
@property (retain) DataManager *dataManager;
//  Référence le viewController de la vue de choix d'humeur
@property (retain) MyMoodViewController *moodViewController;

@end

//
//  MyMoodViewController.h
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
@class MyMoodView;

@interface MyMoodViewController : UIViewController

////////// Propriétés //////////

//  Référence l'objet DataManager contenant les services etc..
@property (retain) DataManager *dataManager;
//  Référence la vue controllée
@property (retain) MyMoodView *myMoodView;


////////// Méthodes //////////
- (void)loadService:(NSNetService*)service;
- (void)moodDidChange:(UIButton*)buttonSelected;

@end

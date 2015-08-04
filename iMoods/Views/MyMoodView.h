//
//  MyMoodView.h
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyMoodViewController;

@interface MyMoodView : UIView

////////// Propriétés //////////

@property (readonly) BOOL isiPhone;

//  Référence le viewController de cette vue
@property (retain)  MyMoodViewController *myMoodViewController;

//  Accès depuis le controlleur pour paramétrage affichage des boutons
//      selon l'humeur du service chargé
@property (readonly) UIButton *happyButton;
@property (readonly) UIButton *neutralButton;
@property (readonly) UIButton *sadButton;
@property (readonly) UIButton *angryButton;


////////// Méthodes //////////

//  Méthode pour dessiner la vue selon une orientation et en gérant la frame de la statusBar
//  Cette méthode est également appellée par FAAppDelegate lors d'un changement de frame de la statusBar
- (void)setViewForOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame;

@end

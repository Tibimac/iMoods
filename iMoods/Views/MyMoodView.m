//
//  MyMoodView.m
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "MyMoodView.h"
#import "MyMoodViewController.h"

@implementation MyMoodView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            _isiPhone = YES;;
        }
        else
        {
            _isiPhone = NO;
        }
        
        _happyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_happyButton setTag:1];
        [_happyButton setBackgroundColor:[UIColor colorWithRed:0.25 green:0.79 blue:0 alpha:1]]; // Vert
        [_happyButton setBackgroundImage:[UIImage imageNamed:@"happy"] forState:UIControlStateNormal];
        [_happyButton addTarget:_myMoodViewController action:@selector(moodDidChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_happyButton];
        [_happyButton release];
        
        _neutralButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_neutralButton setTag:2];
        [_neutralButton setBackgroundColor:[UIColor colorWithRed:0.12 green:0.74 blue:0.82 alpha:1]]; // Bleu
        [_neutralButton setBackgroundImage:[UIImage imageNamed:@"neutral"] forState:UIControlStateNormal];
        [_neutralButton addTarget:_myMoodViewController action:@selector(moodDidChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_neutralButton];
        [_neutralButton release];
        
        _sadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sadButton setTag:3];
        [_sadButton setBackgroundColor:[UIColor colorWithRed:0.957 green:0.673 blue:0.283 alpha:1]]; // Orange
        [_sadButton setBackgroundImage:[UIImage imageNamed:@"sad"] forState:UIControlStateNormal];
        [_sadButton addTarget:_myMoodViewController action:@selector(moodDidChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sadButton];
        [_sadButton release];
        
        _angryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_angryButton setTag:4];
        [_angryButton setBackgroundColor:[UIColor colorWithRed:0.75 green:0.23 blue:0.19 alpha:1]]; // Rouge
        [_angryButton setBackgroundImage:[UIImage imageNamed:@"angry"] forState:UIControlStateNormal];
        [_angryButton addTarget:_myMoodViewController action:@selector(moodDidChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_angryButton];
        [_angryButton release];
        
        [self setViewForOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                 withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
    
    return self;
}


- (void)setViewForOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame
{
    CGFloat TOP = 0.0; // Stocke le décalage lié à la barre de navigation
    
    if (UIInterfaceOrientationIsPortrait(orientation))
    {
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        TOP = 44.0;
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width)];
        
        if (_isiPhone)
        {
            TOP = 32.0;
        }
        else
        {
            TOP = 44.0;
        }
    }
    
    [_happyButton   setFrame:CGRectMake(([self bounds].size.width/2)-102.5, TOP+50,  100, 100)];
    [_neutralButton setFrame:CGRectMake(([self bounds].size.width/2)+2.5,   TOP+50,  100, 100)];
    [_sadButton     setFrame:CGRectMake(([self bounds].size.width/2)-102.5, TOP+155, 100, 100)];
    [_angryButton   setFrame:CGRectMake(([self bounds].size.width/2)+2.5,   TOP+155, 100, 100)];
}

@end

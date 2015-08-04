//
//  MyMoodViewController.m
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "MyMoodViewController.h"
#import "MyMoodView.h"

@interface MyMoodViewController ()

@end

@implementation MyMoodViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Titre pour la navigationBar
        [self setTitle:@"Mon humeur"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _myMoodView = [[MyMoodView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [_myMoodView setMyMoodViewController:self];
    
    [self setView:_myMoodView];
}


- (void)loadService:(NSNetService*)service
{
    NSString *deviceMood = [[_dataManager servicesMoods] valueForKey:[service name]];
    UIColor *colorView = nil;
    
    if ([deviceMood isEqualToString:@"happy"])
    {
        colorView = [UIColor colorWithRed:0.25 green:0.79 blue:0 alpha:1]; // Vert
        [[_myMoodView happyButton] setSelected:YES];
    }
    else if ([deviceMood isEqualToString:@"neutral"])
    {
        colorView = [UIColor colorWithRed:0.12 green:0.74 blue:0.82 alpha:1]; // Bleu
        [[_myMoodView neutralButton] setSelected:YES];
    }
    else if ([deviceMood isEqualToString:@"sad"])
    {
        colorView = [UIColor colorWithRed:0.957 green:0.673 blue:0.283 alpha:1]; // Orange
        [[_myMoodView sadButton] setSelected:YES];
    }
    else if ([deviceMood isEqualToString:@"angry"])
    {
        colorView = [UIColor colorWithRed:0.75 green:0.23 blue:0.19 alpha:1]; // Rouge
        [[_myMoodView angryButton] setSelected:YES];
    }
    
    if (colorView)
    {
        [_myMoodView setBackgroundColor:colorView];
    }
}


- (void)moodDidChange:(UIButton*)buttonSelected
{
    [_myMoodView setBackgroundColor:[buttonSelected backgroundColor]];
    
    NSString *mood = nil;
    
    switch ([buttonSelected tag])
    {
        case 1:
            mood = [NSString stringWithFormat:@"happy"];
            break;

        case 2:
            mood = [NSString stringWithFormat:@"neutral"];
            break;

        case 3:
            mood = [NSString stringWithFormat:@"sad"];
            break;

        case 4:
            mood = [NSString stringWithFormat:@"angry"];
            break;
            
        default:
            mood = nil;
            break;
    }
    
    if (mood)
    {
        NSData *moodData = [mood dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *moodDico = [NSDictionary dictionaryWithObject:moodData forKey:@"mood"];
        NSData *record = [NSNetService dataFromTXTRecordDictionary:moodDico];
        //  Récupération du service correspondant au nom du device, puis modif de son TXTRecordData
        [[[_dataManager netServices] objectAtIndex:0] setTXTRecordData:record];
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_myMoodView setViewForOrientation:toInterfaceOrientation
                    withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

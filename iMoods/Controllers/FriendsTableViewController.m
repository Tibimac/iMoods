//
//  FriendsTableViewController.m
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "DataManager.h"

@interface FriendsTableViewController ()

@end

@implementation FriendsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        // Titre pour la navigationBar
        [self setTitle:@"Tous"];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [_moodViewController loadService:[[_dataManager netServices] objectAtIndex:0]];
        [[self navigationController] pushViewController:_moodViewController animated:YES];
    }
    else
    {
        [[tableView cellForRowAtIndexPath:indexPath] setSelected:NO];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  DataManager.m
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "DataManager.h"
#import "FriendsTableViewController.h"

@implementation DataManager

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _deviceNameFromPrefs = [[NSUserDefaults standardUserDefaults] stringForKey:@"device_name_pref"];
        
        _servicesMoods      = [[NSMutableDictionary alloc] init];
        
        _netServices = [[NSMutableArray alloc] init];
        
        happyCell   = [UIImage imageNamed:@"happyCell"];
        neutralCell = [UIImage imageNamed:@"neutralCell"];
        sadCell     = [UIImage imageNamed:@"sadCell"];
        angryCell   = [UIImage imageNamed:@"angryCell"];

        
        /* ========== NetService ========== */
        //  Récupération nom du service
        NSString *serviceType = [NSString stringWithFormat:@"_%@._tcp.", [[NSUserDefaults standardUserDefaults] stringForKey:@"service_name_pref"]];
        //  Récupération du numéro de port
        int port = [[[NSUserDefaults standardUserDefaults] stringForKey:@"service_port_pref"] intValue];
        
        //  Création du service
        NSNetService *iMoodsService = [[NSNetService alloc] initWithDomain:@"local"
                                                                      type:serviceType
                                                                      name:[[NSUserDefaults standardUserDefaults] stringForKey:@"device_name_pref"]
                                                                      port:port];
        if (iMoodsService)
        {
            [iMoodsService setIncludesPeerToPeer:YES];
            [iMoodsService setDelegate:self];
            [iMoodsService publish];
        }
        else
        {
            NSLog(@"Erreur lors de l'initialisation du service.");
        }
        
        /* ========== NetServiceBrowser ========== */
        NSNetServiceBrowser *netServicesBrowser = [[NSNetServiceBrowser alloc] init];
        [netServicesBrowser setDelegate:self];
        [netServicesBrowser searchForServicesOfType:serviceType inDomain:@"local"];
    }
    
    return self;
}


- (void)getMoodOfService:(NSNetService*)netService
{
    NSString *newMood = nil;
    NSData *data = [netService TXTRecordData];
    
    if (data)
    {
        NSDictionary *dico = [NSNetService dictionaryFromTXTRecordData:data];
        
        if (dico)
        {
            NSData *dataDico = [dico objectForKey:@"mood"];
            
            if (dataDico)
            {
                newMood = [[NSString alloc] initWithData:dataDico encoding:NSUTF8StringEncoding];
                [_servicesMoods setValue:newMood forKey:[netService name]];
                
                [[_friends tableView] reloadData];
                [newMood release];
            }
        }
    }
}





/* ************************************************** */
/* -------- Méthodes de NSNetServiceDelegate -------- */
/* ************************************************** */
#pragma mark - Méthodes de NSNetServiceDelegate

#pragma mark |--> Création d'un service
- (void)netServiceWillPublish:(NSNetService *)sender
{
    NSLog(@"netServiceWillPublish");
    
    [_netServices insertObject:sender atIndex:0];       // Ajout du service au tableau des services à l'index 0 (index 0 = nous même)
    [_servicesMoods setValue:nil forKey:[sender name]]; // Ajout de l'humeur du service dans le dictionnaire (par défaut humeur à nil)
   
    [self getMoodOfService:sender];
}


- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"netServiceDidPublish");
    
    [sender startMonitoring];
    [[_friends tableView] reloadData];
}


- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"netServiceDidNotPublish");
    
    long error = (long)[[errorDict valueForKey:@"NSNetServicesErrorCode"] integerValue];
   
    NSLog(@"Error Code : %ld", error);
    
    if (error != -72000) // -72000 = erreur inconnue, inutile de l'afficher
    {
        UIAlertView *errorPublishingService;
        errorPublishingService = [[UIAlertView alloc] initWithTitle:@"Erreur de publication du service"
                                                            message:[NSString stringWithFormat:@"Erreur : %ld.\nRepublication en cours...", error]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [errorPublishingService show];
        [errorPublishingService release];
        errorPublishingService = nil;
    }
    
    [sender stopMonitoring];
    
    //  Suppression du service dans le tableau listant les services détectés
    [_netServices removeObject:sender];
    //  Suppression de l'humeur de ce service dans le dictionnaire
    [_servicesMoods removeObjectForKey:[sender name]];

    [[_friends tableView] reloadData];
    
    [sender publish];
}


#pragma mark |--> Arrêt d'un service
- (void)netServiceDidStop:(NSNetService *)sender
{
    NSLog(@"netServiceDidStop");
    
    [[sender delegate] release];
    sender.delegate = nil;
    
    [sender stopMonitoring];
    
    //  Suppression du service dans le tableau listant les services détectés
    [_netServices removeObject:sender];
    //  Suppression de l'humeur de ce service dans le dictionnaire
    [_servicesMoods removeObjectForKey:[sender name]];
    
    [[_friends tableView] reloadData];
}


#pragma mark |--> Mise à jour des données d'un service
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data
{
    [self getMoodOfService:sender];
}





/* ************************************************** */
/* ----- Méthodes de NSNetServiceBrowserDelegate ---- */
/* ************************************************** */
#pragma mark - Méthodes de NSNetServiceBrowserDelegate

#pragma mark |--> Gestion Services
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"netServiceBrowser:didFindService:moreComing:");
    NSLog(@"%@",[netService name]);
    
    //  Si le nom du service détecté n'est celui du nom du device dans les prefs de l'app
    //  Quand il s'agit de nous-même le service est déjà ajouté (voir netServiceWillPublish:)
    if ([[netService name] isEqualToString:_deviceNameFromPrefs] == NO)
    {
        [netService setDelegate:self];
        [_netServices addObject:netService];                    // Ajout du service à la fin du tableau listant les services détectés
        [_servicesMoods setValue:nil forKey:[netService name]]; // Ajout de l'humeur du service dans le dictionnaire (par défaut humeur à nil)
        [netService startMonitoring];
        
        [self getMoodOfService:netService];
    }

    if (moreServicesComing == NO)
    {
        [[_friends tableView] reloadData];
    }
}


- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing
{
    NSLog(@"netServiceBrowser:didRemoveService:moreComing:");
    NSLog(@"%@",[netService name]);
    
    [[netService delegate] release];
    netService.delegate = nil;
    
    //  Suppression du service dans le tableau listant les services détectés
    [_netServices removeObject:netService];
    //  Suppression de l'humeur de ce service dans le dictionnaire
    [_servicesMoods removeObjectForKey:[netService name]];
    
    [netService stopMonitoring];
    
    if (moreServicesComing == NO)
    {
        [[_friends tableView] reloadData];
    }
}





/* ************************************************** */
/* --------- Méthodes de UITableViewDataSource ------ */
/* ************************************************** */
#pragma mark - Méthodes de UITableViewDataSource

#pragma mark |--> Nombre de sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}


#pragma mark |--> Nombre de ligne pour la section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_netServices count];
}


#pragma mark |--> Cellule pour indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL newCell = NO;
    BOOL mineDevice = NO;
    static NSString *CellIdentifier = @"ServiceCell";
    NSUInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (row < [_netServices count])
    {
        //  Si on est à la ligne 0 et que le nom du service est égal au nom dans les préférences il s'agit du service correspondant à cet appareil
        if (row == 0 && ([[[_netServices objectAtIndex:row] name] isEqualToString:_deviceNameFromPrefs]))
        {
            mineDevice = YES;
        }
        
        if (cell == nil) // Si aucune cellule récupérée -> création d'une nouvelle
        {
            newCell = YES;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            if (mineDevice)
            {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            else
            {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        
        /* ========== Récupération Infos ========== */
        NSNetService *serviceForThisRow = [_netServices objectAtIndex:row]; // Récupération du service
        NSString *deviceName = [serviceForThisRow name];                    // Récupération du nom du service
        NSString *deviceMood = [_servicesMoods valueForKey:deviceName];      // Récupération de l'humeur (en français) associé au service (appareil)
       
        
        if (mineDevice)
        {
            NSString *tempDeviceName = [deviceName copy];
            deviceName = nil;
            deviceName = [NSString stringWithFormat:@"%@ (Moi)", tempDeviceName];
            [tempDeviceName release];
            tempDeviceName = nil;
        }
        
    
        NSString *frenchDeviceMood = nil;
        UIImage *imageForCell = nil;
        UIColor *colorCell = nil;
        
        if ([deviceMood isEqualToString:@"happy"])
        {
            frenchDeviceMood = @"Content";
            imageForCell = happyCell;
            colorCell = [UIColor colorWithRed:0.25 green:0.79 blue:0 alpha:1]; // Vert
        }
        else if ([deviceMood isEqualToString:@"neutral"])
        {
            frenchDeviceMood = @"Neutre";
            imageForCell = neutralCell;
            colorCell = [UIColor colorWithRed:0.12 green:0.74 blue:0.82 alpha:1]; // Bleu
        }
        else if ([deviceMood isEqualToString:@"sad"])
        {
            frenchDeviceMood = @"Triste";
            imageForCell = sadCell;
            colorCell = [UIColor colorWithRed:0.957 green:0.673 blue:0.283 alpha:1]; // Orange
        }
        else if ([deviceMood isEqualToString:@"angry"])
        {
            frenchDeviceMood = @"Énervé(e)";
            imageForCell = angryCell;
            colorCell = [UIColor colorWithRed:0.75 green:0.23 blue:0.19 alpha:1]; // Rouge
        }
               
        
        /* ========== Paramétrage Cellule ========== */
        [[cell textLabel] setText:deviceName];
        [[cell textLabel] setTextColor:colorCell];
        [[cell detailTextLabel] setText:frenchDeviceMood];
        
        if (imageForCell)
        {
            [[cell imageView] setImage:imageForCell];
            [[cell imageView] setBackgroundColor:colorCell];
        }
    }
    
    if (newCell)
    {
        return [cell autorelease];
    }
    else
    {
        return cell;
    }
}

@end

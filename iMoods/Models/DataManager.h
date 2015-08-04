//
//  DataManager
//  iMoods
//
//  Created by Thibault Le Cornec on 06/07/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FriendsTableViewController;

@interface DataManager : NSObject <UITableViewDataSource, NSNetServiceDelegate, NSNetServiceBrowserDelegate>
{
    UIImage *happyCell, *neutralCell, *sadCell, *angryCell;
}

////////// Propriétés //////////

@property (readonly) NSString *deviceNameFromPrefs;

//  Stockes les humeurs pour chaque service
//  Clé = nom du service | Valeur = humeur
//  Détection service = ajout au dictionnaire
//  Service interrompu = suppresion de l'objet via sa clé
@property (readonly) NSMutableDictionary *servicesMoods;

//  Stocke les services détectés et les retain
//  Accès depuis TableView pour récupérer le service
//      à charger dans la vue de choix d'humeur
@property (readonly) NSMutableArray *netServices;

//  Référence l'objet UITableViewController qui affiche la liste des amis
//  Permet au DataManager de demander un reloadData à la tableView
//      après la détection d'un nouveau service (appareil)
//      ou une mise à jour du TXTRecordDictionary d'un service (humeur d'un appareil)
@property (retain) FriendsTableViewController *friends;

@end

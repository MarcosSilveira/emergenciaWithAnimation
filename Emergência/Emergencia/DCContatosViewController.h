//
//  DCContatosViewController.h
//  Emergencia
//
//  Created by Joao Pedro da Costa Nunes on 04/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCContatosViewController : UITableViewController <UIAlertViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *contacts;

@end


//
//  DCInicialViewController.h
//  Emergencia
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCMapasViewController.h"
@interface DCInicialViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *logOutBT;
@property (weak, nonatomic) IBOutlet UIButton *contacBT;

@property NSMutableArray *listaContatos;
@property (nonatomic)CLLocationCoordinate2D coordenada;


- (IBAction)btLogOut;


@end

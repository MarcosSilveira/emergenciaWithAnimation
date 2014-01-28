//
//  DCInicialViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCInicialViewController.h"
#import "DCLoginViewController.h"

@interface DCInicialViewController ()
@property (strong,nonatomic) NSString *log;
@property (strong,nonatomic) NSString *psw;


@end

@implementation DCInicialViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
}

- (void) configuracoesIniciais {
  
  UIColor *color = self.view.tintColor;
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: color}];
  self.title = @"Inicial";
  
  //Esconde o bota de voltar
  //TODO: Verificar se o usuário está logado?
  self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)btLogOut
{
    
  // essas strings tem q ser a msm q a do login, p poder zerar elas e dar o log out
    self.log = @"";
    self.psw = @"";
}
@end

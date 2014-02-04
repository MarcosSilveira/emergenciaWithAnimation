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
    DCLoginViewController *logon;
    
    logon.login.text = nil;
    
    logon.pass.text = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:logon.login.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:logon.login.text forKey:@"password"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
@end

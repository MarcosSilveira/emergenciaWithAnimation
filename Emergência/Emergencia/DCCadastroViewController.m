//
//  DCCadastroViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCCadastroViewController.h"

@interface DCCadastroViewController ()

@end

@implementation DCCadastroViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
}

- (void) configuracoesIniciais {
  
  UIColor *color = self.view.tintColor;
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: color}];
  self.title = @"Cadastro";
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

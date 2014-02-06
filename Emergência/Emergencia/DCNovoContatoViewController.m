//
//  DCNovoContatoViewController.m
//  Emergencia
//
//  Created by Joao Pedro da Costa Nunes on 05/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCNovoContatoViewController.h"
#import "DCContatos.h"
#import "DCConfigs.h"
#import "DCContatosViewController.h"

@interface DCNovoContatoViewController ()

@property (nonatomic) DCConfigs *conf;


@end

@implementation DCNovoContatoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.conf = [[DCConfigs alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)salvarContat
{
    DCContatos *contato = [[DCContatos alloc]init];
    
    contato.nome = self.txtNome.text;
    contato.telefone = self.txtTelefone.text;
    contato.usuario = self.txtUser.text;

    if ([contato salvarComIPServidor: self.conf.ip]) {
        
        [[[UIAlertView alloc] initWithTitle:@"Sucesso" message:@"Contato adicionado com sucesso" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show ];
        
        [self.previousViewController.contacts addObject: contato];
        [self.navigationController popViewControllerAnimated:YES];
        [self.previousViewController.tableView reloadData];
    } else {
        
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível adicionar o contato. Tente novamente mais tarde." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show ];
    }
}




@end

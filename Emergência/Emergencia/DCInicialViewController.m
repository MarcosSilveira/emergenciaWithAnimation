//
//  DCInicialViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCInicialViewController.h"
#import "DCLoginViewController.h"
#import "DCReachability.h"

@interface DCInicialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLogado;


@end

@implementation DCInicialViewController

DCReachability *connectionTest;
UIAlertView *nconnection;

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
  [self testeDeConeccao];
  _userLogado.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
  
  
  
}

// verificacao se o server está online
-(void) testeDeConeccao {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
  connectionTest = [DCReachability reachabilityForInternetConnection];
  [connectionTest startNotifier];
  
  NetworkStatus remoteHostStatus = [connectionTest currentReachabilityStatus];
  if(remoteHostStatus == NotReachable) {
    
    nconnection = [[UIAlertView alloc] initWithTitle:@"Sem conexão" message:@"Não foi possível conectar aos servidores no momento. Verifique sua conexão com a internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [nconnection show];
  }
}

- (void) handleNetworkChange:(NSNotification *)notice
{
  
  NetworkStatus remoteHostStatus = [connectionTest currentReachabilityStatus];
  
  if(remoteHostStatus == NotReachable) {NSLog(@"no");}
  else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
  else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
}

- (void) configuracoesIniciais {
  
  //UIColor *color = self.view.tintColor;
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor blackColor]}];
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

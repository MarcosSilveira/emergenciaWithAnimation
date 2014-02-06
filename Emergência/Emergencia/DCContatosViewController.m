//
//  DCContatosViewController.m
//  Emergencia
//
//  Created by Joao Pedro da Costa Nunes on 04/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCContatosViewController.h"
#import "DCContatos.h"
#import "DCNovoContatoViewController.h"
#import "DCConfigs.h"


@interface DCContatosViewController ()

@property (strong, nonatomic) DCConfigs *config;
@property (strong, nonatomic) NSMutableArray *contatosAceitar;

@end

@implementation DCContatosViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
  [self listarContatos];
}

- (void) listarContatos {
  
  //URL UTILIZADA PARA CRIAR UM CONTATO NO SERVIDOR
  NSString *urlServidor = @"http://%@:8080/Emergencia/listar.jsp?idusu=%@";
  
  //ID DO USUARIO QUE ESTA LOGADO NO APP
  NSString *idUsuario = [[NSUserDefaults standardUserDefaults] stringForKey: @"id"];
  
  NSString *urlBuscarContatos = [NSString stringWithFormat: urlServidor, self.config.ip, idUsuario];
  
  NSURL *urlRequest = [[NSURL alloc] initWithString: urlBuscarContatos];
  NSData *data = [NSData dataWithContentsOfURL: urlRequest];
  
  
  //retorno
  if (data != nil) {
    
    NSError *jsonParsingError = nil;
    NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    //OBjeto Array
    
    NSArray *res = [resultado objectForKey:@"Contatos"];
    
    NSDictionary *objo;
    for (int i = 0; i < res.count; i++) {
      
      DCContatos *contato = [[DCContatos alloc] init];
      objo = [res objectAtIndex:i];
      
      contato.identificador = [[objo objectForKey:@"id"] integerValue];
      contato.identificadorAmigo = [[objo objectForKey:@"idamigo"] integerValue];
      contato.aprovado = [[objo objectForKey:@"status"] boolValue];
      contato.nome = [objo objectForKey:@"nome"];
      contato.telefone = [objo objectForKey:@"tel"];
      contato.usuario = [objo objectForKey:@"login"];
      
      [self.contacts addObject:contato];
    }
    
    NSArray *contatosAceitar = [resultado objectForKey:@"Aceitar"];
    NSDictionary *oJsonAceitar;
    for (int i = 0; i < contatosAceitar.count; i++) {
      
      DCContatos *contato = [[DCContatos alloc] init];
      oJsonAceitar = [contatosAceitar objectAtIndex:i];
      
      contato.identificador = [[oJsonAceitar objectForKey:@"id"] integerValue];
      contato.identificadorAmigo = [[oJsonAceitar objectForKey:@"idamigo"] integerValue];
      contato.aprovado = [[oJsonAceitar objectForKey:@"status"] boolValue];
      contato.nome = [oJsonAceitar objectForKey:@"nome"];
      contato.telefone = [oJsonAceitar objectForKey:@"tel"];
      
      [self.contatosAceitar addObject:contato];
    }
  }
}

- (void) configuracoesIniciais
{
  self.title = @"Contatos";
  self.contacts = [[NSMutableArray alloc]init];
  self.config = [[DCConfigs alloc] init];
  self.contatosAceitar = [[NSMutableArray alloc] init];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  
  if ([identifier isEqualToString:@"goToDetalhesContato"]) {
    
    UITableViewCell *cell = (UITableViewCell *) sender;
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
      return NO;
    }
  }
  return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if ([segue.identifier isEqualToString:@"goToDetalhesContato"]) {
    
    DCContatos *contato = (DCContatos *) [_contacts objectAtIndex:((UITableViewCell *)sender).tag];
    DCNovoContatoViewController *viewController = (DCNovoContatoViewController *) segue.destinationViewController;
    
    viewController.contato = contato;
  } else {
    
    DCNovoContatoViewController *viewController = segue.destinationViewController;
    viewController.previousViewController = self;
  }
}

-(void)viewWillAppear:(BOOL)animated {
  [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (section == 1) {
    
    if (_contacts.count == 0) {
      return 1;
    }
    return _contacts.count;
  } else {
    
    if (_contatosAceitar.count == 0) {
      return 1;
    }
    return _contatosAceitar.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier;
  
  if (indexPath.section == 1 && _contacts.count == 0) {
    CellIdentifier = @"Cell3";
  } else if (indexPath.section == 0 && _contatosAceitar.count == 0) {
    CellIdentifier = @"Cell3";
  } else if (indexPath.section == 1) {
    CellIdentifier = @"Cell";
  } else if (indexPath.section == 0) {
    CellIdentifier = @"Cell2";
  }
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  UILabel *lblContato = (UILabel *) [cell viewWithTag:10];
  lblContato.textColor = self.view.tintColor;
  
  if (indexPath.section == 1 && _contacts.count == 0) {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lblContato.text = @"Nenhum contato adicionado.";
    return cell;
  } else if (indexPath.section == 0 && _contatosAceitar.count == 0) {

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lblContato.text = @"Nenhuma aprovação pendente.";
    return cell;
  }
  
  DCContatos *contato;
  
  if (indexPath.section == 1) {
    contato = (DCContatos *)[_contacts objectAtIndex:indexPath.row];
  } else {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    contato = (DCContatos *)[_contatosAceitar objectAtIndex:indexPath.row];
  }
  
  lblContato.text = contato.nome;
  cell.tag = indexPath.row;
  
  return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  if (section == 1) {
    return @"Adicionados";
  } else {
    return @"Aguardando aprovação";
  }
}


@end

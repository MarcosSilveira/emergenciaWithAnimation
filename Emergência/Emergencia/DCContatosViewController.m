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
#import "DCAppDelegate.h"


@interface DCContatosViewController ()

@property (strong, nonatomic) DCConfigs *config;
@property (strong, nonatomic) NSMutableArray *contatosAceitar;
@property (strong, nonatomic) NSMutableArray *resultadoBusca;
@property (strong, nonatomic) NSIndexPath *indexPathContatoExcluir;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property BOOL pesquisando;

@end

@implementation DCContatosViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
  [self listarContatos];
}

//AO CLICAR NO BOTÃO DE EXCLUIR CONTATO
- (IBAction)clickExcluir:(UIButton *)sender {
  
  UIAlertView *alertViewExclusao = [[UIAlertView alloc]
                            initWithTitle:@"Excluir contato"
                            message:@"Tem certeza que desejas excluir este contato?"
                            delegate:self
                            cancelButtonTitle:@"Sim, remover"
                            otherButtonTitles: @"Não", nil];
  
	[alertViewExclusao show];
  alertViewExclusao.tag = 1500;
  
  UITableViewCell *cell = (UITableViewCell *) [[[sender superview] superview] superview];
  self.indexPathContatoExcluir = [self.tableView indexPathForCell:cell];
}

//AO ALTERAR TEXTO DA SEARCH BAR
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
  if (searchText.length > 0) {
    
    self.pesquisando = YES;
    [self pesquisar];
  } else {
    
    self.pesquisando = NO;
    [self.tableView reloadData];
  }
}

//AO CLICAR NO BOTAO DE CANCELAR A PESQUISA
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  
  self.pesquisando = NO;
  
  [self.searchBar setText:@""];
  [self.searchBar resignFirstResponder];
  [self.tableView reloadData];
}

//PESQUISA CONTATOS ATRAVEZ DA SEARCH BAR
- (void) pesquisar {

  [self.resultadoBusca removeAllObjects];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"nome CONTAINS [cd] %@", self.searchBar.text];
  self.resultadoBusca = [[self.contacts filteredArrayUsingPredicate:predicate] mutableCopy];
  
  [self.tableView reloadData];
}

//VERIFICA QUAL BOTÃO DO ALERT VIEW QUE FOI CLICADO
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (alertView.tag == 1500) {
    
    if (buttonIndex == 0) {
      [self excluirContato];
    } else {
      self.indexPathContatoExcluir = nil;
    }
  }
}

//EXCLUI UM CONTATO
- (void) excluirContato {
  
  if (self.indexPathContatoExcluir != nil) {
    
    DCContatos *contato;
    if (!self.pesquisando) {
      contato = (DCContatos *) [self.contacts objectAtIndex: self.indexPathContatoExcluir.row];
    } else {
      
      contato = (DCContatos *) [self.resultadoBusca objectAtIndex: self.indexPathContatoExcluir.row];
      [self.resultadoBusca removeObject:contato];
    }
    [self.contacts removeObject:contato];
    
    [self.tableView beginUpdates];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathContatoExcluir] withRowAnimation:UITableViewRowAnimationFade];
    if ((!self.pesquisando && self.contacts.count == 0) || (self.pesquisando && self.resultadoBusca.count == 0)) {
      [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathContatoExcluir] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
    
    //DELETA O CONTATO NO SERVIDOR
    NSString *urlServidor = @"http://%@:8080/Emergencia/rejeitar.jsp?id=%d";
    NSString *urlAceitarContato = [NSString stringWithFormat: urlServidor, self.config.ip, contato.identificador];
    
    NSURL *urlRequest = [[NSURL alloc] initWithString: urlAceitarContato];
    NSData *data = [NSData dataWithContentsOfURL: urlRequest];
    
    if (data != nil) {
      
      NSError *jsonParsingError = nil;
      NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
      
      NSNumber *res = [resultado objectForKey:@"rejeitar"];
      NSNumber *testeExcluir = [[NSNumber alloc] initWithInt:0];
      
      if ([res isEqualToNumber:testeExcluir]) {
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível excluir o contato. Tente novamente mais tarde." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show ];
      }
    }
  }
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
      contato.aprovado = [[objo objectForKey:@"status"] integerValue];
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
      contato.aprovado = [[oJsonAceitar objectForKey:@"status"] integerValue];
      contato.nome = [oJsonAceitar objectForKey:@"nome"];
      contato.telefone = [oJsonAceitar objectForKey:@"tel"];
      contato.usuario = [oJsonAceitar objectForKey:@"login"];
      
      [self.contatosAceitar addObject:contato];
    }
  }
}

//AO ALTERAR VALOR DO SWITCH QUE APROVA CONTATOS
- (IBAction)onChangeSwitch:(UISwitch *)sender {
  
  UITableViewCell *cell = (UITableViewCell *) [[[sender superview] superview] superview];
  
  if (sender.on) {
    
    BOOL aceitou = NO;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DCContatos *contato = [self.contatosAceitar objectAtIndex:indexPath.row];
    NSString *urlServidor = @"http://%@:8080/Emergencia/aceitar.jsp?id=%d";
    NSString *urlAceitarContato = [NSString stringWithFormat: urlServidor, self.config.ip, contato.identificador];
    
    NSURL *urlRequest = [[NSURL alloc] initWithString: urlAceitarContato];
    NSData *data = [NSData dataWithContentsOfURL: urlRequest];
    
    if (data != nil) {
      
      NSError *jsonParsingError = nil;
      NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
      
      NSNumber *res = [resultado objectForKey:@"Aceitar"];
      NSNumber *testeAceitar = [[NSNumber alloc] initWithInt:0];
      
      if (![res isEqualToNumber:testeAceitar]) {
        aceitou = YES;
      }
    }
    
    if (aceitou) {
      
      [self.contatosAceitar removeObject:contato];
      
      [self.tableView beginUpdates];
      if (self.contatosAceitar.count == 0) {
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      } else {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      }
      
      [self.tableView endUpdates];
    } else {
      [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível aceitar o contato. Tente novamente mais tarde." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show ];
    }
  }
}

//CONFIGURAÇÕES INICIAIS DA TELA
- (void) configuracoesIniciais
{
  self.title = @"Contatos";
  self.contacts = [[NSMutableArray alloc]init];
  self.config = [[DCConfigs alloc] init];
  self.contatosAceitar = [[NSMutableArray alloc] init];
  self.resultadoBusca = [[NSMutableArray alloc] init];
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
    
    DCContatos *contato;
    
    //VERIFICA SE ESTA PESQUISANDO CONTATOS
    if (!self.pesquisando) {
      contato = (DCContatos *) [_contacts objectAtIndex:((UITableViewCell *)sender).tag];
    } else {
      contato = (DCContatos *) [_resultadoBusca objectAtIndex:((UITableViewCell *)sender).tag];
    }
    DCNovoContatoViewController *viewController = (DCNovoContatoViewController *) segue.destinationViewController;
    
    viewController.contato = contato;
  } else {
    
    DCNovoContatoViewController *viewController = segue.destinationViewController;
    viewController.previousViewController = self;
  }
}

-(void)viewWillAppear:(BOOL)animated {
  
  //CADA VEZ QUE APARECER A VIEW, RECARREGA OS DADOS DA TABLE VIEW
  [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UILabel *lblContato = (UILabel *) [cell viewWithTag:10];
  UIColor *color = [UIColor colorWithRed:(107/255.0) green:0 blue:(2/255.0) alpha:1];
  [lblContato setTextColor: color];
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
    
    if (_contacts.count == 0 && !self.pesquisando) {
      return 1;
    } else if (_resultadoBusca.count == 0 && self.pesquisando) {
      return 1;
    }
    return self.pesquisando ? _resultadoBusca.count : _contacts.count;
  } else {
    
    if (_contatosAceitar.count == 0) {
      return 1;
    }
    return _contatosAceitar.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier;
  
  if ((indexPath.section == 1 && _contacts.count == 0 && !self.pesquisando) ||
      (indexPath.section == 0 && _contatosAceitar.count == 0) ||
      (indexPath.section == 1 && _resultadoBusca.count == 0 && self.pesquisando)) {
    
    CellIdentifier = @"Cell3";
  } else if (indexPath.section == 1) {
    CellIdentifier = @"Cell";
  } else if (indexPath.section == 0) {
    CellIdentifier = @"Cell2";
  }
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  UILabel *lblContato = (UILabel *) [cell viewWithTag:10];
  
  if (indexPath.section == 1 && _contacts.count == 0 && !self.pesquisando) {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lblContato.text = @"Nenhum contato adicionado.";
    return cell;
  } else if (indexPath.section == 0 && _contatosAceitar.count == 0) {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lblContato.text = @"Nenhuma aprovação pendente.";
    return cell;
  } else if (indexPath.section == 1 && _resultadoBusca.count == 0 && self.pesquisando) {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lblContato.text = @"Nenhum contato encontrado.";
    return cell;
  }
  
  DCContatos *contato;
  
  if (indexPath.section == 1) {
    
    if (!self.pesquisando) {
      contato = (DCContatos *)[_contacts objectAtIndex:indexPath.row];
    } else {
      contato = (DCContatos *)[_resultadoBusca objectAtIndex:indexPath.row];
    }
    
    NSString *texto = contato.nome;
    if (contato.aprovado == 1) {
      texto = [NSString stringWithFormat:@"%@ - Em aprovação", texto];
    }
    lblContato.text = texto;
  } else {
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    contato = (DCContatos *)[_contatosAceitar objectAtIndex:indexPath.row];
    lblContato.text = contato.usuario;
  }
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

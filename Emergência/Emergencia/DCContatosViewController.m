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
        //NSArray *res = [resultado objectForKey:@"Aceitar"];
        
        NSDictionary *objo;
        for (int i = 0; i < res.count; i++) {
            
            DCContatos *contato = [[DCContatos alloc] init];
            objo = [res objectAtIndex:i];
            
            contato.identificador = [[objo objectForKey:@"idcontatos"] integerValue];
            contato.identificadorAmigo = [[objo objectForKey:@"idamigo"] integerValue];
            contato.aprovado = [[objo objectForKey:@"status"] boolValue];
            contato.nome = [objo objectForKey:@"nome"];
            contato.telefone = [objo objectForKey:@"telefone"];
            
            [self.contacts addObject:contato];
        }
    }
}

- (void) configuracoesIniciais
{
    self.title = @"Contatos";
    self.contacts = [[NSMutableArray alloc]init];
    self.config = [[DCConfigs alloc] init];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return _contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *lblContato = (UILabel *) [cell viewWithTag:10];
    lblContato.text = ((DCContatos *)[_contacts objectAtIndex:indexPath.row]).nome;
    cell.tag = ((DCContatos *)[_contacts objectAtIndex:indexPath.row]).identificador;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DCNovoContatoViewController *viewController = segue.destinationViewController;
    viewController.previousViewController = self;
}



/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */




@end

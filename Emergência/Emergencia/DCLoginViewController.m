//
//  DCViewController.m
//  Doacoes
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCLoginViewController.h"
#import "DCConfigs.h"
#import "DCInicialViewController.h"
#import "DCInicialViewController.h"
#import "DCAppDelegate.h"
@interface DCLoginViewController ()



@property (nonatomic) DCConfigs *conf;

@end

@implementation DCLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    //    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
    //    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    //
    
    [self configuracoesIniciais];
    
    //    if(savedUserName != nil && savedPassword != nil) {
    //        [self performSegueWithIdentifier:@"goToInicio" sender:self];
    //    }
    
    // NAO PODE TER BACK BUTTON
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
    NSString *savedPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    
    if(savedUserName != nil && savedPassword != nil) {
        [self performSegueWithIdentifier:@"goToInicio" sender:self];
        
    }
    
  
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionRepeat animations:^{
       _cruzImage.alpha = 0;
   } completion:^(BOOL finished) {
       _cruzImage.alpha = 1;
   }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToInicio"]) {
        DCInicialViewController *inicial = (DCInicialViewController *)segue.destinationViewController;
        inicial.coordenada = _coordenada;
    }
}
- (void) configuracoesIniciais
{
    
    //UIColor *color = self.view.tintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName:[UIColor blackColor] }];
    
    self.title = @"Login";
    self.conf=[[DCConfigs alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)logar:(UIButton *)sender {
    
    if ([self loginUsuarioComUsuario: self.login.text comSenha:self.pass.text]) {
        [self performSegueWithIdentifier:@"goToInicio" sender:sender];
    } else {
        //self.oks.text=@"Erro no login";
        [[[UIAlertView alloc] initWithTitle:@"erro" message:@"Login não efetuado" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show ];
    }
    
}

-(BOOL) loginUsuarioComUsuario:(NSString *)usuario
                      comSenha:(NSString *)senha {
    
    NSString *ur=[NSString stringWithFormat:@"http://%@:8080/Emergencia/login.jsp?login=%@&senha=%@",self.conf.ip,usuario,senha];
    DCAppDelegate *tokn;
    
    ur=[ur stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *urs=[[NSURL alloc] initWithString:ur];
    NSData* data = [NSData dataWithContentsOfURL:
                    urs];
    
    //retorno
    if(data!=nil){
        
        NSError *jsonParsingError = nil;
        NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        
        NSNumber *res=[resultado objectForKey:@"login"];
        
        NSNumber *teste=[[NSNumber alloc] initWithInt:0];
        
        //confere
        if(![res isEqualToNumber:teste]){
            
            
            //Checagem de preferencias, saber se já ta logado
            
            NSUserDefaults *prefer = [NSUserDefaults standardUserDefaults];
            
            [prefer setObject:self.login.text forKey:@"username"];
            [prefer setObject:self.pass.text forKey:@"password"];
            [prefer setObject:res forKey:@"id"];
            [prefer setObject:tokn.pushId forKey:@"token"];
            //Salvar o conteudo de res
            
            [prefer synchronize];
            
            return YES;
            
        }
        
        else
        {
            
            
            return NO;
        }
        
    }else{
        //self.oks.text=@"Erro no login";
        [[[UIAlertView alloc] initWithTitle:@"erro" message:@"Login não efetuado" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show ];
        
        return NO;
    }
    
}


@end

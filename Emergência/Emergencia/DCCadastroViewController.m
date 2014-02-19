//
//  DCCadastroViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCCadastroViewController.h"
#import "DCConfigs.h"
#import "TLAlertView.h"

@interface DCCadastroViewController ()
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *senha;
@property (weak, nonatomic) IBOutlet UITextField *csenha;

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

@property (nonatomic) DCConfigs *conf;

@end

@implementation DCCadastroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configuracoesIniciais];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) configuracoesIniciais {
    
    //UIColor *color = self.view.tintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.title = @"Cadastro";
    self.conf=[[DCConfigs alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)runAnimations:(NSInteger) ID{
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collision];
    
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        _login.frame = CGRectMake(300, 300, 500, 500);
        _senha.frame = CGRectMake(300, 300, 500, 500);
        _csenha.frame = CGRectMake(300, 300, 500, 500);
        _email.frame = CGRectMake(300, 300, 500, 500);
        _login.transform = CGAffineTransformMakeRotation((90*M_1_PI));
        _senha.transform = CGAffineTransformMakeRotation((90*M_1_PI));
        _csenha.transform = CGAffineTransformMakeRotation((90*M_1_PI));
        _email.transform = CGAffineTransformMakeRotation((90*M_1_PI));
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [_collision addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(10, 565) toPoint:CGPointMake(300, 565)];
    
    //chama a segue depois de 3 segundos da inicialização do método
    NSTimer * timer = [[NSTimer alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(vaipratela)
                                           userInfo:nil
                                            repeats:NO];
}
-(void)vaipratela
{
    [self performSegueWithIdentifier:@"cadtoInicial" sender:nil];
}

- (IBAction)cadastrar:(UIButton *)sender {
    
    if(![self.senha.text isEqual:@""]||![self.login.text isEqual:@""]){
    //Verifica senhas
    if([self.senha.text isEqual:self.csenha.text]){
        
        //JSON
        NSString *ur=[NSString stringWithFormat:@"http://%@:8080/Emergencia/cadastro.jsp?login=%@&senha=%@&email=%@",self.conf.ip,self.login.text,self.senha.text,self.email.text];
        
        ur=[ur stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *urs=[[NSURL alloc] initWithString:ur];
        NSData* data = [NSData dataWithContentsOfURL:
                        urs];
        
        //Retorno
        if(data!=nil){
            
            NSError *jsonParsingError = nil;
            NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            
            NSNumber *res=[resultado objectForKey:@"cadastro"];
            
            NSNumber *teste=[[NSNumber alloc] initWithInt:1];
            
            
            if([res isEqualToNumber:teste]){
                //OK
                TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Cadastro" message:@"Cadastro efetuado com sucesso" buttonTitle:@"OK"];
                [alertView show];
                
                [self performSegueWithIdentifier:@"cadtoInicial" sender:sender];
            }else{
                //ERRO
                TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Erro" message:@"Cadastro não efetuado" buttonTitle:@"OK"];
                [alertView show];
               
            }
            
        }else{
            //ERRO
            TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Erro" message:@"Cadastro não efetuado" buttonTitle:@"OK"];
            [alertView show];
        }
        
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Senha não confere" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show ];
    }
    
    }else{
        TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Erro" message:@"Digite nos campos" buttonTitle:@"OK"];
        [alertView show];
    }
    
}

@end

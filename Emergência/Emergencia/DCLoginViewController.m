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
@property (nonatomic, readwrite) CGRect bt1Bound;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;

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
-(void)runAnimations:(NSInteger) ID{
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _gravity = [[UIGravityBehavior alloc]initWithItems:@[_login, _pass]];
    _collision = [[UICollisionBehavior alloc]initWithItems:@[_login, _pass]];
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_collision];
    
    [UIView animateWithDuration:2.0 delay:1.0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        _cruzImage.frame = CGRectMake(10, 10, 10, 10);
        _logLBL.frame = CGRectMake(300, 300, 500, 500);
        _passLBL.frame = CGRectMake(300, 300, 500, 500);
        _logLBL.transform = CGAffineTransformMakeRotation((90*M_1_PI));
        _passLBL.transform = CGAffineTransformMakeRotation((90*M_1_PI));
        _signBT.transform = CGAffineTransformMakeRotation((180*M_1_PI));
        _emergBT.transform = CGAffineTransformMakeRotation((180*M_1_PI));
        _logBT.transform = CGAffineTransformMakeRotation((180*M_1_PI));
        
    } completion:^(BOOL finished) {
        _cruzImage.alpha = 0;
        
    }];
    
    
    [_collision addBoundaryWithIdentifier:@"line" fromPoint:CGPointMake(10, 565) toPoint:CGPointMake(300, 565)];
    
    //chama a segue depois de 3 segundos da inicialização do método
    NSTimer * timer = [[NSTimer alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                             target:self
                                           selector:@selector(vaipratela)
                                           userInfo:nil
                                            repeats:NO];
}
-(void)vaipratela{
    [self performSegueWithIdentifier:@"goToInicio" sender:nil];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToInicio"]) {
        DCInicialViewController *inicial = (DCInicialViewController *)segue.destinationViewController;
        inicial.coordenada = _coordenada;
    }
}
- (void) configuracoesIniciais
{
    
    
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
        [self runAnimations:0];
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

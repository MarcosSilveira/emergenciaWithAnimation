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
#import "TLAlertView.h"

@interface DCNovoContatoViewController ()

@property(nonatomic,strong) UIDynamicAnimator *animator;
@property (nonatomic,strong) UIDynamicAnimator *animator2;
@property (nonatomic,strong) UIDynamicAnimator *animator3;
@property(nonatomic,strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property(nonatomic,strong) UIGravityBehavior *gravity2;
@property (nonatomic, strong) UIPushBehavior *pushBehavior2;
@property(nonatomic,strong) UIGravityBehavior *gravity3;
@property (nonatomic, strong) UIPushBehavior *pushBehavior3;
@property (nonatomic) DCConfigs *conf;
@property (weak, nonatomic) IBOutlet UITextField *TFNome;
@property (weak, nonatomic) IBOutlet UILabel *LBNome;
@property (weak, nonatomic) IBOutlet UITextField *TFFone;
@property (weak, nonatomic) IBOutlet UILabel *LBFone;
@property (weak, nonatomic) IBOutlet UITextField *TFUser;
@property (weak, nonatomic) IBOutlet UILabel *LBUser;


@end

@implementation DCNovoContatoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.conf = [[DCConfigs alloc] init];
    if (self.contato != nil) {
        
        self.txtNome.text = self.contato.nome;
        self.txtTelefone.text = self.contato.telefone;
        self.txtUser.text = self.contato.usuario;
        
        self.txtUser.enabled = NO;
        
    }
    
}

-(void)runAnimation:(NSInteger) ID{
    if(ID==0){
        
        
    _animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    _animator2 = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _animator3 = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[_TFNome, _LBNome]];
    _gravity.magnitude = 0.7;
    _gravity2 = [[UIGravityBehavior alloc] initWithItems:@[_TFUser, _LBUser]];
    _gravity2.magnitude = 1.3;
    _gravity3 = [[UIGravityBehavior alloc] initWithItems:@[_TFFone, _LBFone]];
    
    _pushBehavior2 = [[UIPushBehavior alloc] initWithItems:@[_TFUser, _LBUser]mode:UIPushBehaviorModeContinuous];
    _pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_TFNome, _LBNome]mode:
                     UIPushBehaviorModeContinuous];
    _pushBehavior3 = [[UIPushBehavior alloc] initWithItems:@[_TFFone, _LBFone] mode:UIPushBehaviorModeContinuous];
  
    [_animator3 addBehavior:_gravity3];
    [_animator3 addBehavior:_pushBehavior3];
    [_animator2 addBehavior:_gravity2];
    [_animator2 addBehavior:_pushBehavior2];
    [_animator addBehavior:_pushBehavior];
    [_animator addBehavior:_gravity];
    }
    else{
        _TFNome.center = CGPointMake(200, 300);
        _TFNome.center = CGPointMake(200, 350);
        
        
        
    }

    
}

//LIMITA O TAMANHO DO TEXTFIELD
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if (![textField isEqual:self.txtTelefone]) {
    return YES;
  }
  
  if (range.location > 13) {
    return NO;
  }
  
  return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_txtNome resignFirstResponder];
    [_txtTelefone resignFirstResponder];
    [_txtUser resignFirstResponder];
    
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveContat2:(id)sender {
    [self runAnimation:0];
    NSTimer * timer = [[NSTimer alloc] init];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(salvarContat)
                                           userInfo:nil
                                            repeats:NO];
    
}



- (IBAction)salvarContat {
    
    DCContatos *contato;
    
    
    if(![self.txtUser.text isEqual:@""]||![self.txtNome.text isEqual:@""]){
    
    //ADICIONA UM CONTATO NOVO
    if (self.contato == nil) {
        
        contato = [[DCContatos alloc]init];
        
        contato.nome = self.txtNome.text;
        contato.telefone = self.txtTelefone.text;
        contato.usuario = self.txtUser.text;
        
        if ([contato salvarComIPServidor: self.conf.ip]) {
            
            TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Sucesso" message:@"Contato adicionado com sucesso" buttonTitle:@"OK"];
            [alertView show];
            
            [self.previousViewController.contacts addObject: contato];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Falha" message:@"Não foi possível adicionar o contato" buttonTitle:@"OK"];
            [alertView show];
        }
    } else { //EDITA UM CONTATO JA EXISTENTE
        
        contato = self.contato;
        contato.nome = self.txtNome.text;
        contato.telefone = self.txtTelefone.text;
        
        if ([contato editarComIPServidor: self.conf.ip]) {
            
            TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Sucesso" message:@"Contato editado com sucesso" buttonTitle:@"OK"];
            [alertView show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            
            TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Erro" message:@"Não foi possível editar o contato" buttonTitle:@"OK"];
            [alertView show];
        }
    }
    }else{
        TLAlertView *alertView = [[TLAlertView alloc] initWithTitle:@"Erro" message:@"Digite nos campos" buttonTitle:@"OK"];
        [alertView show];
    }
}

@end

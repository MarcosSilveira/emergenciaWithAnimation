//
//  DCNovoContatoViewController.h
//  Emergencia
//
//  Created by Joao Pedro da Costa Nunes on 05/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCContatosViewController.h"
#import "DCContatos.h"

@interface DCNovoContatoViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtUser;
@property (weak, nonatomic) IBOutlet UITextField *txtTelefone;
@property (weak, nonatomic) IBOutlet UITextField *txtNome;

@property (strong, nonatomic) DCContatosViewController *previousViewController;
@property (strong, nonatomic) DCContatos *contato;

- (IBAction)salvarContat;


@end

//
//  DCContatos.m
//  Emergencia
//
//  Created by Joao Pedro da Costa Nunes on 04/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCContatos.h"

@implementation DCContatos


- (instancetype)initComNome:(NSString *) nome
              ComPrioridade:(NSString *) telefone
                 ComUsuario:(NSString *) user
{
    self = [super init];
    
    if (self)
    {
        self.nome     = nome;
        self.telefone = telefone;
        self.usuario  = user;
        self.aprovado = NO;
    }
    return self;
}




@end

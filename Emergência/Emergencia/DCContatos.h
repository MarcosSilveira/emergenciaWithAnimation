//
//  DCContatos.h
//  Emergencia
//
//  Created by Joao Pedro da Costa Nunes on 04/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCContatos : NSObject

@property (strong, nonatomic) NSString *nome;
@property (strong, nonatomic) NSString *telefone;
@property (strong, nonatomic) NSString *usuario;

@property BOOL aprovado;

@end

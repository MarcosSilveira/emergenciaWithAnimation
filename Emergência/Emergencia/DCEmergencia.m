//
//  DCEmergencia.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 27/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCEmergencia.h"

@implementation DCEmergencia

/**
 * Inicializa um objeto DCEmergencia com o nome e prioridade passados por parâmetro, respectivamente.
 */
- (instancetype)initComNome:(NSString *) nome
              ComPrioridade:(NSInteger) prioridade {
  
  self = [super init];
  if (self) {
    
    self.nome       = nome;
    self.prioridade = prioridade;
  }
  return self;
}

@end
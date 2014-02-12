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
        self.aprovado = 1;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
      self.aprovado = 1;
    }
    return self;
}

-(BOOL)salvarComIPServidor: (NSString *) ipServidor
{
    //URL UTILIZADA PARA CRIAR UM CONTATO NO SERVIDOR
    NSString *urlServidor = @"http://%@:8080/Emergencia/adicionarContato.jsp?idusu=%@&amigo=%@&nome=%@&tel=%@";
    
    //ID DO USUARIO QUE ESTA LOGADO NO APP
    NSString *idUsuario = [[NSUserDefaults standardUserDefaults] stringForKey: @"id"];
    
    NSString *urlAdicionarContato = [NSString stringWithFormat: urlServidor, ipServidor, idUsuario, self.usuario, self.nome, self.telefone];
    
    urlAdicionarContato=[urlAdicionarContato stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *urlRequest = [[NSURL alloc] initWithString: urlAdicionarContato];
    NSData *data = [NSData dataWithContentsOfURL: urlRequest];
    
    if (data != nil) {
        
        NSError *jsonParsingError = nil;
        NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        NSNumber *idUsuario = [resultado objectForKey:@"adicionar"];
        NSNumber *testeUsuario = [[NSNumber alloc] initWithInt:0];
        
        if ([idUsuario isEqualToNumber:testeUsuario]) {
            return NO;
        }
        
        self.identificador = [idUsuario integerValue];
        return YES;
    }
    
    return NO;
}


-(BOOL) editarComIPServidor: (NSString *) ipServidor {
  
  //URL UTILIZADA PARA EDITAR UM CONTATO NO SERVIDOR
  NSString *urlServidor = @"http://%@:8080/Emergencia/editar.jsp?id=%d&nome=%@&tel=%@";
  
  NSString *urlEditarContato = [NSString stringWithFormat: urlServidor, ipServidor, self.identificador, self.nome, self.telefone];
  
  NSURL *urlRequest = [[NSURL alloc] initWithString: urlEditarContato];
  NSData *data = [NSData dataWithContentsOfURL: urlRequest];
  
  if (data != nil) {
    
    NSError *jsonParsingError = nil;
    NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    NSNumber *idUsuario = [resultado objectForKey:@"editar"];
    NSNumber *testeUsuario = [[NSNumber alloc] initWithInt:0];
    
    if ([idUsuario isEqualToNumber:testeUsuario]) {
      return NO;
    }
    return YES;
  }
  
  return NO;
}

@end

//
//  DCEmergenciaViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 24/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCEmergenciaViewController.h"
#import "DCMapasViewController.h"
#import "DCEmergencia.h"
#import "DCMapasViewController.h"
#import "DCBoundsDetail.h"


@interface DCEmergenciaViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtRaio;
@property (strong, nonatomic) NSMutableArray *emergencias;
@property (weak, nonatomic) IBOutlet UIPickerView *pickers;
@property (weak, nonatomic) IBOutlet UIButton *solicitar;

@property (nonatomic, readwrite) CGRect button1Bounds;
@property (nonatomic, strong) UIDynamicAnimator *animator;


@end

@implementation DCEmergenciaViewController


CLLocationManager *gerenciadorLocalizacao;
float lat;
float longi;

- (void)viewDidLoad
{
  [super viewDidLoad];
    gerenciadorLocalizacao = [[CLLocationManager alloc] init];
    gerenciadorLocalizacao.delegate = self;
    
    
  [gerenciadorLocalizacao startUpdatingLocation];
  [self configuracoesIniciais];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];

    _configs = [[DCConfigs alloc] init];
    
    self.button1Bounds = self.solicitar.bounds;
    
    // Force the button image to scale with its bounds.
    self.solicitar.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.solicitar.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    lat = newLocation.coordinate.latitude;
    longi = newLocation.coordinate.longitude;
    
    
}





-(void)dismissKeyboard {
  [self.txtRaio resignFirstResponder];
}

- (void) configuracoesIniciais {
  
 // UIColor *color = self.view.tintColor;
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor blackColor]}];
  self.title = @"Emergência";
  
  [self configurarEmergencias];
    if(self.coordenada.latitude!=0 && self.coordenada.longitude !=0)
        [self performSegueWithIdentifier:@"goToMapas" sender:self];

}



- (void) configurarEmergencias {
  
  self.emergencias = [[NSMutableArray alloc] init];
  
  DCEmergencia *emergencia = [[DCEmergencia alloc] initComNome:@"Respiratório" ComPrioridade:1];
  [self.emergencias addObject:emergencia];
  
  emergencia = [[DCEmergencia alloc] initComNome:@"Cardíaco" ComPrioridade:2];
  [self.emergencias addObject:emergencia];
  
  emergencia = [[DCEmergencia alloc] initComNome:@"Neurológico" ComPrioridade:3];
  [self.emergencias addObject:emergencia];
  
  emergencia = [[DCEmergencia alloc] initComNome:@"Muscular" ComPrioridade:4];
  [self.emergencias addObject:emergencia];
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
  
  //VERIFICA SE CONTEM ALGUM CARACTER QUE NAO SEJA NUMERO OU O CARACTER '.'
  NSError *error = NULL;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([^0-9\\.])" options:NSRegularExpressionCaseInsensitive error:&error];
  
  NSUInteger numberOfMatches = [regex numberOfMatchesInString: self.txtRaio.text
                                                      options:0
                                                        range:NSMakeRange(0, [self.txtRaio.text length])];
  
  if (numberOfMatches > 0) {
    
    [[[UIAlertView alloc] initWithTitle:@"Erro" message:@"Valor do raio incompatível" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
    return NO;
  }
  return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  DCMapasViewController *viewController = (DCMapasViewController *) segue.destinationViewController;
  
  float raio = [self.txtRaio.text floatValue];
  [viewController setRaio: raio];
   
    if ([segue.identifier isEqualToString:@"goToMapas"]) {
        DCMapasViewController  *mapas = (DCMapasViewController *)segue.destinationViewController;
        mapas.coordenada = _coordenada;
    }
    
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return _emergencias.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  
  return ((DCEmergencia *) [self.emergencias objectAtIndex:row]).nome;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
  label.textColor = self.view.tintColor;
  label.textAlignment = NSTextAlignmentCenter;
  label.text = ((DCEmergencia *) [self.emergencias objectAtIndex:row]).nome;
  return label;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)Solicitar:(id)sender {
    
    self.solicitar.bounds = self.button1Bounds;
    
    // UIDynamicAnimator instances are relatively cheap to create.
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // APLPositionToBoundsMapping maps the center of an id<ResizableDynamicItem>
    // (UIDynamicItem with mutable bounds) to its bounds.  As dynamics modifies
    // the center.x, the changes are forwarded to the bounds.size.width.
    // Similarly, as dynamics modifies the center.y, the changes are forwarded
    // to bounds.size.height.
    
    DCBoundsDetail *buttonBoundsDynamicItem = [[DCBoundsDetail alloc] initWithTarget:sender];
    
    // Create an attachment between the buttonBoundsDynamicItem and the initial
    // value of the button's bounds.
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:buttonBoundsDynamicItem attachedToAnchor:buttonBoundsDynamicItem.center];
    
     [attachmentBehavior setFrequency:2.0];
     [attachmentBehavior setDamping:0.3];
     [animator addBehavior:attachmentBehavior];
     
     UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[buttonBoundsDynamicItem] mode:UIPushBehaviorModeInstantaneous];
     pushBehavior.angle = M_PI_4;
     pushBehavior.magnitude = 2.0;
     [animator addBehavior:pushBehavior];
     
     [pushBehavior setActive:TRUE];
     
     self.animator = animator;
    
    
    //Fim da animacao
    
     NSString *savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
    NSLog(@"Solocitando");
    
    //self.pickers
    
    //Montar a mensagem
    NSString *msm=[[NSString alloc]init];
    
    
    
    NSInteger sele=[self.pickers selectedRowInComponent:self.pickers.tag];
    
    DCEmergencia *emer=self.emergencias[sele];
    
    msm=[msm stringByAppendingFormat:@"o usuario:%@ está solicitando sua ajuda, com uma ermergência: %@",savedUserName,emer.nome];
    
    //NSLog(@"%@",msm);
   
    
    //NSString *ur = [NSString stringWithFormat:@"http://%@:8080/Emergencia/alertar.jsp?mensagem=%@&idusu=%@&lat=%@&log=%@",self.configs.ip,@"testando o push",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
    
    //COlocar a posiçao atual
    NSString *ur = [NSString stringWithFormat:@"http://%@:8080/Emergencia/alertar.jsp?mensagem=%@&idusu=%@&lat=%f&log=%f",self.configs.ip,msm,savedUserName,lat,longi];
    NSLog(@"%@",[ur stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSURL *urs = [[NSURL alloc] initWithString:[ur stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    NSData* data = [NSData dataWithContentsOfURL:urs];
    
    
    //retorno
    if(data!=nil){
        
        NSLog(@"Aqui");
        
        NSError *jsonParsingError = nil;
        NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
        
        
        NSNumber *res=[resultado objectForKey:@"enviado"];
        
        NSNumber *teste=[[NSNumber alloc] initWithInt:0];
        
        //confere
        if(![res isEqualToNumber:teste]){
            //Colocar Alert
            [[[UIAlertView alloc] initWithTitle:@"Enviado" message:@"Mensagens enviadas para seus contatos" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil] show ];
        }
    }
    
    
    
}



@end
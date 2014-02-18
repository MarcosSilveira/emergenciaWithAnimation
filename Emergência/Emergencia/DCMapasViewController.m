//
//  DCMapasViewController.m
//  Emergencia
//
//  Created by Marcos Sokolowski on 29/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
// Teste - Marcos

#import "DCMapasViewController.h"
#import "DCConfigs.h"
#import "DCPosto.h"

@interface DCMapasViewController ()

@property (nonatomic) DCConfigs *conf;

@end

@implementation DCMapasViewController{
  
  CLLocationManager *gerenciadorLocalizacao;
  MKPointAnnotation *ondeEstouAnotacao;
  MKPointAnnotation *pontoaux;
    MFMessageComposeViewController *mensagem;
    CLAuthorizationStatus *teste;
    MKPointAnnotation *amigo;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [gerenciadorLocalizacao startUpdatingLocation];
  [self OndeEstouAction:NULL];
  self.conf=[[DCConfigs alloc] init];
  pontoaux = [[MKPointAnnotation alloc] init];
  
  if (self.raio == 0) {
    self.raio = 1;
  }
  
  self.raio = self.raio * 1000;
   
    if(self.coordenada.latitude !=0 && self.coordenada.longitude !=0){
        
        amigo = [[MKPointAnnotation alloc] init];
        amigo.coordinate = self.coordenada;
        amigo.title = @"Amigo";
        amigo.subtitle = @"Localização do pedido de ajuda";
        [_Map1 addAnnotation:amigo];
    }
    
}



-(NSMutableArray *) buscar:(float)lats
             withlongitude:(float)longi
            withraioMeters:(float) raio
              withPriority:(NSNumber *)prio {
  
  NSMutableArray *locais = [[NSMutableArray alloc] init];
  
  NSString *ur = [NSString stringWithFormat:@"http://%@:8080/Emergencia/buscar.jsp?lat=%f&log=%f&tipo='lol'&prioridade=%@&raio=%f",self.conf.ip,lats,longi,prio,self.raio];
  
  
  
  NSURL *urs = [[NSURL alloc] initWithString:ur];
  NSData* data = [NSData dataWithContentsOfURL:urs];
  
  //retorno
  if (data != nil) {
    
    NSError *jsonParsingError = nil;
    NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
    
    //OBjeto Array
    
    NSArray *res = [resultado objectForKey:@"Locais"];
    
    NSDictionary *objo;
    for (int i = 0; i < res.count; i++) {
      
      DCPosto *posto = [[DCPosto alloc] init];
      objo = [res objectAtIndex:i];
      
      posto.lat = [[objo objectForKey:@"latitude"] floatValue];
      posto.log = [[objo objectForKey:@"longitude"] floatValue];
      posto.nome = [objo objectForKey:@"nome"];
      posto.endereco = [objo objectForKey:@"endereco"];
      
      [locais addObject:posto];
    }
  }
  return locais;
}




- (IBAction)OndeEstouAction:(UIBarButtonItem *)sender {

    
  
  if ([CLLocationManager locationServicesEnabled]) {
    //estou verificando se ja existe um location manager alocado
    if (gerenciadorLocalizacao == nil) {
      
      //caso nao exista eu crio um
      gerenciadorLocalizacao = [[CLLocationManager alloc] init];
      
      //objetos da classe CLLocationManager entregam as informacoes sobre a localizacao desejada por delegate
      gerenciadorLocalizacao.delegate = self;
    }
    //solicitando que o locationManager inicie o trabalho de monitorar a localizacao e chamar os metodos delegate nesta classe que foi protocolocada com  CLLocationManagerDelegate (.h)
    [gerenciadorLocalizacao startUpdatingLocation];
  }
}

//desenho do raio de busca de locais próximos
- (void)drawRangeRings: (CLLocationCoordinate2D) where {
  
  // first, I clear out any previous overlays:
  [_Map1 removeOverlays: [_Map1 overlays]];
  
  float range = self.raio; //[self.rangeCalc currentRange] / 1609.3;//MILES_PER_METER;
  MKCircle* innerCircle = [MKCircle circleWithCenterCoordinate: where radius: range];
  innerCircle.title = @"Safe Range";
  
  [_Map1 addOverlay: innerCircle];
}

//desenhando e colorindo o raio
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
  
  MKCircleRenderer *circleR = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
  circleR.fillColor = [UIColor blueColor];
  circleR.alpha = 0.2;
  
  return circleR;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  
  //centralizar o mapa nesta nova localizacao do usuario
  MKCoordinateSpan zoom = MKCoordinateSpanMake(0.015,0.015);
  
  MKCoordinateRegion regiao = MKCoordinateRegionMake(newLocation.coordinate, zoom);
  NSMutableArray *postos = [self buscar:newLocation.coordinate.latitude withlongitude:newLocation.coordinate.longitude withraioMeters:self.raio withPriority:@1];
  for (int i  = 0; i < postos.count; i++) {
    
    pontoaux = [[MKPointAnnotation alloc] init];
    DCPosto *postoaux = postos[i];
    
    pontoaux.title = postoaux.nome;
    CLLocationCoordinate2D coordenada = CLLocationCoordinate2DMake(postoaux.lat, postoaux.log);
    pontoaux.coordinate = coordenada;
    pontoaux.subtitle = postoaux.endereco;
    [_Map1 addAnnotation:pontoaux];
  }
  
  [self drawRangeRings:newLocation.coordinate];
  
 
    //onde o pino sera adicionado
//  ondeEstouAnotacao.coordinate = newLocation.coordinate;
//  _cr = [[CLCircularRegion alloc] initWithCenter:ondeEstouAnotacao.coordinate
//                                          radius:2000
//                                      identifier:@"teste"];
  
  
  //busca por informacoes acerca de uma localizacao
  //CLGeocoder ->fazer a codificacao de uma localizacao trazendo informacoes relevantes
  CLGeocoder *meuCodificadorMapas = [[CLGeocoder alloc] init];
  
  //metodo do clgocoder onde passamos uma cllocation e recebemos suas info pelo bloco completionhandler
  [meuCodificadorMapas reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
    //precisamos garantir que so temos um placemark
    if (placemarks.count == 1) {
      
      //criando um novo placdemark que vai conter  as informacoes do unico placemark contido no vetor de resposta, indice 0
      //ajustar o anotation
      CLPlacemark *infoLocalAtual = [[CLPlacemark alloc] initWithPlacemark:[placemarks objectAtIndex:0]];
      
      ondeEstouAnotacao.title = infoLocalAtual.thoroughfare;
      ondeEstouAnotacao.subtitle = infoLocalAtual.administrativeArea;
      _cr = [[CLCircularRegion alloc] init];
      
      //adiciona o pino no mapa
      _Map1.showsPointsOfInterest = YES;
    }
    //TODO: tratar situacao onde temos mais de um placemark
    //exemplo:exibir uma lista para o usuario para que ele escolha a informacao
  }];
  
  
  [_Map1 setRegion:regiao animated:YES];
  
  //parando a leitura do GPS
  [gerenciadorLocalizacao stopUpdatingLocation];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
  
  if ([annotation isKindOfClass:[MKUserLocation class]]) {
    return nil;
  }
    CLLocationCoordinate2D coordAux = [annotation coordinate];
    if(coordAux.latitude == amigo.coordinate.latitude && coordAux.longitude == amigo.coordinate.longitude){
        MKPinAnnotationView *amigoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"amigo"];
        amigoView.image = [UIImage imageNamed:@"you-make-me-hurt.png"];
        amigoView.canShowCallout = YES;
        
        UIButton *btEsquerdaAmigo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btEsquerdaAmigo.backgroundColor = [UIColor redColor];
        [btEsquerdaAmigo setImage:[UIImage imageNamed:@"home_ico_dica_carro.png"] forState:UIControlStateNormal];
        [btEsquerdaAmigo addTarget:self action:@selector(clickLeftBt) forControlEvents:UIControlEventTouchUpInside];
        btEsquerdaAmigo.layer.cornerRadius = 15;
        
        amigoView.leftCalloutAccessoryView = btEsquerdaAmigo;
        
        amigoView.annotation = annotation;
        
        return amigoView;
    }
    else
    {
        NSString *strPinReuseIdentifier = @"pin";
        
        MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:strPinReuseIdentifier];
        
        if (pin == nil) {
            
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:strPinReuseIdentifier];
            
            UIButton *btEsquerda = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            btEsquerda.backgroundColor = [UIColor redColor];
            [btEsquerda setImage:[UIImage imageNamed:@"home_ico_dica_carro.png"] forState:UIControlStateNormal];
            [btEsquerda addTarget:self action:@selector(clickLeftBt) forControlEvents:UIControlEventTouchUpInside];
            btEsquerda.layer.cornerRadius = 15;
            pin.leftCalloutAccessoryView = btEsquerda;
            pin.canShowCallout = YES;
            pin.image = [UIImage imageNamed:@"teste.png"];
        }
        
        pin.annotation = annotation;
        
        return pin;
    }

  
}

-(void)clickLeftBt {
  
  NSLog(@"CLICOU ESQUERDA");
  
  //create MKMapItem out of coordinates
  MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:pontoaux.coordinate addressDictionary:nil];
  MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
  
  if ([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
    
    //using iOS6 native maps app
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
  }
}


//liga ou desliga o modo "me siga"
- (IBAction)follow:(id)sender {
  
  if(_Map1.userTrackingMode == NO)
    _Map1.userTrackingMode = YES;
  else
    _Map1.userTrackingMode = NO;
}

//definição do tipo de mapa exibido
- (IBAction)TipoMapaAcao:(id)sender {
  
  if (_TipoMapa.selectedSegmentIndex == 0) {
    _Map1.mapType = MKMapTypeStandard;
  } else if (_TipoMapa.selectedSegmentIndex == 1) {
    _Map1.mapType = MKMapTypeHybrid;
  } else if (_TipoMapa.selectedSegmentIndex == 2) {
    _Map1.mapType = MKMapTypeSatellite;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end

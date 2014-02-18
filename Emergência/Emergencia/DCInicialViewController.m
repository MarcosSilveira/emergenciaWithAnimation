//
//  DCInicialViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCInicialViewController.h"
#import "DCLoginViewController.h"
#import "DCReachability.h"
#import "DCEmergenciaViewController.h"
#import "DCConfigs.h"
#import "DCBoundsDetail.h"


@interface DCInicialViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLogado;
@property (weak, nonatomic) IBOutlet UIButton *estou;


@property (nonatomic, readwrite) CGRect button1Bounds;
@property (nonatomic, strong) UIDynamicAnimator *animator;


@property (strong, nonatomic) UIDynamicAnimator *animators;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong , nonatomic) UIDynamicItemBehavior *itemB;


@end

@implementation DCInicialViewController

DCReachability *connectionTest;
UIAlertView *nconnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configuracoesIniciais];
    [self testeDeConeccao];
    _userLogado.text = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
    
    NSString *savedUserName = [[NSUserDefaults standardUserDefaults] stringForKey: @"username"];
    NSString *savedToken = [[NSUserDefaults standardUserDefaults]stringForKey:@"token"];
    
    if(savedUserName!=nil){
        
        DCConfigs *config=[[DCConfigs alloc] init];
        
        
        NSString *ur = [NSString stringWithFormat:@"http://%@:8080/Emergencia/vincular.jsp?login=%@&token=%@",config.ip,savedUserName,savedToken];
        NSLog(@"URL: %@",ur);
        
        
        NSURL *urs = [[NSURL alloc] initWithString:ur];
        NSData* data = [NSData dataWithContentsOfURL:urs];
        if (data != nil) {
            
            NSError *jsonParsingError = nil;
            NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonParsingError];
            
            //OBjeto Array
            
            NSNumber *res = [resultado objectForKey:@"vincular"];
            NSNumber *teste=[[NSNumber alloc] initWithInt:1];
            
            
            if([res isEqualToNumber:teste]){
                NSLog(@"Cadastro ok");
            }
        }
    }
    
    self.button1Bounds = self.estou.bounds;
    
    // Force the button image to scale with its bounds.
    self.estou.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.estou.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
    
    
}


-(void)viewDidAppear:(BOOL)animated{
    self.estou.bounds = self.button1Bounds;
    
    // UIDynamicAnimator instances are relatively cheap to create.
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // APLPositionToBoundsMapping maps the center of an id<ResizableDynamicItem>
    // (UIDynamicItem with mutable bounds) to its bounds.  As dynamics modifies
    // the center.x, the changes are forwarded to the bounds.size.width.
    // Similarly, as dynamics modifies the center.y, the changes are forwarded
    // to bounds.size.height.
    
    DCBoundsDetail *buttonBoundsDynamicItem = [[DCBoundsDetail alloc] initWithTarget:self.estou];
    
    // Create an attachment between the buttonBoundsDynamicItem and the initial
    // value of the button's bounds.
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:buttonBoundsDynamicItem attachedToAnchor:buttonBoundsDynamicItem.center];
    
    [attachmentBehavior setFrequency:10.0];
    //[attachmentBehavior setDamping:0.2];
    [animator addBehavior:attachmentBehavior];
    
    UIAttachmentBehavior *attachmentBehavior2 = [[UIAttachmentBehavior alloc] initWithItem:buttonBoundsDynamicItem attachedToAnchor:buttonBoundsDynamicItem.accessibilityActivationPoint];
    
    [attachmentBehavior2 setFrequency:5.0];
    //[attachmentBehavior setDamping:0.2];
    [animator addBehavior:attachmentBehavior2];
    
    
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[buttonBoundsDynamicItem] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.angle = M_PI_4;
    pushBehavior.magnitude = 50.0;
    [animator addBehavior:pushBehavior];
    
    [pushBehavior setActive:TRUE];
    
    self.animator = animator;
    
    for (int i=0; i<5; i++)
    {
        _userLogado.transform = CGAffineTransformMakeRotation((M_1_PI*90+i*10));
    }
    
    
    _logOutBT.transform = CGAffineTransformMakeRotation(180);
    _contacBT.transform = CGAffineTransformMakeRotation(180);
    
}

- (IBAction)animar:(id)sender {
    self.estou.bounds = self.button1Bounds;
    
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
    
}



-(void) testeDeConeccao {
    NSString *server = [[NSString alloc] init];
    DCConfigs *config=[[DCConfigs alloc] init];
    server = [server stringByAppendingFormat:@"http://%@:8080/Emergencia/", config.ip];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    connectionTest = [DCReachability reachabilityForInternetConnection];
    //    connectionTest = [DCReachability reachabilityWithHostName:server];
    [connectionTest startNotifier];
    
    NetworkStatus remoteHostStatus = [connectionTest currentReachabilityStatus];
    if(remoteHostStatus == NotReachable) {
        
        nconnection = [[UIAlertView alloc] initWithTitle:@"Sem conexão" message:@"Não foi possível conectar aos servidores no momento. Verifique sua conexão com a internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [nconnection show];
    }
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    
    NetworkStatus remoteHostStatus = [connectionTest currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {NSLog(@"no");}
    else if (remoteHostStatus == ReachableViaWiFi) {NSLog(@"wifi"); }
    else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"cell"); }
}

- (void) configuracoesIniciais {
    
    //UIColor *color = self.view.tintColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor blackColor]}];
    self.title = @"Inicial";
    
    //Esconde o bota de voltar
    //TODO: Verificar se o usuário está logado?
    self.navigationItem.hidesBackButton = YES;
    
    if(self.coordenada.latitude!=0 && self.coordenada.longitude !=0){
        [self performSegueWithIdentifier:@"goToEmergencia" sender:self];
        
    }
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"goToEmergencia"]) {
        DCEmergenciaViewController *emergencia = (DCEmergenciaViewController *)segue.destinationViewController;
        emergencia.coordenada = _coordenada;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btLogOut
{
    DCLoginViewController *logon;
    
    logon.login.text = nil;
    
    logon.pass.text = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:logon.login.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:logon.login.text forKey:@"password"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

@end

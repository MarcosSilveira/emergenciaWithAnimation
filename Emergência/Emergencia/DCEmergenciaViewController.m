//
//  DCEmergenciaViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 24/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCEmergenciaViewController.h"
#import "DCMapasViewController.h"

@interface DCEmergenciaViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtRaio;

@end

@implementation DCEmergenciaViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard {
  [self.txtRaio resignFirstResponder];
}

- (void) configuracoesIniciais {
  
  UIColor *color = self.view.tintColor;
  [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: color}];
  self.title = @"Emergência";
  
  _countryNames = @[@"Australia (AUD)", @"China (CNY)",
                    @"France (EUR)", @"Great Britain (GBP)", @"Japan (JPY)"];
  
  _exchangeRates = @[ @0.9922f, @6.5938f, @0.7270f,
                      @0.6206f, @81.57f];
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
  
  NSDecimal raio = [[NSDecimalNumber decimalNumberWithString: self.txtRaio.text] decimalValue];
  [viewController setRaio: raio];
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return _countryNames.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return _countryNames[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 44)];
  label.textColor = self.view.tintColor;
  label.textAlignment = NSTextAlignmentCenter;
  label.text = _countryNames[row];
  return label;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
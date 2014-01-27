//
//  DCEmergenciaViewController.m
//  Emergencia
//
//  Created by Acácio Veit Schneider on 24/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCEmergenciaViewController.h"

@interface DCEmergenciaViewController ()

@end

@implementation DCEmergenciaViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self configuracoesIniciais];
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
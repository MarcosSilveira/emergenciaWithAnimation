//
//  DCViewController.h
//  Doacoes
//
//  Created by Acácio Veit Schneider on 23/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCMapasViewController.h"

@interface DCLoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *cruzImage;
@property (weak, nonatomic) IBOutlet UITextField *login;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (nonatomic)CLLocationCoordinate2D coordenada;
@end

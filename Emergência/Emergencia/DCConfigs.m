//
//  DCConfigs.m
//  Emergencia
//
//  Created by Henrique Manfroi da Silveira on 27/01/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import "DCConfigs.h"


@implementation DCConfigs

- (id)init
{
    self = [super init];
    if (self) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ip"
                                                             ofType:@"txt"];
        
        NSString *fileString = [NSString stringWithContentsOfFile:filePath];
        
        
        NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
        
        
        self.ip=lines[0];
    }
    return self;
}

@end

//
//  DCBoundsDetail.h
//  Emergencia
//
//  Created by Henrique Manfroi da Silveira on 17/02/14.
//  Copyright (c) 2014 Acácio Veit Schneider. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

//! A derivative of the UIDynamicItem protocol that requires objects adopting it
//! to expose a mutable bounds property.
@protocol ResizableDynamicItem <UIDynamicItem>
@property (nonatomic, readwrite) CGRect bounds;
@end


@interface DCBoundsDetail : NSObject<UIDynamicItem>

- (instancetype)initWithTarget:(id<ResizableDynamicItem>)target;

@end

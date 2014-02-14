//
//  LXNaviationController.h
//  ScrollNavigationContoller
//
//  Created by Leon on 14-1-17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXScrollNavigationController : UINavigationController <UIGestureRecognizerDelegate>

@property (assign, nonatomic) UIView *scrollableView;

@end

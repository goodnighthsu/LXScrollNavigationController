//
//  LXNaviationController.m
//  ScrollNavigationContoller
//
//  Created by Leon on 14-1-17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "LXScrollNavigationController.h"

@interface LXScrollNavigationController ()

@property (strong, nonatomic) UIPanGestureRecognizer *gr;
@property (assign, nonatomic) BOOL up;
@property (assign, nonatomic) CGFloat magic;

@property (assign, nonatomic) CGFloat statusBarHeight;
@property (assign, nonatomic) CGFloat navigationBarHeight;
@property (assign, nonatomic) BOOL navBarHidden;

@end

@implementation LXScrollNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //固定值
    self.statusBarHeight =  20;
    self.navigationBarHeight = 44;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //旋转的时候，需要把navBar归位然后由系统默认计算大小和位置
    if (self.navBarHidden) {
        [self showNavBarWithAnimation:NO];
        self.navBarHidden = YES;
    }
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //旋转过程
    if (self.navBarHidden) {
        self.navigationBar.alpha = 0;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //旋转结束
    if (self.navBarHidden) {
        self.navigationBar.alpha = 1;
        [self hideNavBarWithAnimation:NO];
    }
}

#pragma mark - Push or Pop
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self navBarAnimationWithStatus:self.navigationBarHidden];
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self navBarAnimationWithStatus:self.navigationBarHidden];
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self navBarAnimationWithStatus:self.navigationBarHidden];
    return [super popToViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    [self navBarAnimationWithStatus:self.navigationBarHidden];
    return [super popToRootViewControllerAnimated:animated];
}

//显示或隐藏 navigationBar和scrollableView
- (void)navBarAnimationWithStatus:(BOOL)navigationBarHidden
{
    if (navigationBarHidden) {
        [self hideNavBarWithAnimation:NO];
    }else{
        [self showNavBarWithAnimation:NO];
    }
}

#pragma mark - ScrollabelView
//显示navigationBar的情况下，在scrollabelview上添加手势
-  (void)setScrollableView:(UIView *)scrollableView{
    
    _scrollableView = scrollableView;
    
    //没有导航栏
    if (self.navigationBarHidden) {
        return;
    }
    
    //手势

    [scrollableView removeGestureRecognizer:self.gr];
    scrollableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if (self.gr == nil) {
        self.gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onGR:)];
        self.gr.maximumNumberOfTouches = 1;
        self.gr.delegate = self;
    }
 
    [scrollableView addGestureRecognizer:self.gr];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)onGR:(UIPanGestureRecognizer *)gr
{
    //获取delta
    CGPoint translation = [gr translationInView:self.scrollableView];
    CGFloat delta = translation.y;
    [gr setTranslation:CGPointZero inView:self.view];
    
    //确定滑动方向
    if (delta < 0) {
        self.up = YES;
    }
    if (delta > 0) {
        self.up = NO;
    }
    
    //NaviationBar 位置
    CGRect navBarFrame = self.navigationBar.frame;
    
    //限定navBar的位置
    if (navBarFrame.origin.y + delta > self.statusBarHeight ) {
        delta = self.statusBarHeight - navBarFrame.origin.y;
    }
    
    if (navBarFrame.origin.y + delta < - (self.navigationBarHeight + self.statusBarHeight)) {
        delta = -self.navigationBarHeight - self.navigationBarHeight - navBarFrame.origin.y;
    }
    
    //调整navBar和scrollableViw的位置和大小
    if (delta != 0) {
        //
        navBarFrame.origin.y += delta;
        self.navigationBar.frame = navBarFrame;
        
        //
        CGRect contentViewFrame = self.scrollableView.frame;
        contentViewFrame.origin.y += delta;
        contentViewFrame.size.height -= delta;
        self.scrollableView.frame = contentViewFrame;
        //
        UIScrollView *sv = (UIScrollView *)self.scrollableView;
        sv.contentOffset = CGPointMake(sv.contentOffset.x, sv.contentOffset.y + delta);
    }

    //拖动放开
    if (gr.state == UIGestureRecognizerStateEnded) {

        if (self.up) {
            [self hideNavBarWithAnimation:YES];
        }else{
            [self showNavBarWithAnimation:YES];
            
        }
    }
}


#pragma mark - 显示navigation bar 和 scrollableView
//offset保证navigationBar 和 scrollableView 之间的距离，大小
- (void)showNavBarWithAnimation:(BOOL)animation
{

    CGFloat offset = 0;
    CGRect navBarFrame = self.navigationBar.frame;
    
    //
    if (self.magic != -self.statusBarHeight) {
        self.magic = -self.statusBarHeight;
        offset = -navBarFrame.origin.y;
    }else{
        offset = self.statusBarHeight - navBarFrame.origin.y;
    }
    
    CGRect contentViewFrame = self.scrollableView.frame;
    contentViewFrame.origin.y = contentViewFrame.origin.y + offset;
    contentViewFrame.size.height = contentViewFrame.size.height - offset;
    
    navBarFrame.origin.y = self.statusBarHeight;
    if (animation) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.navigationBar.frame = navBarFrame;
                             self.scrollableView.frame = contentViewFrame;
                         }];
    }else{
        self.navigationBar.frame = navBarFrame;
        self.scrollableView.frame = contentViewFrame;
    }
    
    self.navBarHidden = NO;
    
}

#pragma mark - 隐藏navigation bar 和 scrollableView
//offset保证navigationBar 和 scrollableView 之间的距离，大小
- (void)hideNavBarWithAnimation:(BOOL)animation
{
    CGFloat offset = 0;
    CGRect frame = self.navigationBar.frame;
    
    
    if (frame.origin.y <= -self.navigationBarHeight) {
        self.navBarHidden = YES;
        return;
    }
    
    if (self.magic != self.statusBarHeight) {
        self.magic = self.statusBarHeight;
        offset = -self.navigationBarHeight + self.statusBarHeight - frame.origin.y;
    }else{
        offset = -self.navigationBarHeight - frame.origin.y;
    }
    
    CGRect contentViewFrame = self.scrollableView.frame;
    contentViewFrame.origin.y  = contentViewFrame.origin.y + offset;
    contentViewFrame.size.height = contentViewFrame.size.height - offset;
    
    frame.origin.y = -self.navigationBarHeight;
    if (animation) {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.navigationBar.frame = frame;
                             self.scrollableView.frame = contentViewFrame;
                         }];
    }else{
        self.navigationBar.frame = frame;
        self.scrollableView.frame = contentViewFrame;
    }
    
    self.navBarHidden = YES;
}

@end

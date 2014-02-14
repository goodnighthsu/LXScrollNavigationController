//
//  MainViewController.m
//  ScrollNavigationContoller
//
//  Created by Leon on 14-1-17.
//  Copyright (c) 2014年 Leon. All rights reserved.
//

#import "MainViewController.h"
#import "LXNavigationController.h"
#import "ProductList.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBarHidden = YES;
    LXNavigationController *nav =  (LXNavigationController *)self.navigationController;
    nav.scrollableView = self.sv;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Main";
    
    //self.edgesForExtendedLayout = UIRectEdgeNone;

    
    self.sv = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    CGRect svFrame = self.sv.frame;
    svFrame.size.height = svFrame.size.height *2;
    [self.sv setContentSize:svFrame.size];
    self.sv.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.sv];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    msgLabel.text = @"Test!!!!";
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.backgroundColor = [UIColor grayColor];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    [self.sv addSubview:msgLabel];

    UILabel *lastMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 960 - 44, 320, 44)];
    lastMsgLabel.text = @"Last!!!!";
    lastMsgLabel.textColor = [UIColor whiteColor];
    lastMsgLabel.backgroundColor = [UIColor grayColor];
    lastMsgLabel.textAlignment = NSTextAlignmentCenter;
    [self.sv addSubview:lastMsgLabel];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 100, 320, 44);
    bt.titleLabel.textColor = [UIColor whiteColor];
    bt.titleLabel.backgroundColor = [UIColor clearColor];
    bt.backgroundColor = [UIColor grayColor];
    [bt setTitle:@"Go to list" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(onBt:) forControlEvents:UIControlEventTouchUpInside];
    [self.sv addSubview:bt];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onBt:(UIButton *)sender
{
    ProductList *list = [[ProductList alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:list animated:YES];
}


@end

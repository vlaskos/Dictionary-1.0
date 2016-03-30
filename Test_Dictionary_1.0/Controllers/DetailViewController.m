//
//  DetailViewController.m
//  Test_Dictionary_1.0
//
//  Created by vlaskos on 25.03.16.
//  Copyright © 2016 vlaskos. All rights reserved.
//

#import "DetailViewController.h"
#import "GeneralViewController.h"

@interface DetailViewController () 

@property (strong, nonatomic) IBOutlet UITextView *detailTextView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailTextView.text = self.model.translatedWord;
    self.detailTextView.textAlignment = NSTextAlignmentCenter;
    self.detailTextView.font = [UIFont systemFontOfSize:20];
    
    UIImage *image = [UIImage imageNamed:@"arrow.png"];
    NSInteger size = [UIScreen mainScreen].bounds.size.height*0.04;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    button.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightButton;
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void) backButtonAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

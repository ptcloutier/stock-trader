//
//  EmptyStateViewController.m
//  NavCtrl
//
//  Created by perrin cloutier on 9/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EmptyStateViewController.h"
#import "FormViewController.h"



@interface EmptyStateViewController ()

@end

@implementation EmptyStateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Stock Trader";
    self.navigationItem.hidesBackButton = YES;

 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addCompany:(id)sender {
    FormViewController *formViewController = [[FormViewController alloc]initWithNibName: @"FormViewController" bundle: nil];
    [self.navigationController pushViewController:formViewController animated:YES];
    
}
@end

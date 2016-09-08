//
//  EmptyProductsViewController.m
//  NavCtrl
//
//  Created by perrin cloutier on 9/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EmptyProductsViewController.h"
#import "ProductFormViewController.h"

@implementation EmptyProductsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.company = self.companyFromView;
    self.title = self.company.name;
   [self.logoView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", self.company.logo]]];
    
    if(![self.company.stockSymbol  isEqual: @""]){
        self.nameAndStockSymbol.text = [NSString stringWithFormat:@"%@ (%@)", self.company.name, self.company.stockSymbol];
    }else{
        self.nameAndStockSymbol.text = self.company.name;
    }
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addCompany:)];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)addCompany:(id)sender {
    ProductFormViewController *productFormViewController = [[ProductFormViewController alloc]initWithNibName: @"ProductFormViewController" bundle: nil];
    productFormViewController.productVC.editProduct = TRUE;
    productFormViewController.passedCompany = self.company;
    [self.navigationController pushViewController:productFormViewController animated:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_nameAndStockSymbol release];
    [_logoView release];
    [super dealloc];
}

@end

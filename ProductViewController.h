//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyViewController.h"
#import "WebViewController.h"
#import "Company.h"
#import "Product.h"
#import "DAO.h"
@import WebKit;

@interface ProductViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate>

@property (strong, nonatomic) Company *companyFromView;
@property (strong, nonatomic) Company *company;
//@property (strong, nonatomic) Product *product;
@property (strong, nonatomic) UIImageView *logoView;
@property (retain, nonatomic) UILabel *nameAndStockSymbol;
@property (retain, nonatomic) IBOutlet UIView *bottomFloatingView;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *emptyHeaderView;
@property (retain, nonatomic) IBOutlet UIImageView *emptyProductsImageView;
@property (retain, nonatomic) IBOutlet UITextField *emptyCompanyName;
@property (retain, nonatomic) IBOutlet UIView *emptyProductsView;
@property (nonatomic, strong) UIBarButtonItem *barButtonEdit;
@property (nonatomic, strong) UIBarButtonItem *barButtonAdd;
-(void)editButtonPressed;
- (IBAction)addProducts:(id)sender;

//@property (strong, nonatomic) NSMutableArray *products;
//@property (nonatomic, retain) NSArray *companyList;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, retain) WebViewController *webViewController;

@end

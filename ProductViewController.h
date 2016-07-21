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
@import WebKit;

@interface ProductViewController : UITableViewController <WKNavigationDelegate>

@property (strong, nonatomic) Company *companyFromView;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) Product *product;
//@property (strong, nonatomic) NSMutableArray *products;
//@property (nonatomic, retain) NSArray *companyList;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, retain) WebViewController *webViewController;

@end

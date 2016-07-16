//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
@import WebKit;

@interface ProductViewController : UITableViewController <WKNavigationDelegate>
@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic, retain) NSMutableArray *products;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, retain) WebViewController *webViewController;

@end

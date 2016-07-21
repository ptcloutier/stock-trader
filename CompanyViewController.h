//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "ProductViewController.h"


@class ProductViewController;

@interface CompanyViewController : UITableViewController

@property (nonatomic, strong) Company *company;
@property (nonatomic, retain) NSMutableArray *companyList;

 
@end

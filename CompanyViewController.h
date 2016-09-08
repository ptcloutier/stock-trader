//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Company.h"
#import "Product.h"
#import "ProductViewController.h"
#import "FormViewController.h"

@class ProductViewController;

@interface CompanyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSString *daoDidReceiveStockPricesNotification;
@property (nonatomic, strong) Company *company;
@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic) BOOL editCompany;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UIView * emptyStateView;
- (IBAction)addCompanyPressed:(id)sender;

@end



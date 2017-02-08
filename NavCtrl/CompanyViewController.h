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

@property (nonatomic, strong) UIBarButtonItem *barButtonEdit;
@property (nonatomic, strong) UIBarButtonItem *barButtonAdd;
@property (nonatomic, strong) NSString *daoDidReceiveStockPricesNotification;
@property (nonatomic, strong) Company *company;
@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UIView *bottomFloatingView; // undo/redo buttons
@property (nonatomic, retain) UIView *emptyStateView;
//@property (retain, nonatomic) IBOutlet UIButton *addCompanyButton;
- (IBAction)addButtonPressed:(id)sender;
- (void)editButtonPressed;

@end



//
//  EmptyProductsViewController.h
//  NavCtrl
//
//  Created by perrin cloutier on 9/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "CompanyViewController.h"

@interface EmptyProductsViewController : UIViewController


@property (strong, nonatomic) Company *companyFromView;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) IBOutlet UIImageView *logoView;
@property (retain, nonatomic) IBOutlet UILabel *nameAndStockSymbol;
- (IBAction)addCompany:(id)sender;

@end

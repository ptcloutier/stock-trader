//
//  DAO.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormViewController.h"
#import "Product.h"
#import "Company.h"


@interface DAO : NSObject

@property (strong, nonatomic) NSMutableArray *stockPrices;
@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) NSString *daoDidReceiveStockPricesNotification;
-(void)createCompanies;
-(void)addCompanyToCompanyList:(Company *)company;
-(void)getStockQuotes;
+(instancetype)sharedManager;


@end

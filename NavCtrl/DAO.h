//
//  DAO.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "Company.h"


@interface DAO : NSObject

@property (strong, nonatomic) NSMutableArray *companyList;

-(void)createCompanies;
+(instancetype)sharedDAOClass;

@end

//
//  Company.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

@interface Company : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *logo;
@property (strong, nonatomic) NSString *stockSymbol;
@property (strong, nonatomic) NSString *stockPrice;
@property (nonatomic) int companyID;
@property (strong, nonatomic) NSMutableArray *products;
-(instancetype)initWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol;

@end

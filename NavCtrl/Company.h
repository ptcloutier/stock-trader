//
//  Company.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Product;

@interface Company : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *logoURL;
@property (strong, nonatomic) NSString *stockSymbol;
@property (strong, nonatomic) NSString *stockPrice;
@property (strong, nonatomic) NSString *imagePath; // path to company logo image
@property (nonatomic) int position; //array position, changes if table is reordered
@property (nonatomic) int companyID; // unique ID
@property (strong, nonatomic) NSMutableArray *products;
-(instancetype)initWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol;

@end

//
//  Company.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol {
   
    self = [super init];
    if (self) {
        self.name = name;
        self.logo = logo;
        if (stockSymbol) {
            self.stockSymbol = stockSymbol;
        }
     }
    return self;
}

@end

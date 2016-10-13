//
//  Company.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol
{
    self = [super init];
    if (self) {
        self.name = name;
        self.logoURL = [NSURL URLWithString:logo];
        self.stockSymbol = stockSymbol;
    }
    return self;
}


- (void)dealloc {
    [_name release];
    [_logoURL release];
    [_stockSymbol release];
    [_stockPrice release];
    [_imagePath release];
    [_products release];
    [super dealloc];
}


@end


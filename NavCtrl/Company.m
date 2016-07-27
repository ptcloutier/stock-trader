//
//  Company.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithName:(NSString *)name andLogo:(UIImage *)logo andProducts:(NSMutableArray *)products
{
    self = [super init];
    if (self) {
    self.name = name;
    self.logo = logo;
    self.products = products;
    }
    return self;
}

@end
 
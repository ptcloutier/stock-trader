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
@property (strong, nonatomic) UIImage *logo;
@property (strong, nonatomic) NSMutableArray *products;

-(instancetype)initWithName:(NSString *)name andLogo:(UIImage *)logo andProducts:(NSMutableArray *)products;

@end

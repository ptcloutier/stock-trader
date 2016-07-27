//
//  Product.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithName:(NSString *)name andURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.name = name;
        self.url = url;
    }
    return self;
}
@end

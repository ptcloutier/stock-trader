//
//  Product.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
#import "Product.h"

@implementation Product

- (instancetype)initWithName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL
{
    self = [super init];
    if (self) {
        self.name = name;
        if (url){
            self.url = [NSURL URLWithString:url]; //download image to url and save file
        }
        if(imageURL){
            self.imageURL = [NSURL URLWithString:imageURL];
        }
    }
    return self;
}

@end

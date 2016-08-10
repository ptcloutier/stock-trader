//
//  Product.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/19/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *imageURL;

- (instancetype)initWithName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL;
@end

//
//  Company+CoreDataProperties.h
//  NavCtrl
//
//  Created by perrin cloutier on 8/18/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Company.h"

NS_ASSUME_NONNULL_BEGIN

@interface Company (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *stockSymbol;
@property (nullable, nonatomic, retain) NSString *stockPrice;
@property (nullable, nonatomic, retain) NSSet<Product *> *product;

@end

@interface Company (CoreDataGeneratedAccessors)

- (void)addProductObject:(Product *)value;
- (void)removeProductObject:(Product *)value;
- (void)addProduct:(NSSet<Product *> *)values;
- (void)removeProduct:(NSSet<Product *> *)values;

@end

NS_ASSUME_NONNULL_END

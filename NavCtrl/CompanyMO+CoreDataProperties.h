//
//  CompanyMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by perrin cloutier on 9/14/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *position;
@property (nullable, nonatomic, retain) NSString *stockPrice;
@property (nullable, nonatomic, retain) NSString *stockSymbol;
@property (nullable, nonatomic, retain) NSSet<ProductMO *> *productMO;

@end

@interface CompanyMO (CoreDataGeneratedAccessors)

- (void)addProductMOObject:(ProductMO *)value;
- (void)removeProductMOObject:(ProductMO *)value;
- (void)addProductMO:(NSSet<ProductMO *> *)values;
- (void)removeProductMO:(NSSet<ProductMO *> *)values;

@end

NS_ASSUME_NONNULL_END

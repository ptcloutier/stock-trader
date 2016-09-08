//
//  CompanyMO+CoreDataProperties.h
//  NavCtrl
//
//  Created by perrin cloutier on 8/31/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CompanyMO.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompanyMO (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *logo;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *position;
@property (nullable, nonatomic, retain) NSString *stockPrice;
@property (nullable, nonatomic, retain) NSString *stockSymbol;
@property (nullable, nonatomic, retain) NSNumber *companyID;
@property (nullable, nonatomic, retain) NSOrderedSet<ProductMO *> *productMO;

@end

@interface CompanyMO (CoreDataGeneratedAccessors)

- (void)insertObject:(ProductMO *)value inProductMOAtIndex:(NSUInteger)idx;
- (void)removeObjectFromProductMOAtIndex:(NSUInteger)idx;
- (void)insertProductMO:(NSArray<ProductMO *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeProductMOAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInProductMOAtIndex:(NSUInteger)idx withObject:(ProductMO *)value;
- (void)replaceProductMOAtIndexes:(NSIndexSet *)indexes withProductMO:(NSArray<ProductMO *> *)values;
- (void)addProductMOObject:(ProductMO *)value;
- (void)removeProductMOObject:(ProductMO *)value;
- (void)addProductMO:(NSOrderedSet<ProductMO *> *)values;
- (void)removeProductMO:(NSOrderedSet<ProductMO *> *)values;

@end

NS_ASSUME_NONNULL_END

//
//  DAO.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FormViewController.h"
#import "Product.h"
#import "Company.h"


@interface DAO : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSUndoManager *undoManager;
@property (strong, nonatomic) NSMutableArray *companyList;
@property (strong, nonatomic) NSMutableArray *managedObjects; 
@property (strong, nonatomic) Company *company; 
@property (strong, nonatomic) NSString *daoDidReceiveStockPricesNotification;
@property (strong, nonatomic) NSString *imagesDownloadedNotification;
@property (strong, nonatomic) NSString *undoNotification;
@property (strong, nonatomic) UILabel *cellDetailTextLabel;
+(instancetype)sharedManager;
-(void)firstLaunchCheck;
-(void)loadCompanies;
-(Company *)createCompanyWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol;
-(Product *)createProductWithName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL inCompany:(Company *)company;
-(void)modifyCompany:(Company *)company companyName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol;
-(void)modifyProduct:(Product *)product productName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL inCompany:(Company *)company;
-(void)moveCompanyAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
-(void)moveProductAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex inCompany:(Company *)company;
-(void)deleteCompany:(Company *)company;
-(void)deleteProduct:(Product *)product fromCompany:(Company *)company;
-(void)getStockQuotes;
-(void)undoAction;
-(void)redoAction;
 





@end

//
//  DAO.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//
#import "NavControllerAppDelegate.h"
#import "DAO.h"
#import <CoreData/CoreData.h>
#import "CompanyMO.h"
#import "ProductMO.h"


@interface DAO ()


@property (readonly, strong, nonatomic) NavControllerAppDelegate *appDelegate;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DAO

static DAO *dao = nil;


+(instancetype)sharedManager
{
    if (! dao) {
        
        dao = [[DAO alloc] init];
    }
    return dao;
}


 
-(instancetype)init
{
    if (! dao) {
        dao = [super init];
        _appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = [_appDelegate managedObjectContext];
        _undoManager = [_appDelegate undoManager];
        _companyList = [[NSMutableArray alloc] init];
        _daoDidReceiveStockPricesNotification = @"daoDidReceiveStockPricesNotification "; // CompanyViewController will load stock prices from API
         NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return dao;
}



-(void)firstLaunchCheck
{
    // if Core Data is empty, create companies from hard-coded values, otherwise load companies from Core Data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"AppHasLaunchedBefore"] != YES){
        [self createCompanies];
        [userDefaults setBool:YES forKey:@"AppHasLaunchedBefore"];
    }
    else {
        [self loadCompanies];
    }
}


-(BOOL)companiesExist
{
    if(![self.companyList count]){
        return  FALSE;
    }else{
        return  TRUE;
    }
}


-(int)getCompanyID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int companyID = 0;
    companyID = [[userDefaults valueForKey:@"companyID"]intValue];
    companyID++;
    [userDefaults setValue:[NSNumber numberWithInt:companyID] forKey:@"companyID"];
    return companyID;
}



-(Company *)createCompanyWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol
{
    if(![name isEqualToString:@""]) {
    self.company = [[Company alloc]initWithName:name andLogo:logo andStockSymbol:stockSymbol];
    self.company.products = [[NSMutableArray alloc]init];
    self.company.companyID =[self getCompanyID];
    [self.companyList addObject:self.company];
    // add company to managed object collection
    CompanyMO *companyMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:[self.appDelegate managedObjectContext]];
    [companyMO setValue:self.company.name forKey:@"name"];
    [companyMO setValue:self.company.logo forKey:@"logo"];
    [companyMO setValue:self.company.stockSymbol forKey:@"stockSymbol"];
    [companyMO setValue:self.company.stockPrice forKey:@"stockPrice"];
    [companyMO setValue:[NSNumber numberWithInt:self.company.companyID] forKey:@"companyID"];
    [companyMO setValue:[NSNumber numberWithInteger:[self.managedObjects indexOfObject:companyMO ]]forKey:@"position"];
    [self.managedObjects addObject:companyMO];
    return self.company;
    }else{
        return nil;
    }
}


-(Product *)createProductWithName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL inCompany:(Company *)company
{
    Product *product = [[Product alloc]initWithName:name andURL:url andImageURL:imageURL];
    product.companyID = company.companyID;                   //assign company ID to product
    CompanyMO *companyMO;                                    // can I make a variable this way or should I alloc memory?
    int checkID = 0;
    for (CompanyMO *tempMO in self.managedObjects) {
        checkID = [[tempMO valueForKey:@"companyID"]intValue];
        if(checkID == company.companyID){
            companyMO = tempMO;
        }
    }
    [company.products addObject:product];
    // add product to managed object collection
    ProductMO *productMO = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:[_appDelegate managedObjectContext]];
    [productMO setValue:product.name forKey:@"name"];
    [productMO setValue:[product.url absoluteString] forKey:@"url"];
    [productMO setValue:[product.imageURL absoluteString] forKey:@"imageURL"];
    [productMO setValue:[NSNumber numberWithInt:product.companyID] forKey:@"companyID"];
    return product;
}


-(void)modifyCompany:(Company *)company companyName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol
{
   CompanyMO *companyMO;
    for (CompanyMO *tempMO in self.companyList) {
        if([[tempMO valueForKey:@"companyID"]intValue] == company.companyID){
            companyMO = tempMO;
        }
    }
    
    if(![name isEqualToString:@""]){
    company.name = name;
    company.logo = logo;
    company.stockSymbol = stockSymbol;
    [companyMO setValue:company.name forKey:@"name"];
    [companyMO setValue:company.logo forKey:@"logo"];
    [companyMO setValue:company.stockSymbol forKey:@"stockSymbol"];
    }else{
        [self deleteCompany:company];
    }
}


-(void)modifyProduct:(Product *)product productName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL
{
    ProductMO *productMO;
    for (ProductMO *tempMO in self.managedObjects) {
        if([[tempMO valueForKey:@"companyID"]intValue] == product.companyID){
            productMO = tempMO;
        }
    }

    if(![name isEqualToString:@""]){
        product.name = name;
        [productMO setValue:product.name forKey:@"name"];
    }
        product.url = [NSURL URLWithString:url];
        [productMO setValue:[product.url absoluteString] forKey:@"url"];
        product.imageURL = [NSURL URLWithString:imageURL];
        [productMO setValue:[product.imageURL absoluteString] forKey:@"imageURL"];
}



-(void)moveCompanyAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    //move position of company in list
    Company *company = [[[self.companyList objectAtIndex:fromIndex] retain] autorelease];
    [self.companyList removeObjectAtIndex:fromIndex];
    [self.companyList insertObject:company atIndex:toIndex];
    
    //move position of managed object in list
    CompanyMO *companyMO = [[[self.managedObjects objectAtIndex:fromIndex] retain] autorelease];
    [self.managedObjects removeObjectAtIndex:fromIndex];
    [self.managedObjects insertObject:companyMO atIndex:toIndex];
    
    //update positions of managed objects in Core Data
    for (CompanyMO *companyMO in self.managedObjects) {
        [companyMO setValue:[NSNumber numberWithInteger:[self.managedObjects indexOfObject:companyMO ]]forKey:@"position"];
    }
}


-(void)moveProductAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex inCompany:(Company *)company
{
    //move position of product in list
    Product *product = [[[company.products objectAtIndex:fromIndex] retain] autorelease];
    [company.products removeObjectAtIndex:fromIndex];
    [company.products insertObject:product atIndex:toIndex];
    
    CompanyMO *managedObject;
    for (CompanyMO *companyMO in self.managedObjects) {
        if ([[companyMO valueForKey:@"name"]isEqualToString:company.name]){ //check against companyID NOT name
            managedObject = companyMO;
        }
    }
    //move position of managed object in list
    ProductMO *productMO = [[[managedObject.productMO objectAtIndex:fromIndex] retain] autorelease];
    NSMutableOrderedSet *tempSet = managedObject.productMO.mutableCopy;
    [tempSet removeObjectAtIndex:fromIndex];
    [tempSet insertObject:productMO atIndex:toIndex];
    managedObject.productMO = tempSet;
}


-(void)deleteCompany:(Company *)company
{
    CompanyMO *markedForDeletion = nil;
        for (CompanyMO *companyMO in self.managedObjects) {
        if([[companyMO valueForKey:@"companyID"]intValue] == company.companyID){
            markedForDeletion = companyMO;
        }
    }
    [[self.appDelegate managedObjectContext] deleteObject:markedForDeletion];
    [self.managedObjects removeObject:markedForDeletion]; //is this step redundant?
    [self.companyList removeObject:company];
}


-(void)deleteProduct:(Product *)product fromCompany:(Company *)company
{
    for (CompanyMO *companyMO in self.managedObjects) {
        if([[companyMO valueForKey:@"companyID"]intValue]== company.companyID){
            for (ProductMO *productMO in companyMO.productMO) {
                if([[productMO valueForKey:@"name"] isEqualToString:product.name]){
                    [[self.appDelegate managedObjectContext] deleteObject:productMO];
                }
            }
        }
    }
    [company.products removeObject:product];
}



-(void)undoAction
{
    [self.managedObjectContext undo];
    [self reloadDataFromContext];
 }


-(void)redoAction
{
    [self.managedObjectContext redo];
    [self reloadDataFromContext];
}



-(void)loadCompanies
{
    //not first launch, load companies from Core Data
    NSLog(@"not 1st run");
    
    NSArray *results = [[NSArray alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyID" ascending:YES]];
    
    NSError *error = nil;
    results = [self.managedObjectContext executeFetchRequest:request error:&error];
    self.managedObjects = [results mutableCopy];
    
    //sort objects by position
    if (!results) {
        NSLog(@"Error fetching Company objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    [self companyObjectsFromManagedObjects];
}


-(void)companyObjectsFromManagedObjects
{
    //Create companies from managed objects in Core Data
    for (CompanyMO *companyMO in self.managedObjects) {
        Company *company = [[Company alloc]initWithName:[companyMO valueForKey:@"name"] andLogo: [companyMO valueForKey:@"logo"] andStockSymbol:[companyMO valueForKey:@"stockSymbol"]];
        [self.companyList addObject:company];
        for (ProductMO *productMO in companyMO.productMO) {
            Product *product = [[Product alloc]initWithName:[productMO valueForKey:@"name"] andURL:[productMO valueForKey:@"url"] andImageURL:[productMO valueForKey:@"imageURL"]];
            [company.products addObject:product];
        }
    }
    //test companyID property
    for (Company *c in self.companyList) {
        NSLog(@"%@ COMPANY_ID %d", c.name, c.companyID);
    }
}



-(void)reloadDataFromContext
{
    NSArray *results = [[NSArray alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"companyID" ascending:YES]];
    
    NSError *error = nil;
    
    results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!results) {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }else{
        
        [self.managedObjects removeAllObjects];
        self.managedObjects = [results mutableCopy];
        [self.companyList removeAllObjects];
        [self companyObjectsFromManagedObjects];
    }
}



-(void)createCompanies
{
    // first launch, create companies from hard-coded values
    NSLog(@"1st run");
    self.managedObjects = [[NSMutableArray alloc]init];
    
    Company *apple = [self createCompanyWithName:@"Apple" andLogo:@"img-companyLogo_Apple.png" andStockSymbol:@"AAPL"];
    
    Company *google = [self createCompanyWithName:@"Google"andLogo:@"img-companyLogo_Google.png"andStockSymbol:@"GOOG"];
    
    Company *tesla = [self createCompanyWithName:@"Tesla" andLogo:@"img-companyLogo_Tesla.png" andStockSymbol:@"TSLA" ];
    
    Company *twitter = [self createCompanyWithName:@"Twitter"andLogo:@"img-companyLogo_Twitter.png"andStockSymbol:@"TWTR" ];
    
    apple.companyID =[self getCompanyID];
    google.companyID =[self getCompanyID];
    tesla.companyID =[self getCompanyID];
    twitter.companyID =[self getCompanyID];
    
    //add products to companies
    [self createProductWithName:@"Ipad Pro"andURL:@"http://www.apple.com/ipad/" andImageURL:@"https://images-na.ssl-images-amazon.com/images/G/01/aplusautomation/vendorimages/971d3a1c-65e9-4e9b-9cbf-8f81cc73ad16.jpg._CB328017504_.jpg"inCompany:apple];
    [self createProductWithName:@"Ipod Touch"andURL:@"http://www.apple.com/ipod-touch/"andImageURL:@"https://vignette2.wikia.nocookie.net/ipod/images/9/95/IPod_Touch.png/revision/latest?cb=20100820010015"inCompany:apple];
    [self createProductWithName:@"Iphone"andURL:@"http://www.apple.com/iphone/"andImageURL:@"https://store.storeimages.cdn-apple.com/4973/as-images.apple.com/is/image/AppleInc/aos/published/images/i/ph/iphone6/gray/iphone6-gray-select?wid=208&hei=306&fmt=png-alpha&qlt=95&.v=1469565369130"inCompany:apple];
    [self createProductWithName:@"Pixel C"andURL:@"https://store.google.com/product/pixel_c?gl=us"andImageURL:@"https://pixel.google.com/static/images/pixel-c/us/pixel-c-sky.jpg"inCompany:google];
    [self createProductWithName:@"Nexus SP"andURL:@"https://store.google.com/product/nexus_6p?gl=us"andImageURL:@"https://upload.wikimedia.org/wikipedia/commons/4/40/Nexus_5X_(White).jpg"inCompany:google];
    [self createProductWithName:@"Google Cardboard"andURL:@"https://store.google.com/product/google_cardboard?utm_source=en-ha-na-us-sem&utm_medium=desktop&utm_content=plas&utm_campaign=Cardboard&gl=us&gclid=COW08Z7j880CFQFkhgods5cHyQ"andImageURL:@"https://upload.wikimedia.org/wikipedia/commons/a/ad/Google-Cardboard.jpg"inCompany:google];
    [self createProductWithName:@"Model S"andURL:@"https://www.teslamotors.com/models"andImageURL:@"https://file.kbb.com/kbb/vehicleimage/housenew/152x114/2015/2015-tesla-model%20s-frontside_temods151.jpg"inCompany:tesla];
    [self createProductWithName:@"Model X"andURL:@"https://www.teslamotors.com/modelx"andImageURL:@"https://file.kbb.com/kbb/vehicleimage/evoxseo/cp/m/11190/2016-tesla-model%20x-front_11190_032_480x240_evox08.png"inCompany:tesla];
    [self createProductWithName:@"Model 3"andURL:@"https://www.teslamotors.com/model3"andImageURL:@"https://cms.kelleybluebookimages.com/content/dam/kbb-editorial/make/tesla/model-3/2017/03-tesla-model-3-prototype.jpg/jcr:content/renditions/cq5dam.web.1280.1280.jpeg"inCompany:tesla];
    [self createProductWithName:@"Twitter Apps"andURL:@"https://about.twitter.com/products/list"andImageURL:@"https://d13yacurqjgara.cloudfront.net/users/188872/screenshots/1068661/attachments/131941/Twitter_App_Icon.png"inCompany:twitter];
    //test companyID in CoreData
    for (CompanyMO *mo in self.managedObjects) {
        NSLog(@"%@ COMPANY_ID %d", [mo valueForKey:@"name"],[[mo valueForKey:@"companyID"]intValue]);
        for (ProductMO *pmo in mo.productMO) {
            NSLog(@"%@ COMPANY_ID %d", [pmo valueForKey:@"name"],[[pmo valueForKey:@"companyID"]intValue]);
        }
    }
}


-(void)getStockQuotes
{
    //http://finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+TSLA+TWTR&f=sa
    
    NSMutableArray *stockSymbols = [[NSMutableArray alloc]init];
    for (Company *company  in self.companyList) { // make array of stock symbols
        [stockSymbols addObject:company.stockSymbol];
    }
    NSString *urlString = [stockSymbols componentsJoinedByString:@"+"];
    NSString *dataUrl = [NSString stringWithFormat:@"http://finance.yahoo.com/d/quotes.csv?s=%@&f=sa",urlString];
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                      dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                          NSMutableDictionary *stockPrices = [[NSMutableDictionary alloc] init];
                          //split data string by "," and "\n"
                          NSArray *splitByLine = [dataString componentsSeparatedByString:@"\n"];
                          for (NSString *string in splitByLine) {
                              NSArray *line = [string componentsSeparatedByString:@","];
                              if(line.count > 1){
                                  NSString *key = line[0];
                                  NSString *value = line[1];
                                  key = [key stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                  [stockPrices setValue:value forKey:key];
                              }
                          }
                          for (Company *company in self.companyList) {
                              company.stockPrice = [stockPrices valueForKey:company.stockSymbol];
                          }
                          if ( stockPrices != nil){
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  [[NSNotificationCenter defaultCenter]
                                   postNotificationName:self.daoDidReceiveStockPricesNotification
                                   object:self];
                              });
                          }
            }];
[dataTask resume];

}


@end

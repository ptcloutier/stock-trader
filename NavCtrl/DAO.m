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
    self  = [super init];
    
    if (self) {
        _appDelegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = [_appDelegate managedObjectContext];
       // _undoManager = [_appDelegate undoManager];
        _companyList = [[NSMutableArray alloc] init];
        _imagesDownloadedNotification = @"imagesDownloadedNotification";
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return self;
}


-(void)firstLaunchCheck
// if app first run, create companies from hard-coded values, if not first run, load companies from Core Data
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // [userDefaults setBool:false forKey:@"AppHasLaunchedBefore"]; //TEST FOR ONLY FIRST LAUNCH
    
    if ([userDefaults boolForKey:@"AppHasLaunchedBefore"] != true){
        [self createCompaniesFromHardCodedValues];

        [userDefaults setBool:true forKey:@"AppHasLaunchedBefore"];
     }
    else {
        [self loadCompanies];
    }
}


#pragma mark --- UI Actions


-(void)moveCompanyAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    //move position of company in list
    Company *company = [[self.companyList objectAtIndex:fromIndex] retain];
    [self.companyList removeObjectAtIndex:fromIndex];
    [self.companyList insertObject:company atIndex:toIndex];
    [company release];
    //move position of managed object in list
    CompanyMO *companyMO = [[self.managedObjects objectAtIndex:fromIndex] retain];
    [self.managedObjects removeObjectAtIndex:fromIndex];
    [self.managedObjects insertObject:companyMO atIndex:toIndex];
    [companyMO release];
    //update positions of managed objects in Core Data and companyList
    for (Company *company in self.companyList) {
        company.position = (int)[self.companyList indexOfObject:company];
    }
    for (CompanyMO *companyMO in self.managedObjects) {
        [companyMO setValue:[NSNumber numberWithInteger:[self.managedObjects indexOfObject:companyMO ]]forKey:@"position"];
    }
}


-(void)moveProductAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex inCompany:(Company *)company
{   //move position of product in list
    Product *product = [company.products objectAtIndex:fromIndex];
    [company.products insertObject:product atIndex:toIndex];
    [company.products removeObjectAtIndex:fromIndex];
    // get companyMO
    ProductMO *productMO = [self retrieveProductMOforProduct:product inCompany:company];
    //move position of managed object in list
    productMO.position = [NSNumber numberWithInt:product.position];    
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


#pragma mark --- Loading and Creating Collections



-(void)loadCompanies
{
    [self reloadDataFromContext];
}


-(void)reloadDataFromContext
{   //load companies from Core Data, sort by position
    
    if(self.companyList){
        [self.companyList removeAllObjects];
    }else{
        NSMutableArray *companyList = [[NSMutableArray alloc]init];
        self.companyList = companyList;
        [companyList release];
    }
 
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CompanyMO"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]];
    //    NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
    //    [self.managedObjects sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    NSError *error = nil;
    
    
    NSMutableArray *results = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!results) {
        NSLog(@"Error fetching Company objects: %@\n%@", [error localizedDescription], [error userInfo]);
    }else{
        
        self.managedObjects = results;
        
        // recreate Company objects from objects in Core Data
        for (CompanyMO *companyMO in self.managedObjects) {
            [self recreateCompanyFromMO:companyMO];
        }
        // sort each Company by position
        NSSortDescriptor * descriptor = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
        [self.companyList sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        
        for (Company *company in self.companyList) { // sort each Company's products by position
             [company.products sortUsingDescriptors:[NSArray arrayWithObject:descriptor]];
        }
    }
    [results release];
    
}


-(void)recreateCompanyFromMO:(CompanyMO *)companyMO   // create Company and Products from CompanyMO's in Core Data
{
    Company *company = [[Company alloc]initWithName:[companyMO valueForKey:@"name"]
                                            andLogo:[companyMO valueForKey:@"logo"]
                                     andStockSymbol:[companyMO valueForKey:@"stockSymbol"]];
    
    company.position = [companyMO.position intValue];
    company.companyID = [companyMO.companyID intValue];
    // set imagePath
    [self getImageForCompany:company];
    [self.companyList addObject:company];
    NSMutableArray *products = [[NSMutableArray alloc]init];
    company.products = products;
    [products release];
    
 
    for (ProductMO *productMO in companyMO.productsMO) {
        Product *product = [[Product alloc]initWithName:productMO.name
                                                 andURL:productMO.url
                                            andImageURL:productMO.imageURL];
        // set imagePath
        product.position = [productMO.position intValue];
        [self getImageForProduct:product inCompany:company];
        [company.products addObject:product];
        [product release];
    }
    [company release];
}





-(void)createCompaniesFromHardCodedValues
{
    NSLog(@"1ST LAUNCH");
    
//    self.managedObjects = [[NSMutableArray alloc]init];
    
    Company *apple = [self createCompanyWithName:@"Apple" andLogo:@"https://i.uncyclopedia.kr/pedia/thumb/9/9d/Apple_Logo_Transparent.png/120px-Apple_Logo_Transparent.png" andStockSymbol:@"AAPL"];
    
    Company *google = [self createCompanyWithName:@"Google"andLogo:@"https://www.google.as/images/branding/googleg/1x/googleg_standard_color_128dp.png" andStockSymbol:@"GOOG"];
    
    Company *tesla = [self createCompanyWithName:@"Tesla" andLogo:@"https://s-media-cache-ak0.pinimg.com/236x/e0/fd/1e/e0fd1e5df7b6a6b575da6ae470574ac9.jpg"  andStockSymbol:@"TSLA" ];
    
    Company *twitter = [self createCompanyWithName:@"Twitter"andLogo:@"https://www.esmt.org/sites/default/files/styles/wysiwyg_float/public/icon_twitter.png" andStockSymbol:@"TWTR" ];
    
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
   // [apple release];
    //[google release];
    //[tesla release];
    //[twitter release];
}


#pragma mark --- Company Data operations


-(Company *)createCompanyWithName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol
{
    // create Company, add it to collection, create a CompanyMO, Company must have name, other fields optional
    if([name isEqualToString:@""]) {
        return nil;
    }else{
        Company *company = [[Company alloc]initWithName:name andLogo:logo andStockSymbol:stockSymbol];
        NSMutableArray *products = [[NSMutableArray alloc]init];
        company.products = products;
        [products release];
        company.companyID = [self getCompanyID];
        [self getImageForCompany:company]; // get image for logo
        [self.companyList addObject:company];
        company.position = (int)[self.companyList indexOfObject:company];
        [self createManagedObjectFromCompany:company];
        NSLog(@"COMPANY_CREATED %@ ID# %d", company.name, company.companyID);
        [self.appDelegate saveContext];
        [company release];
        return [self.companyList lastObject];
    }
}


-(int)getCompanyID  //assign a unique ID to each Company by incrementing a counter in NSUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int companyID = 0;
    companyID = [[userDefaults valueForKey:@"companyID"]intValue];
    companyID++;
    [userDefaults setValue:[NSNumber numberWithInt:companyID] forKey:@"companyID"];
    return companyID;
}


-(void)createManagedObjectFromCompany:(Company *)company
{
    //create a CompanyMO, add it to collection
    
    CompanyMO *companyMO = [NSEntityDescription insertNewObjectForEntityForName:@"CompanyMO" inManagedObjectContext:self.managedObjectContext];
    companyMO.name = company.name;
    companyMO.logo = [company.logoURL absoluteString];
    companyMO.stockSymbol = company.stockSymbol;
    companyMO.companyID = [NSNumber numberWithInt:company.companyID];
    companyMO.position = [NSNumber numberWithInt:company.position];
    if(!self.managedObjects){
        NSMutableArray *mos = [[NSMutableArray alloc]init];
        self.managedObjects = mos;
        [mos release];
    }
    [self.managedObjects addObject:companyMO];
}


-(void)deleteCompany:(Company *)company
{   // deletes company and managed object, removes from collections
    CompanyMO *companyToDelete = [self retrieveCompanyMOForCompany:company];
    if(companyToDelete != nil) {
        [self.managedObjects removeObject:companyToDelete];
        [self.managedObjectContext deleteObject:companyToDelete];
        }
    [self.companyList removeObject:company];
}


-(void)modifyCompany:(Company *)company companyName:(NSString *)name andLogo:(NSString *)logo andStockSymbol:(NSString *)stockSymbol
{   // if there is a change to url and its not a blank string, then save the image at the url, Company must have name
    CompanyMO *companyMO = [self retrieveCompanyMOForCompany:company];
    if([name isEqualToString:@""]){
        return;
    }else{
        company.name = name;
        company.stockSymbol = stockSymbol;
        
        if(![logo isEqualToString:[company.logoURL absoluteString]]){ //if input is different from current logo
            company.logoURL = [NSURL URLWithString:logo];
            [self getImageForCompany:company];;
        }
        companyMO.name = name ;
        companyMO.logo = logo;
        companyMO.stockSymbol = stockSymbol;
    }
}


-(CompanyMO *)retrieveCompanyMOForCompany:(Company *)company
{
    CompanyMO *companyMO = nil;
    for (CompanyMO *targetCompany in self.managedObjects) {
        if(targetCompany.companyID.intValue == company.companyID) {
            companyMO = targetCompany;
        }
    }
    return companyMO;
}


#pragma mark --- Product Data operations


-(void)createProductWithName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL inCompany:(Company *)company
{
    if(![name isEqualToString:@""]) {   // do not allow user to enter product with blank name field
        Product *product = [[Product alloc]initWithName:name andURL:url andImageURL:imageURL]; 
        product.companyID = company.companyID;
        [self getImageForProduct:product inCompany:company];
        [company.products removeObject:product];
        [company.products addObject:product];
        product.position = (int)[company.products indexOfObject:product];
        [self createManagedObjectFromProduct:product inCompany:company];
        [self.appDelegate saveContext];
        [product release];
     }
}


-(void)createManagedObjectFromProduct:(Product *)product inCompany:(Company *)company
{   // create a ProductMO, add it to collection
    CompanyMO *companyMO = [self retrieveCompanyMOForCompany:company];
    ProductMO *productMO = [NSEntityDescription insertNewObjectForEntityForName:@"ProductMO" inManagedObjectContext:self.managedObjectContext];
    productMO.name = product.name;
    productMO.url = [product.url absoluteString];
    productMO.imageURL = [product.imageURL absoluteString];
    productMO.companyID = [NSNumber numberWithInt:product.companyID];
    productMO.position = [NSNumber numberWithInt:product.position];
    productMO.companyMO = companyMO;
   
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:companyMO.productsMO];
    [mutableSet addObject:productMO];
    companyMO.productsMO = mutableSet;
}


-(void)deleteProduct:(Product *)product fromCompany:(Company *)company
{   // deletes product and managed object, removes from collections
    CompanyMO *companyMO = [self retrieveCompanyMOForCompany:company];
    ProductMO *productMOToDelete = [self retrieveProductMOforProduct:product inCompany:company];
    
    if(productMOToDelete != nil) {
        NSMutableSet *mutableSet = [NSMutableSet setWithSet:companyMO.productsMO];
        [mutableSet removeObject:productMOToDelete];
        companyMO.productsMO = mutableSet;
        [self.managedObjectContext deleteObject:productMOToDelete];
    }
    [company.products removeObject:product];
}


-(void)modifyProduct:(Product *)product productName:(NSString *)name andURL:(NSString *)url andImageURL:(NSString *)imageURL inCompany:(Company *)company
{
    // modify existing product and productMO
    ProductMO *productMO = [self retrieveProductMOforProduct:product inCompany:company];
    //if imageUrl has been changed and string isn't blank, get the new image
    [self getImageForProduct:product inCompany:company];
    
    product.name = name;
    product.url = [NSURL URLWithString:url];
    product.imageURL = [NSURL URLWithString:imageURL];
    [productMO setValue:product.name forKey:@"name"];
    [productMO setValue:[product.url absoluteString] forKey:@"url"];
    [productMO setValue:[product.imageURL absoluteString] forKey:@"imageURL"];
}


-(ProductMO *)retrieveProductMOforProduct:(Product *)product inCompany:(Company *)company
{
    CompanyMO *companyMO = nil;
    ProductMO *productMO = nil;
    for (CompanyMO *targetCompany in self.managedObjects) {
        if(targetCompany.companyID.intValue == company.companyID) {
            companyMO = targetCompany;
            for (ProductMO *targetProduct in companyMO.productsMO) {  
                if([targetProduct.name isEqualToString:product.name]){
                    productMO = targetProduct;
                }
            }
        }
    }
    return productMO;
}


#pragma mark --- Downloading Stock Prices and Images


-(NSString *)getCompanyDirectory:(Company *)company
{
    // get document directory path
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
   
    NSString *companyName =[company.name stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSString *companyDirectory = [documentsPath stringByAppendingString:[NSString stringWithFormat:@"/%@", companyName]];
    
    return companyDirectory;
}


-(void)createPath:(NSString *)path
{
    if(![[NSFileManager defaultManager]fileExistsAtPath:path]){
        NSError *error = nil;
        [[NSFileManager defaultManager]createDirectoryAtPath:path
                                 withIntermediateDirectories:NO
                                                  attributes:nil
                                                       error: &error];
    }
}


-(void)getImageForCompany:(Company *)company
{
    //get document path, assign to company;
    NSString *companyDirectory = [self getCompanyDirectory:company];
    [self createPath:companyDirectory];
    NSString *imageName =[company.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *imagePath = [companyDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.png", imageName]];
    company.imagePath = imagePath;
    if(![[NSFileManager defaultManager]fileExistsAtPath:company.imagePath]){
         [self saveImageAtPath:company.imagePath withURL:company.logoURL];
    }
}


-(void)getImageForProduct:(Product *)product inCompany:(Company *)company
{
    //get document path, assign to company;
    NSString *companyDirectory = [self getCompanyDirectory:company];
    [self createPath:companyDirectory];
    NSString *productsDirectory = [companyDirectory stringByAppendingString:@"/products"];
    [self createPath:productsDirectory];
    NSString *imageName =[product.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *imagePath = [productsDirectory stringByAppendingString:[NSString stringWithFormat:@"/%@.png", imageName]];
    product.imagePath = imagePath;
    if(![[NSFileManager defaultManager]fileExistsAtPath:product.imagePath]){
         [self saveImageAtPath:product.imagePath withURL:product.imageURL];
    }
}


-(NSString *)saveImageAtPath:(NSString *)imagePath withURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                  
                                                  NSData *data = [NSData dataWithContentsOfURL:location];
                                                  
                                                  [data writeToFile:imagePath atomically:YES];
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"imageDownloaded" object:nil];                                                  });
                                                  
                                                  NSLog(@"Downloaded....%@", imagePath);
                                              }];
    [downloadTask resume];
    return imagePath;
}


-(void)getStockQuotes // must convert string into float to handle unwanted extra decimal places
{
    //http://finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+TSLA+TWTR&f=sa //site for API
    NSMutableArray *stockSymbols = [[NSMutableArray alloc]init];
    for (Company *company  in self.companyList) { // make array of stock symbols
        [stockSymbols addObject:company.stockSymbol];
    }
    NSString *urlString = [stockSymbols componentsJoinedByString:@"+"];
    [stockSymbols release];
    NSString *dataUrl = [NSString stringWithFormat:@"http://finance.yahoo.com/d/quotes.csv?s=%@&f=sa",urlString];
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession]
                                      dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                          
                                          // split string of stock quotes by "," and "\n"
                                          NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSMutableDictionary *stockPrices = [[NSMutableDictionary alloc] init];
                                          NSArray *splitByLine = [dataString componentsSeparatedByString:@"\n"];
                                          [dataString release];
                                          for (NSString *string in splitByLine) {
                                              NSArray *line = [string componentsSeparatedByString:@","];
                                              if(line.count > 1){
                                                  NSString *key = line[0];
                                                  NSString *value = [self formatStockPrice:line[1]];
                                                  key = [key stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                                                  [stockPrices setValue:value forKey:key];
                                                  // get floats from strings with standard 0.00 format
                                              }
                                          }
                                          // set stock price property for each company
                                          for (Company *company in self.companyList) {
                                              company.stockPrice = [stockPrices valueForKey:company.stockSymbol];
                                          }
                                          // set cell textlabel in tableview asyncronously
                                          if (stockPrices != nil){
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [[NSNotificationCenter defaultCenter]postNotificationName:@"daoDidReceiveStockPricesNotification" object:self];
                                              });
                                          }
                                          [stockPrices release];
                                      }];
    [dataTask resume];
    
}


-(NSString *)formatStockPrice:(NSString *)stringValue
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    float floatValue = [formatter numberFromString:stringValue].floatValue;
    [formatter release];
    NSString *value = [NSString stringWithFormat:@"%.2f", floatValue];
    NSLog(@"%@", value);
    return value;
}

-(void)dealloc
{
    [_managedObjectContext release];
    [_undoManager release];
    [_companyList release];
    [_managedObjects release];
    [_daoDidReceiveStockPricesNotification release];
    [_imagesDownloadedNotification release];
    [_undoNotification release];
    [_cellDetailTextLabel release];
    [super dealloc];
}

 
@end


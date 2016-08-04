//
//  DAO.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DAO.h"

@implementation DAO

static DAO *daObject = nil;

+(instancetype)sharedManager
{
    if (! daObject) {
        
        daObject = [[DAO alloc] init];
    }
    return daObject;
}


 
-(instancetype)init
{
    if (! daObject) {
        daObject = [super init];
         NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return daObject;
}
    
-(void)addCompanyToCompanyList:(Company*)company
{
    
    [self.companyList addObject:company];
}





-(void)createCompanies {
    
    Product *ipad = [[Product alloc]initWithName:@"Ipad"
                                          andURL:@"http://www.apple.com/ipad/"
                                     andImageURL:@""];
    Product *ipodTouch = [[Product alloc]initWithName:@"Ipod Touch"
                                               andURL:@"http://www.apple.com/ipod-touch/"
                                          andImageURL:@""];
    Product *iphone = [[Product alloc]initWithName:@"Iphone"
                                            andURL:@"http://www.apple.com/iphone/"
                                       andImageURL:@""];
    Product *pixelC = [[Product alloc]initWithName:@"Pixel C"
                                            andURL:@"https://store.google.com/product/pixel_c?gl=us"
                                       andImageURL:@""];
    Product *nexusSP = [[Product alloc]initWithName:@"Nexus SP"
                                             andURL:@"https://store.google.com/product/nexus_6p?gl=us"
                                        andImageURL:@""];
    Product *googleCardboard = [[Product alloc]initWithName:@"Google Cardboard"
                                                     andURL:@"https://store.google.com/product/google_cardboard?utm_source=en-ha-na-us-sem&utm_medium=desktop&utm_content=plas&utm_campaign=Cardboard&gl=us&gclid=COW08Z7j880CFQFkhgods5cHyQ"
                                                andImageURL:@""];
    Product *modelS = [[Product alloc]initWithName:@"Model S"
                                            andURL:@"https://www.teslamotors.com/models"
                                       andImageURL:@""];
    Product *modelX = [[Product alloc]initWithName:@"Model X"
                                            andURL:@"https://www.teslamotors.com/modelx"
                                       andImageURL:@""];
    Product *model3 = [[Product alloc]initWithName:@"Model 3"
                                            andURL:@"https://www.teslamotors.com/model3"
                                       andImageURL:@""];
    Product *twitterApps = [[Product alloc]initWithName:@"Twitter Apps"
                                                 andURL:@"https://about.twitter.com/products/list"
                                            andImageURL:@""];
    
    
    Company *apple = [[Company alloc]initWithName:@"Apple"
                                          andLogo:@"img-companyLogo_Apple.png"
                                   andStockSymbol:@""
                                      andProducts:[NSMutableArray arrayWithObjects:ipad, ipodTouch, iphone, nil ]];
    
    Company *google = [[Company alloc]initWithName:@"Google"
                                           andLogo:@"img-companyLogo_Google.png"
                                    andStockSymbol:@""
                                       andProducts:[NSMutableArray arrayWithObjects:pixelC, nexusSP, googleCardboard, nil]];
    
    Company *tesla = [[Company alloc]initWithName:@"Tesla"
                                          andLogo:@"img-companyLogo_Tesla.png"
                                   andStockSymbol:@""
                                      andProducts:[NSMutableArray arrayWithObjects:modelS, modelX, model3, nil]];
    
    Company *twitter = [[Company alloc]initWithName:@"Twitter"
                                            andLogo:@"img-companyLogo_Twitter.png"
                                     andStockSymbol:@""
                                        andProducts:[NSMutableArray arrayWithObjects:twitterApps, nil]];
    
    
    self.companyList = [NSMutableArray arrayWithObjects: apple, google, tesla, twitter, nil];
    

}
@end

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

+(instancetype)sharedDAOClass
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
    



-(void)createCompanies {
    Product *ipad = [[Product alloc]initWithName:@"Ipad"
                                          andURL:[NSURL URLWithString:@"http://www.apple.com/ipad/"]];
    Product *ipodTouch = [[Product alloc]initWithName:@"Ipod Touch"
                                               andURL:[NSURL URLWithString:@"http://www.apple.com/ipod-touch/"]];
    Product *iphone = [[Product alloc]initWithName:@"Iphone"
                                            andURL:[NSURL URLWithString:@"http://www.apple.com/iphone/"]];
    Product *pixelC = [[Product alloc]initWithName:@"Pixel C"
                                            andURL:[NSURL URLWithString:@"https://store.google.com/product/pixel_c?gl=us"]];
    Product *nexusSP = [[Product alloc]initWithName:@"Nexus SP"
                                             andURL:[NSURL URLWithString: @"https://store.google.com/product/nexus_6p?gl=us"]];
    Product *googleCardboard = [[Product alloc]initWithName:@"Google Cardboard"
                                                     andURL:[NSURL URLWithString:@"https://store.google.com/product/google_cardboard?utm_source=en-ha-na-us-sem&utm_medium=desktop&utm_content=plas&utm_campaign=Cardboard&gl=us&gclid=COW08Z7j880CFQFkhgods5cHyQ"]];
    Product *modelS = [[Product alloc]initWithName:@"Model S"
                                            andURL:[NSURL URLWithString:@"https://www.teslamotors.com/models"]];
    Product *modelX = [[Product alloc]initWithName:@"Model X"
                                            andURL:[NSURL URLWithString:@"https://www.teslamotors.com/modelx"]];
    Product *model3 = [[Product alloc]initWithName:@"Model 3"
                                            andURL:[NSURL URLWithString:@"https://www.teslamotors.com/model3"]];
    Product *twitterApps = [[Product alloc]initWithName:@"Twitter Apps"
                                                 andURL:[NSURL URLWithString:@"https://about.twitter.com/products/list"]];
    
    
    Company *apple = [[Company alloc]initWithName:@"Apple"
                                          andLogo:[UIImage imageNamed:@"img-companyLogo_Apple.png"]
                                      andProducts:[NSMutableArray arrayWithObjects:ipad, ipodTouch, iphone, nil ]];
    
    Company *google = [[Company alloc]initWithName:@"Google"
                                           andLogo:[UIImage imageNamed:@"img-companyLogo_Google.png"]
                                       andProducts:[NSMutableArray arrayWithObjects:pixelC, nexusSP, googleCardboard, nil]];
    
    Company *tesla = [[Company alloc]initWithName:@"Tesla"
                                          andLogo:[UIImage imageNamed:@"img-companyLogo_Tesla.png"]
                                      andProducts:[NSMutableArray arrayWithObjects:modelS, modelX, model3, nil]];
    
    Company *twitter = [[Company alloc]initWithName:@"Twitter"
                                            andLogo:[UIImage imageNamed:@"img-companyLogo_Twitter.png"]
                                        andProducts:[NSMutableArray arrayWithObjects:twitterApps, nil]];
    
    
    self.companyList = [NSMutableArray arrayWithObjects: apple, google, tesla, twitter, nil];
    

}
@end

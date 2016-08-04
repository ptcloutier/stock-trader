//
//  FormViewController.h
//  NavCtrl
//
//  Created by perrin cloutier on 7/28/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "ProductViewController.h"
#import "FormViewController.h"
#import "DAO.h"

@class CompanyViewController;

@interface FormViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) CompanyViewController *companyVC;
@property (retain, nonatomic) IBOutlet UITextField *nameInput;
@property (retain, nonatomic) IBOutlet UITextField *stockSymbolInput;




 @end

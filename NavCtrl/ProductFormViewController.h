//
//  ProductFormViewController.h
//  NavCtrl
//
//  Created by perrin cloutier on 8/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Company.h"
#import "Product.h"
#import "ProductViewController.h"
#import "FormViewController.h"
#import "DAO.h"

@interface ProductFormViewController : UIViewController <UITextFieldDelegate>


@property (strong, nonatomic) Company *passedCompany;
@property (strong, nonatomic) Company *company;
@property (retain, nonatomic) ProductViewController *productVC;
@property (retain, nonatomic) IBOutlet UITextField *productNameInput;
@property (retain, nonatomic) IBOutlet UITextField *productURLInput;
@property (retain, nonatomic) IBOutlet UITextField *productImageURLInput;



@end

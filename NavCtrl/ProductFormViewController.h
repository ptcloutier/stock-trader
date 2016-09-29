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
@property (strong, nonatomic) Product *passedProduct;
@property (strong, nonatomic) Company *company;
@property (strong, nonatomic) Product *product;
@property (retain, nonatomic) ProductViewController *productVC;
@property (nonatomic) BOOL textFieldsAreUp;
@property (retain, nonatomic) IBOutlet UITextField *productNameInput;
@property (retain, nonatomic) IBOutlet UITextField *productURLInput;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UITextField *productImageURLInput;
- (IBAction)deleteButtonPressed:(id)sender;



@end

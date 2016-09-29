//
//  ProductFormViewController.m
//  NavCtrl
//
//  Created by perrin cloutier on 8/3/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductFormViewController.h"

@interface ProductFormViewController ()

@end

@implementation ProductFormViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.company = self.passedCompany;
    self.product = self.passedProduct;
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelForm)];
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProductForm)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];

    self.productNameInput.delegate = self;
    self.productURLInput.delegate = self;
    self.productImageURLInput.delegate = self;
    
    self.title = @"Add Product";
    self.deleteButton.hidden = true;
    if (self.productVC.tableView.editing == true) {
        self.title = @"Edit Product";
        self.deleteButton.hidden = false;
        self.productNameInput.text = self.product.name;
        self.productURLInput.text = [self.product.url absoluteString];
        self.productImageURLInput.text = [self.product.imageURL absoluteString];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}


-(void)textViewShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]){
        return;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveProductForm
{
    // choose between edting existing Company or creating a new one from values on the form
    [self trimBlankSpacesFromInput];
    if (self.productVC.tableView.editing == true){ //modify product
        [[DAO sharedManager] modifyProduct:self.product productName:self.productNameInput.text andURL:[NSString stringWithFormat:@"%@", self.productURLInput.text] andImageURL:[NSString stringWithFormat:@"%@", self.productImageURLInput.text]inCompany:self.company];
        self.deleteButton.hidden = false;
        [self.productVC editButtonPressed];
        [self.productVC.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }else{                              //create new product
        [[DAO sharedManager] createProductWithName:self.productNameInput.text andURL:[NSString stringWithFormat:@"%@", self.productURLInput.text] andImageURL:[NSString stringWithFormat:@"%@", self.productImageURLInput.text]inCompany:self.company];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)trimBlankSpacesFromInput
{   // trim any blank leading or trailing spaces in input
    NSString *tempName = [self.productNameInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *tempURL = [self.productURLInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *tempImgURL = [self.productImageURLInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.productNameInput.text = tempName;
    self.productURLInput.text = tempURL;
    self.productImageURLInput.text = tempImgURL;
}



- (IBAction)deleteButtonPressed:(id)sender
{
    [[DAO sharedManager]deleteProduct:self.product fromCompany:self.company];
    [self.productVC editButtonPressed];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)cancelForm
{
    if(self.productVC.tableView.editing == true){
    [self.productVC editButtonPressed];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}


#define kOFFSET_FOR_KEYBOARD 90.0
// move textfield up if keyboard rises into view


-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    
    //move the main view, so that the keyboard does not hide it.
    if (!self.textFieldsAreUp){
        
        [self moveView:@"up"];
        self.textFieldsAreUp = true;
    }
}


-(void)dismissKeyboard
{
    if (self.textFieldsAreUp){
        
        [self moveView:@"down"];
        [self.productNameInput resignFirstResponder];
        [self.productURLInput resignFirstResponder];
        [self.productImageURLInput resignFirstResponder];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldsAreUp){
        [self moveView:@"down"];
    }
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)moveView:(NSString *)direction
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if ([direction isEqualToString:@"up"]){
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        self.textFieldsAreUp = true;
    }else{
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        self.textFieldsAreUp = false;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}



- (void)dealloc {
    
    [_productNameInput release];
    [_productURLInput release];
    [_productImageURLInput release];
    [_deleteButton release];
    [super dealloc];
}

@end

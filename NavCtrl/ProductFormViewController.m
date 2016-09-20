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
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.company = self.passedCompany;
    self.product = self.passedProduct;
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelForm)];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveProductForm)];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
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
        [self.navigationController popViewControllerAnimated:YES];
    }else{                              //create new product
        [[DAO sharedManager] createProductWithName:self.productNameInput.text andURL:[NSString stringWithFormat:@"%@", self.productURLInput.text] andImageURL:[NSString stringWithFormat:@"%@", self.productImageURLInput.text]inCompany:self.company];
        //    [self.productVC.tableView reloadData];
        //        [self.productVC.tableView setEditing:false animated:YES];
        //        [self.productVC editButtonPressed];
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
    [self.productVC editButtonPressed];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)dealloc {
    
    [_productNameInput release];
    [_productURLInput release];
    [_productImageURLInput release];
    [_deleteButton release];
    [super dealloc];
}

@end

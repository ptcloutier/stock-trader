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
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelForm)];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(productFromInput)];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.productNameInput.delegate = self;
    self.productURLInput.delegate = self;
    self.productImageURLInput.delegate = self;
    
    
}
-(void)textViewShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]){
        return;
    }
    
    //    UIAlertView *helloEarthInputAlert = [[UIAlertView alloc]
    //                                         initWithTitle:@"Name!" message:[NSString stringWithFormat:@"Message: %@", textField.text]
    //                                         delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    // Display this message.
    //    [helloEarthInputAlert show];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)productFromInput
{
    
    
    Product *product = [[Product alloc]initWithName:self.productNameInput.text andURL:self.productURLInput.text andImageURL:self.productImageURLInput.text];

    if (self.company.products == nil) {
        self.company.products = [[NSMutableArray alloc]init];
    }
    
    [self.company.products  addObject:product];
    
    
    [self.productVC.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)cancelForm
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {
    
    [_productNameInput release];
    [_productURLInput release];
    [_productImageURLInput release];
    [super dealloc];
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

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    //    if ([sender isEqual:mailTf])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
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
@end

//
//  FormViewController.m
//  NavCtrl
//
//  Created by perrin cloutier on 7/28/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()
 
@end

@implementation FormViewController


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
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelForm)];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(editOrCreateNew)];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    self.nameInput.delegate = self;
    self.stockSymbolInput.delegate = self;
    self.logoInput.delegate = self;
    self.title = @"New Company";
   
    if (self.companyVC){
        if (self.companyVC.editCompany == TRUE) {
            self.title = @"Edit Company";
            self.nameInput.text = self.company.name;
            self.logoInput.text = self.company.logo;
            self.stockSymbolInput.text = self.company.stockSymbol;
        }
    }
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

-(void)editOrCreateNew {
    if (self.companyVC){
        if (self.companyVC.editCompany == TRUE){
            [self modifyCompanyFromInput];
            self.companyVC.editCompany = FALSE;
        }else{
            [self createCompanyFromInput];
        }
    }else{
        [self createFirstCompany];
    }
}


-(void)modifyCompanyFromInput {
    
    [[DAO sharedManager] modifyCompany:self.company companyName:self.nameInput.text andLogo:self.logoInput.text andStockSymbol:self.stockSymbolInput.text];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}


-(void)createFirstCompany {
    self.company = [[DAO sharedManager] createCompanyWithName:self.nameInput.text andLogo:self.logoInput.text andStockSymbol:self.stockSymbolInput.text];
//    if(self.company){
//        self.companyVC = [[CompanyViewController alloc]initWithNibName:@"CompanyViewController" bundle:nil];
//        [self.navigationController pushViewController:self.companyVC animated:YES];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

-(void)createCompanyFromInput
{
    self.company =[[DAO sharedManager] createCompanyWithName:self.nameInput.text andLogo:self.logoInput.text andStockSymbol:self.stockSymbolInput.text];
    
    [self.companyVC.tableView reloadData];
    self.companyVC.editing = FALSE;
    
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
    [_nameInput release];
    [_stockSymbolInput release];
    [_logoInput release];
    [_logoInput release];
    [_nameInput release];
    [_stockSymbolInput release];
    [_logoInput release];
    [_logoInput release];
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
@end

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelForm)];
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveForm)];
    
    self.navigationItem.leftBarButtonItem = cancelButtonItem;
    [cancelButtonItem release];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    [saveButtonItem release];
    self.nameInput.delegate = self;
    self.stockSymbolInput.delegate = self;
    self.logoInput.delegate = self;
    self.title = @"New Company";
    self.deleteButton.hidden = true;
    
    if (self.isEditing == TRUE) {
        self.deleteButton.hidden = false;
        self.title = @"Edit Company";
        self.nameInput.text = self.company.name;
        self.logoInput.text = [self.company.logoURL absoluteString];
        self.stockSymbolInput.text = self.company.stockSymbol;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [tap release];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)saveForm
{   // choose between editing existing Company or creating new from input
    [self trimBlankSpacesFromInput];
    if (self.isEditing == true){
        // modify company from input and reset edit state in previous view controller
        [[DAO sharedManager] modifyCompany:self.company companyName:self.nameInput.text andLogo:self.logoInput.text andStockSymbol:self.stockSymbolInput.text];
        [self.companyVC editButtonPressed];
        self.deleteButton.hidden = true;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //create company from input
        [[DAO sharedManager]createCompanyWithName:self.nameInput.text andLogo:self.logoInput.text andStockSymbol:self.stockSymbolInput.text];
        [self.companyVC.tableView setEditing:false animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)trimBlankSpacesFromInput
{   // trim any blank leading or trailing spaces in input
    NSString *tempName = [self.nameInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *tempLogo = [self.logoInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *tempStockSymbol = [self.stockSymbolInput.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.nameInput.text = tempName;
    self.logoInput.text = tempLogo;
    self.stockSymbolInput.text = tempStockSymbol;
}


- (IBAction)deleteButtonPressed:(id)sender
{
    [[DAO sharedManager]deleteCompany:self.company];
    [self.companyVC editButtonPressed];
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)cancelForm
{
    if (self.isEditing == true){
        [self.companyVC editButtonPressed];
    }else{
        [self.companyVC.tableView setEditing:false];
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
        [self.nameInput resignFirstResponder];
        [self.stockSymbolInput resignFirstResponder];
        [self.logoInput resignFirstResponder];
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
    [_nameInput release];
    [_stockSymbolInput release];
    [_logoInput release];
    [_deleteButton release];
    [super dealloc];
}



@end

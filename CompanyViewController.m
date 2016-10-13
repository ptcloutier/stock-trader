    //
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "DAO.h"
#import "ProductFormViewController.h"
@class NavControllerAppDelegate;

@interface CompanyViewController ()

@property (nonatomic, strong) DAO *dao;

@end

@implementation CompanyViewController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self chooseView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableAfterNotification:)
                                                 name:@"daoDidReceiveStockPricesNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableAfterNotification:)
                                                 name:@"imageDownloaded"
                                               object:nil];
    [self updateStocksAndImages];
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self makeUndoRedoButtons];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    self.barButtonAdd = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonPressed:)];
    
    self.barButtonEdit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    self.barButtonEdit.title = @"Edit";
    self.navigationItem.leftBarButtonItem = self.barButtonEdit;
    self.navigationItem.rightBarButtonItem = self.barButtonAdd;
 
    self.dao = [DAO sharedManager];
    self.companyList = self.dao.companyList;
    self.emptyStateView = [[[NSBundle mainBundle]loadNibNamed:@"EmptyStateView" owner:self options:nil]firstObject];
    self.emptyStateView.hidden = true;
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateStocksAndImages) userInfo:nil repeats:YES];
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Add/Edit Companies

- (IBAction)addButtonPressed:(id)sender
{   //  show the form to add a new company
    FormViewController *formViewController = [[FormViewController alloc]initWithNibName: @"FormViewController" bundle: nil];
    formViewController.companyVC = self;
    [self.navigationController pushViewController:formViewController animated:YES];
    [formViewController release];
}


-(void)editButtonPressed
{   // toggles Edit and Done on nav bar button
    if([self.barButtonEdit.title isEqualToString: @"Edit"]) {
        [self.tableView setEditing:true animated:YES];
        self.barButtonEdit.title = @"Done";
        self.barButtonAdd.enabled = false;
        self.barButtonAdd.title = @"";
        [self showUndoRedoButtons];
    }else{
        self.barButtonEdit.title = @"Edit";
        [self.tableView setEditing:false animated:YES];
        self.barButtonAdd.enabled = true;
        self.barButtonAdd.title = @"+";
        [self hideUndoRedoButtons];
    }
}


-(void)chooseView
{   // if there are no companies, show the view with add companies button and hide table view
    if([self.companyList count] == 0) {
        self.emptyStateView.hidden = false;
        self.tableView.tableHeaderView = self.emptyStateView;
        self.emptyStateView.frame = self.tableView.frame;
        self.tableView.scrollEnabled = NO;
        self.title = @"Stock Trader";
        [self.navigationItem.leftBarButtonItem setEnabled:false];
        [self.navigationItem.leftBarButtonItem setTintColor:[UIColor clearColor]];
        [self.navigationItem.rightBarButtonItem setEnabled:false];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor clearColor]];
    }else{
        self.emptyStateView.hidden = true;
        self.tableView.tableHeaderView = nil;
        self.tableView.scrollEnabled = YES;
        self.title = @"Watch List";
        [self.navigationItem.leftBarButtonItem setEnabled:true];
        [self.navigationItem.leftBarButtonItem setTintColor:nil];
        [self.navigationItem.rightBarButtonItem setEnabled:true];
        [self.navigationItem.rightBarButtonItem setTintColor:nil];
    }
}


-(void)updateStocksAndImages
{
    for (Company *company in self.companyList) {
          NSLog(@"%@",company.name);
        [self.dao getStockQuotes];
        [self.dao getImageForCompany:company];
        for (Product *product in company.products) {
            [self.dao getImageForProduct:product inCompany:company];
            NSLog(@"%@",product.name);
        }
    }
  
    [self.tableView reloadData];
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.companyList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    self.dao.cellDetailTextLabel = cell.detailTextLabel;
    Company *company = [self.dao.companyList objectAtIndex:[indexPath row]];
    if ([company.stockSymbol  isEqual: @""]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", company.name];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", company.name, company.stockSymbol] ;
    }
    cell.detailTextLabel.text = company.stockPrice;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    NSData *data = [NSData dataWithContentsOfFile:company.imagePath];
    if(data == nil){                // if data at image path is nil, do not attempt to show image 
        cell.imageView.image = nil;
    }else{
        UIImage *image = [UIImage imageWithData:data];
        CGSize itemSize = CGSizeMake(60, 60);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source, reset Edit nav bar button and check that tableView is not empty (chooseView)
        Company *company = [self.companyList objectAtIndex:indexPath.row];
        [self.dao deleteCompany:company];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if(self.tableView.editing == true){
            [self editButtonPressed];
        }
        [self chooseView];
        [self.tableView reloadData];
    }
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.dao moveCompanyAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


#pragma mark - Table view delegate


// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing) {
        //show the edit form for Company
        FormViewController *formViewController = [[FormViewController alloc]initWithNibName: @"FormViewController" bundle: nil];
        formViewController.companyVC = self;
        formViewController.company = [self.companyList objectAtIndex:indexPath.row];
        formViewController.isEditing = true;
        [self.navigationController pushViewController:formViewController animated:YES];
        [formViewController release];
    } else {
        //show the Companys' products
        Company *company = [self.companyList objectAtIndex:[indexPath row]];
        ProductViewController *productViewController = [[ProductViewController alloc]initWithNibName:@"CompanyViewController" bundle:nil];
        productViewController.companyFromView = company;
        [self.navigationController
         pushViewController:productViewController
         animated:YES];
        [productViewController release];
    }
}


-(void)reloadTableAfterNotification:(NSNotification *)notification
{   //notification for stock prices download and image download
    [self.tableView reloadData];
}


#pragma mark - Undo/Redo


-(void)showUndoRedoButtons
{
    self.bottomFloatingView.hidden = NO;
    [self adjustFloatingViewFrame];
}


-(void)hideUndoRedoButtons
{
    self.bottomFloatingView.hidden = YES;
    [self adjustFloatingViewFrame];

 }


-(void)undoPressed
{
    [self.dao undoAction];
    NSLog(@"UNDO_PRESSED");
    [self editButtonPressed];
    [self chooseView];
    [self.tableView reloadData];
}


-(void)redoPressed
{
    [self.dao redoAction];
    NSLog(@"REDO_PRESSED");
    [self editButtonPressed];
    [self chooseView];
    [self.tableView reloadData];
}


-(void)makeUndoRedoButtons
{   // create left button for Redo
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *redoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    redoButton.frame = CGRectMake(0, 0, screenRect.size.width/2, 100);
    redoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    redoButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [redoButton setTitle:@"Redo" forState:UIControlStateNormal];
    [redoButton addTarget:self action:@selector(redoPressed) forControlEvents:UIControlEventTouchUpInside];
    [redoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redoButton setBackgroundColor:[UIColor blackColor]];
    
    // create right button for Undo
    UIButton *undoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    undoButton.frame = CGRectMake(redoButton.frame.origin.x + redoButton.frame.size.width, 0, redoButton.frame.size.width, 100);
    undoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    undoButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoPressed) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [undoButton setBackgroundColor:[UIColor blackColor]];
    
    // create view to hold buttons
    UIView *bview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, 100)];
    self.bottomFloatingView = bview;
    [bview release];
    [self.bottomFloatingView addSubview:redoButton];
    [self.bottomFloatingView addSubview:undoButton];
    [self.tableView addSubview:self.bottomFloatingView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.bottomFloatingView.bounds), 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.bottomFloatingView.bounds), 0.0);
    
    [self.tableView addObserver:self
                     forKeyPath:@"frame"
                        options:0
                        context:NULL];
    
    self.bottomFloatingView.hidden = YES;
 }


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustFloatingViewFrame];
}


#pragma mark - KVO


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        [self adjustFloatingViewFrame];
    }
}


- (void)adjustFloatingViewFrame
{
    CGRect newFrame = self.bottomFloatingView.frame;
    
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y + CGRectGetHeight(self.tableView.bounds) - CGRectGetHeight(self.bottomFloatingView.bounds);
    
    self.bottomFloatingView.frame = newFrame;
    [self.tableView bringSubviewToFront:self.bottomFloatingView];
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"daoDidReceiveStockPricesNotification"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"imageDownloaded"
                                                  object:nil];
}


- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

@end

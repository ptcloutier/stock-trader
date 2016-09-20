//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductFormViewController.h"


@interface ProductViewController ()


@property (nonatomic, strong) DAO *dao; // keep the dao private


@end

@implementation ProductViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self chooseView];
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dao = [DAO sharedManager];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self makeUndoRedoButtons];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    self.company = self.companyFromView;
    self.title = self.company.name;
    
    self.barButtonEdit = [[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
    self.barButtonEdit.title = @"Edit";
    self.barButtonAdd = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addProducts:)];
    self.navigationItem.rightBarButtonItems = @[self.barButtonAdd, self.barButtonEdit];
    self.emptyProductsView = [[[NSBundle mainBundle]loadNibNamed:@"EmptyProductsView" owner:self options:nil]firstObject];
    self.emptyProductsView.frame = self.view.frame;
//   self.emptyProductsView.frame = CGRectMake(0.0, 700, self.tableView.bounds.size.width, self.tableView.bounds.size.height/2);
    self.emptyProductsView.hidden = YES;
//    self.bottomFloatingView.hidden = YES;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addProducts:(id)sender
{
    NSLog(@"add products button touched!");
    
    ProductFormViewController *productFormViewController = [[ProductFormViewController alloc]initWithNibName: @"ProductFormViewController" bundle: nil];
    productFormViewController.productVC = self;
    productFormViewController.passedCompany = self.company;
    [self.navigationController pushViewController:productFormViewController animated:YES];
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
{   // show empty state view with add product button if there aren't any products saved
    if([self.company.products count] == 0) {
         self.tableView.scrollEnabled = NO;
         for (UIBarButtonItem *button in self.navigationItem.rightBarButtonItems) {
            [button setEnabled:false];
            [button setTintColor:[UIColor clearColor]];
        }
         self.tableView.tableFooterView = self.emptyProductsView;
        [self.emptyProductsView setHidden:false];
    }else{
        [self.emptyProductsView setHidden:true];
        self.tableView.tableFooterView = nil;
        self.tableView.scrollEnabled = YES;
        for (UIBarButtonItem *button in self.navigationItem.rightBarButtonItems) {
            [button setEnabled:true];
            [button setTintColor:nil];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.tableView.bounds.size.height * 0.28;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{   //  make header view with Company logo, name, stockSymbol
    // first create the image view
    NSData *data = [NSData dataWithContentsOfFile:self.company.imagePath];
    UIImage *image = [UIImage imageWithData:data];
    CGSize itemSize = CGSizeMake(70, 70);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    self.logoView = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    UIGraphicsEndImageContext();
    
    // create headerView with the same width as the tableView and a little taller than the image
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height/5)];
    headerView.backgroundColor =[UIColor blackColor];

    // Now center it and add it to headerView a little below center of headerView
    float x = CGRectGetMidX([headerView bounds]);
    float y = CGRectGetMidY([headerView bounds]);
    CGFloat xp = x;
    CGFloat yp = y + 20;
    CGPoint imageViewPosition = CGPointMake(xp, yp);
    [self.logoView setCenter:imageViewPosition];
//    CGPoint headerCenter = CGPointMake(CGRectGetMidX([headerView bounds]), CGRectGetMidY([headerView bounds]));
//    self.logoView.center = [headerView convertPoint:headerView.center fromView:headerView.superview];
    [self.tableView addSubview:headerView];
    [headerView addSubview: [self.logoView autorelease]];
    
    //create label
    self.nameAndStockSymbol = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height/5, self.tableView.bounds.size.width, 30)];
    self.nameAndStockSymbol.textAlignment = NSTextAlignmentCenter;
    if([self.company.stockSymbol isEqual: @""]){
        self.nameAndStockSymbol.text = self.company.name;
    }else{
        self.nameAndStockSymbol.text = [NSString stringWithFormat:@"%@ (%@)", self.company.name, self.company.stockSymbol];
    }
    self.nameAndStockSymbol.textColor = [UIColor whiteColor];
    [self.logoView addSubview:self.nameAndStockSymbol];

    [headerView addSubview: [self.nameAndStockSymbol autorelease]];

    return [headerView autorelease];
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.company.products count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.imageView.frame = CGRectMake(0,0,32,32);

    Product *product = [[Product alloc]init];
    product =  [[self.company products]objectAtIndex:indexPath.row];
    cell.textLabel.text = product.name ;
    NSData *data = [NSData dataWithContentsOfFile:product.imagePath];
    if(data == nil){                 // if data at image path is nil, do not attempt to show image
        cell.imageView.image = nil;
    }else{
        UIImage *image = [UIImage imageWithData:data];
        CGSize itemSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dao deleteProduct:[self.company.products objectAtIndex:indexPath.row]fromCompany:self.company];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if(self.tableView.editing == true){
            [self editButtonPressed];
        }
        [self chooseView];
        [self.tableView reloadData];
    }
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [self.dao moveProductAtIndex:fromIndexPath.row toIndex:toIndexPath.row inCompany:self.company];

}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}



 #pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.tableView.editing){
        ProductFormViewController *productFormViewController = [[ProductFormViewController alloc]initWithNibName: @"ProductFormViewController" bundle: nil];
        productFormViewController.productVC = self;
        productFormViewController.passedProduct = [self.company.products objectAtIndex:indexPath.row];
        productFormViewController.productVC.editing = true;
        productFormViewController.passedCompany = self.company;
        [self.navigationController pushViewController:productFormViewController animated:YES];
    } else {
        self.webViewController = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        Product *product = [self.company.products objectAtIndex:indexPath.row];
        self.webViewController.url = product.url;
        [self.navigationController pushViewController:self.webViewController animated:YES];
        [self.webViewController release];
    }
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
{
    //create left button for Redo
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *redoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    redoButton.frame = CGRectMake(0, 0, screenRect.size.width/2, 100);
    redoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    redoButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [redoButton setTitle:@"Redo" forState:UIControlStateNormal];
    [redoButton addTarget:self action:@selector(redoPressed) forControlEvents:UIControlEventTouchUpInside];
    [redoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [redoButton setBackgroundColor:[UIColor blackColor]];
    
    //create right button for Undo
    UIButton *undoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    undoButton.frame = CGRectMake(redoButton.frame.origin.x + redoButton.frame.size.width, 0, redoButton.frame.size.width, 100);
    undoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    undoButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [undoButton addTarget:self action:@selector(undoPressed) forControlEvents:UIControlEventTouchUpInside];
    [undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [undoButton setBackgroundColor:[UIColor blackColor]];
    
    //create view to hold buttons
    self.bottomFloatingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenRect.size.width, 100)];
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


 /*   // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 
 */

- (void)dealloc {
    [_emptyProductsImageView release];
    [_emptyCompanyName release];
    [_emptyHeaderView release];
    [_emptyProductsView release];
    [super dealloc];
}
@end

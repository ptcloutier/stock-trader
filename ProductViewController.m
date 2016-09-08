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




@end

@implementation ProductViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(self.editing){
        self.title = @"Edit Product";
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.company = self.companyFromView;
    self.title = self.company.name;
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTouched)];
    
    self.navigationItem.rightBarButtonItems = @[addButtonItem, self.editButtonItem];
    self.tableView.allowsSelectionDuringEditing = YES;
    self.title = @"Product Link";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addButtonTouched {
    
    NSLog(@"add products button touched!");
    
    ProductFormViewController *productFormViewController = [[ProductFormViewController alloc]initWithNibName: @"ProductFormViewController" bundle: nil];
    productFormViewController.productVC = self;
    productFormViewController.passedCompany = self.company;
    
    [self.navigationController pushViewController:productFormViewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.company.logo]];
    
    // create headerView with the same width as the tableView and a little taller than the image
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, tableView.bounds.size.width, image.size.height + 50)];
    headerView.backgroundColor =[UIColor darkGrayColor];
    
    // create the image view
    UIImageView *companyImage = [[UIImageView alloc] initWithImage:image];
    
    // Now center it and add it to headerView
    companyImage.center = CGPointMake(headerView.bounds.size.width/2, headerView.bounds.size.height/2 + 15);
    [self.view addSubview:headerView];
    [headerView addSubview: [companyImage autorelease]];
    
    //create label
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, tableView.bounds.size.width, 30)];
    sectionTitle.textAlignment = NSTextAlignmentCenter;
    if(![self.company.stockSymbol  isEqual: @""]){
    sectionTitle.text = [NSString stringWithFormat:@"%@ (%@)", self.company.name, self.company.stockSymbol];
    }else{
        sectionTitle.text = self.company.name;
    }
    sectionTitle.textColor = [UIColor whiteColor];
    [companyImage addSubview:sectionTitle];

    [headerView addSubview: [sectionTitle autorelease]];

    return [headerView autorelease];
}


#pragma mark - Table view data source



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
  
    return [self.company.products count];
    
}
- (void)layoutSubviews {
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    [self layoutSubviews];
    cell.imageView.frame = CGRectMake(0,0,32,32);

    self.product = [[self.company products]objectAtIndex:indexPath.row];
    NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.product.imageURL]];
   
    UIImage *thumbnail = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    if (thumbnail == nil) {
        thumbnail = [UIImage imageNamed:@"noimage.png"] ;
    }
    CGSize itemSize = CGSizeMake(40, 40);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [thumbnail drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = self.product.name ;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //this where you add undo/redo buttons
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DAO *dao = [DAO sharedManager];
        [dao deleteProduct:[self.company.products objectAtIndex:indexPath.row]fromCompany:self.company];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    DAO *dao = [DAO sharedManager];
    [dao moveProductAtIndex:fromIndexPath.row toIndex:toIndexPath.row inCompany:self.company];

}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.editing){
        ProductFormViewController *productFormViewController = [[ProductFormViewController alloc]initWithNibName: @"ProductFormViewController" bundle: nil];
        productFormViewController.productVC = self;
        productFormViewController.productVC.product = [self.company.products objectAtIndex:indexPath.row];
        productFormViewController.productVC.editProduct = TRUE;
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


 /*   // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 
 */

@end

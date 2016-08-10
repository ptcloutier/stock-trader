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

@interface CompanyViewController ()

@property (nonatomic, strong) DAO *dao;


@end


@implementation CompanyViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTouched)];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    
    self.dao = [DAO sharedManager]; // add four companies to the list
    [self.dao createCompanies];
    self.companyList = self.dao.companyList;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self.dao getStockQuotes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(daoDidReceiveStockPrices:) name:self.dao.daoDidReceiveStockPricesNotification object:nil];
//    [self.tableView reloadData]; // refresh tableview whenever it is shown to reflect any changes in data, adding or removing companies
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Company *company = [self.dao.companyList objectAtIndex:[indexPath row]];
    NSString *stockPrice = [self.dao.stockPrices objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@) %@",company.name, company.stockSymbol, stockPrice] ;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         
        // Delete the row from the data source
        [self.companyList removeObjectAtIndex:indexPath.row ];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];

    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
       
        
                
    }   
}



// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
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
    
    ProductViewController *productViewController = [[ProductViewController alloc]init];

    Company *company = [self.companyList objectAtIndex:[indexPath row]];
    
    productViewController.companyFromView = company;
     
    [self.navigationController
        pushViewController:productViewController
        animated:YES];
    
}

-(void)addButtonTouched
{
    NSLog(@"add button touched!");
    FormViewController *formViewController = [[FormViewController alloc]initWithNibName: @"FormViewController" bundle: nil];
    formViewController.companyVC = self;
    [self.navigationController pushViewController:formViewController animated:YES];
    
}

-(void)daoDidReceiveStockPrices:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:self.dao.daoDidReceiveStockPricesNotification
                                                  object:nil];
}







@end

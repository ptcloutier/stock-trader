//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"

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
    
    if ([self.title isEqualToString:@"Apple"]) {
        self.products = [[NSMutableArray alloc]initWithArray: self.products1 ];
    }
    else if ([self.title isEqualToString:@"Google"]){
        self.products = [[NSMutableArray alloc]initWithArray: self.products2 ];
    }
    else if ([self.title isEqualToString:@"Tesla"]){
        self.products = [[NSMutableArray alloc]initWithArray: self.products3 ];
    }
    else if ([self.title isEqualToString:@"Twitter"]){
        self.products = [[NSMutableArray alloc]initWithArray: self.products4 ];
    }
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.products1 = [[NSMutableArray alloc]initWithObjects: @"iPad", @"iPod Touch",@"iPhone", nil];
    self.products2 = [[NSMutableArray alloc]initWithObjects: @"Pixel C", @"Nexus SP", @"Google Cardboard", nil];
    self.products3 = [[NSMutableArray alloc]initWithObjects: @"Model S", @"Model X", @"Model 3", nil];
    self.products4 = [[NSMutableArray alloc]initWithObjects: @"Twitter Apps", nil];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if ([self.title isEqualToString:@"Apple"]) {
        cell.imageView.image = [UIImage imageNamed:@"img-companyLogo_Apple.png"];
        cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
    }
    if ([self.title isEqualToString:@"Google"]){
        cell.imageView.image = [UIImage imageNamed:@"img-companyLogo_Google.png"];
        cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
    }
    if ([self.title isEqualToString:@"Tesla"]){
        cell.imageView.image = [UIImage imageNamed:@"img-companyLogo_Tesla.png"];
        cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
    }
    if ([self.title isEqualToString:@"Twitter"]){
        cell.imageView.image = [UIImage imageNamed:@"img-companyLogo_Twitter.png"];
        cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.products removeObjectAtIndex:indexPath.row];
        
        if ([self.title isEqualToString:@"Apple"]) {
            [self.products1 removeObjectAtIndex:indexPath.row ];
        }
        else if ([self.title isEqualToString:@"Google"]){
            [self.products2 removeObjectAtIndex:indexPath.row ];
            ;
        }
        else if ([self.title isEqualToString:@"Tesla"]){
            [self.products3 removeObjectAtIndex:indexPath.row ];
        }
        else if ([self.title isEqualToString:@"Twitter"]){
            [self.products4 removeObjectAtIndex:indexPath.row ];
            ;
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if ([self.title isEqualToString:@"Apple"]){
        [self.products1 exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }if ([self.title isEqualToString:@"Google"]){
        [self.products2 exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }if ([self.title isEqualToString:@"Tesla"]){
        [self.products3 exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    } if ([self.title isEqualToString:@"Twitter"]){
        [self.products4 exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    }
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
    self.webViewController = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
    self.webViewController.url = [self getProductURL:indexPath];
    [self.navigationController pushViewController:self.webViewController animated:YES];
    [self.webViewController release];
    
}


-(NSURL *)getProductURL:(NSIndexPath *)indexPath
{
    NSString *urlString;
    NSURL *url;
    
    if ([self.title isEqualToString:@"Apple"]) {
        if (indexPath.row == 0){
            urlString = @"http://www.apple.com/ipad/";
        } else if (indexPath.row == 1){
            urlString = @"http://www.apple.com/ipod-touch/";
        } else if (indexPath.row == 2){
            urlString = @"http://www.apple.com/iphone/";
        }
    }
    if ([self.title isEqualToString:@"Google"]) {
        if (indexPath.row == 0){
            urlString = @"https://store.google.com/product/pixel_c?gl=us";
        } else if (indexPath.row == 1){
            urlString = @"https://store.google.com/product/nexus_6p?gl=us";
        } else if (indexPath.row == 2){
            urlString = @"https://store.google.com/product/google_cardboard?utm_source=en-ha-na-us-sem&utm_medium=desktop&utm_content=plas&utm_campaign=Cardboard&gl=us&gclid=COW08Z7j880CFQFkhgods5cHyQ";
        }
    }
    if ([self.title isEqualToString:@"Tesla"]) {
        if (indexPath.row == 0){
            urlString = @"https://www.teslamotors.com/models";
        } else if (indexPath.row == 1){
            urlString = @"https://www.teslamotors.com/modelx";
        } else if (indexPath.row == 2){
            urlString = @"https://www.teslamotors.com/model3";
        }
    }
    if ([self.title isEqualToString:@"Twitter"]) {
        if (indexPath.row == 0){
            urlString = @"https://about.twitter.com/products/list";
        } else if (indexPath.row == 1){
            urlString = @"https://about.twitter.com/products/list";
        } else if (indexPath.row == 2){
            urlString = @"https://about.twitter.com/products/list";
        }
    }
    url = [NSURL URLWithString: urlString];
    return url;
    
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

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
#import "EmptyProductsViewController.h"

@class NavControllerAppDelegate;

@interface CompanyViewController ()

@property (nonatomic, strong) DAO *dao;
@property (strong, nonatomic) IBOutlet UIView *bottomFloatingView;
@property (nonatomic, retain) NSUndoManager *undoManager;


@end


@implementation CompanyViewController 

@synthesize undoManager;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.emptyStateView = [[[NSBundle mainBundle] loadNibNamed:@"EmptyStateView" owner:self options:nil] lastObject];
//    [self.tableView addSubview:self.emptyStateView];
    //        [self.tableView bringSubviewToFront:self.emptyStateView];
//    self.emptyStateView.frame = self.view.frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.allowsSelectionDuringEditing = YES;
    [self makeUndoRedoButtons];
    // Uncomment the following line to preserve selection between presentations.
    //     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addCompanyPressed:)];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.dao = [DAO sharedManager];
    self.companyList = self.dao.companyList;
}

-(void)viewWillAppear:(BOOL)animated {
    
 //   [self.dao getStockQuotes];
   // [self showEmptyViewOrTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableAfterNotification:) name:self.dao.daoDidReceiveStockPricesNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableAfterNotification:) name:self.dao.undoNotification object:nil];
    
    [self.tableView reloadData];
    // refresh tableview whenever it is shown to reflect any changes in data, adding or removing companies
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showEmptyViewOrTableView
{
    if([self.companyList count] == 0) {

        self.emptyStateView.hidden = false;
        self.title = @"Stock Trader";
    }else{
        self.emptyStateView.hidden = true;
        //        self.tableView = [[[NSBundle mainBundle] loadNibNamed:@"CompanyViewController.xib"owner:self options:nil]lastObject];
        //        [self.tableView sendSubviewToBack:self.emptyStateView];
        //        [self.tableView willRemoveSubview:self.emptyStateView];
        //        self.tableView.frame = self.view.frame;
        //        [self.emptyStateView removeFromSuperview];
        self.title = @"Watch List";
    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    Company *company = [self.dao.companyList objectAtIndex:[indexPath row]];
    if (![company.stockSymbol  isEqual: @""]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)",company.name, company.stockSymbol] ;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@",company.name];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"img-companyLogo_Apple.png"];
    
    //cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",company.logo]];
    cell.detailTextLabel.text = company.stockPrice;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
   // [self.tableView setEditing:editing animated:animated];
    //[self showUndoRedoButtons];
    
    self.tableView.editing = YES;

}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"DELETE ME");
        // Delete the row from the data source
        [self.dao deleteCompany:[self.companyList objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.editing = FALSE;
        [tableView reloadData];
        //        if([self.dao companiesExist] == false){
        //            self.emptyStateView.hidden = false;
        //        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        //            self.emptyStateView.hidden = true;
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //        }
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
    
//    if(self.editing){
//        //show the edit form for Company
//        FormViewController *formViewController = [[FormViewController alloc]initWithNibName: @"FormViewController" bundle: nil];
//        formViewController.companyVC = self;
//        formViewController.company = [self.companyList objectAtIndex:indexPath.row];
//        formViewController.companyVC.editCompany = YES;
//        self.bottomFloatingView.hidden = YES;
//        self.editing = FALSE;
//        [self.navigationController pushViewController:formViewController animated:YES];
//    } else {
//        //show the Companys' products
//        Company *company = [self.companyList objectAtIndex:[indexPath row]];
//        if(![company.products count]){
//            EmptyProductsViewController *epViewController = [[EmptyProductsViewController alloc]initWithNibName: @"EmptyProductsViewController" bundle: nil];
//            epViewController.companyFromView = company;
//            [self.navigationController pushViewController:epViewController animated:YES];
//        }else{
//            ProductViewController *productViewController = [[ProductViewController alloc]init];
//            productViewController.companyFromView = company;
//            [self.navigationController
//             pushViewController:productViewController
//             animated:YES];
//        }
//    }
}


- (IBAction)addCompanyPressed:(id)sender
{
    FormViewController *formViewController = [[FormViewController alloc]initWithNibName: @"FormViewController" bundle: nil];
    formViewController.companyVC = self;
    [self.navigationController pushViewController:formViewController animated:YES];
}


-(void)reloadTableAfterNotification:(NSNotification *)notification {
    
    [self.tableView reloadData];
}


- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:self.dao.daoDidReceiveStockPricesNotification
                                                  object:nil];
}


-(void)showUndoRedoButtons {
    
    self.bottomFloatingView.hidden = YES;
    if(self.editing){
        if(self.bottomFloatingView.hidden == NO){
            self.bottomFloatingView.hidden = YES;
        }else{
            self.bottomFloatingView.hidden = NO;
        }
    }
}


-(void)redoPressed {
    
    [self.dao redoAction];
    NSLog(@"REDO_PRESSED");
    self.editing = FALSE;
    [self.tableView reloadData];
}


-(void)undoPressed {
    
    [self.dao undoAction];
    NSLog(@"UNDO_PRESSED");
    self.editing = FALSE;
    [self.tableView reloadData];
}


-(void)makeUndoRedoButtons {
    
    //create left button for Redo
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIButton *redoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    //    redoButton.frame = CGRectMake(0,  screenRect.size.height-100,  screenRect.size.width/2, 100);
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





- (void)dealloc {
    [UITableView release];
    [super dealloc];
}

@end

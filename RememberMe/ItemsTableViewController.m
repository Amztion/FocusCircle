//
//  ItemsTableViewController.m
//  RememberMe
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "ItemAddingViewController.h"
#import "ItemsNavigationController.h"

@interface ItemsTableViewController ()

@property (strong, nonatomic) NSArray *tableItems;
@property (strong, retain, nonatomic) UISegmentedControl *segmentedControl;

@property NSArray *ongoing;
@property NSArray *finished;

@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureToolBar];
    self.ongoing = [[NSArray alloc]initWithObjects:@"你妈炸了", @"你妈在天上飞", nil];
    self.finished = [[NSArray alloc]initWithObjects:@"你爸炸了", @"你爸在天上飞", nil];
    self.tableItems = [[NSArray alloc]initWithArray:self.ongoing];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(openAddingViewController:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.title = @"RememberMe";
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)openAddingViewController:(id)sender{
    ItemAddingViewController *addingViewController = [[ItemAddingViewController alloc]init];
    ItemsNavigationController *nvc = [[ItemsNavigationController alloc]initWithRootViewController:addingViewController];
    
//    [nvc presentViewController:addingViewController animated:YES completion:nil];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)configureToolBar{
    
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:[[NSArray alloc]initWithObjects:@"记忆中", @"已完成", nil]];
    [self.segmentedControl sizeToFit];
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.22 alpha:1];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlDidChanged) forControlEvents:UIControlEventValueChanged];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    
    UIBarButtonItem *optionItem = [[UIBarButtonItem alloc]initWithTitle:@"选项" style:UIBarButtonItemStylePlain target:self action:nil];
    
    optionItem.tintColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.22 alpha:1];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    self.toolbarItems = [[NSArray alloc]initWithObjects:spaceItem, barItem,spaceItem, optionItem, nil];
    
}


- (void)segmentedControlDidChanged{

    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.tableItems = [[NSArray alloc]initWithArray:self.ongoing];
            [self.tableView reloadData];
            break;
            
        case 1:
            self.tableItems = [[NSArray alloc]initWithArray:self.finished];
            [self.tableView reloadData];
            
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger numberOfRow;
    
    numberOfRow = self.tableItems.count;
    
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.tableItems[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (void)editTable{
    [self setEditing:![self isEditing]  animated:YES];
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

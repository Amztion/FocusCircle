//
//  ItemsTableViewController.m
//  FocusCircle
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

//列表数据
@property NSArray *timers;
@property NSArray *archives;

@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureToolBar];
    self.timers = [[NSArray alloc]initWithObjects:@"数据一", @"数据二", nil];//测试的数据
    self.archives = [[NSArray alloc]initWithObjects:@"存档数据一", @"存档数据三", nil];
    self.tableItems = [[NSArray alloc]initWithArray:self.timers];
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addingButtonTapped:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.title = @"Timers";
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)configureToolBar{
    
    
    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:[[NSArray alloc]initWithObjects:@"使用中", @"已存档", nil]];
    [self.segmentedControl sizeToFit];
    self.segmentedControl.tintColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.22 alpha:1];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlDidChanged) forControlEvents:UIControlEventValueChanged];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
    
    UIBarButtonItem *optionItem = [[UIBarButtonItem alloc]initWithTitle:@"选项" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonTapped:)];
    
    optionItem.tintColor = [UIColor colorWithRed:0.67 green:0.25 blue:0.22 alpha:1];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    
    self.toolbarItems = [[NSArray alloc]initWithObjects:spaceItem, barItem,spaceItem, optionItem, nil];
    
}

#pragma mark - Actions of Controllers

- (void)segmentedControlDidChanged{

    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            self.tableItems = [[NSArray alloc]initWithArray:self.timers];
            [self.tableView reloadData];
            break;
            
        case 1:
            self.tableItems = [[NSArray alloc]initWithArray:self.archives];
            [self.tableView reloadData];
            
        default:
            break;
    }
}


- (void)addingButtonTapped:(id)sender{
    ItemsNavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addingNavigation"];
    //添加NavigationBar
    
    //[nvc presentViewController:addingViewController animated:YES completion:nil];
    [self presentViewController:nvc animated:YES completion:nil];
    
    //ItemAddingViewController *addV = [[ItemAddingViewController alloc]init];
    //addV.view.frame = [[UIScreen mainScreen]bounds];
    //addV.definesPresentationContext = YES;
    
    //[self presentViewController:addV animated:YES completion:nil];
}

- (void)settingButtonTapped:(id)sender{
    ItemsNavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingNavigation"];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (self.isEditing) {
        self.editButtonItem.title = @"完成";
    }else{
        self.editButtonItem.title = @"编辑";
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

#pragma mark - Apperance of Table View

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark - Action of Table View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end

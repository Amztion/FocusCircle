//
//  ItemsTableViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "ItemsNavigationController.h"

@interface ItemsTableViewController ()

@property (nonatomic, strong) NSArray *timers;

@property (nonatomic) BOOL needsUpdateData;




//列表数据
@property NSArray *archives;

@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedUpdateData:NO];
    
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    
    self.managedObjectContext = appdelegate.managedObjectContext;
    
    
    
    [self configureNavigationBar];
    [self loadData];
    self.archives = [[NSArray alloc]initWithObjects:@"存档数据一", @"存档数据三", nil];
    

}

- (void)viewWillAppear:(BOOL)animated{

    if (self.needsUpdateData) {
        [self loadData];
        self.needsUpdateData = NO;
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ItemModel" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entityDescription];
    
    self.timers = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

- (void)configureNavigationBar{
    self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addingButtonTapped:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.title = @"Timers";
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)setNeedUpdateData:(BOOL)needUpdateData{ //Mark if need reload data;
    self.needsUpdateData = needUpdateData;
}

#pragma mark - Actions of Controllers



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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger numberOfRow;
    
    numberOfRow = self.timers.count;
    
    return numberOfRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    if (self.timers != 0) {
        ItemModel *item =  (ItemModel *)self.timers[indexPath.row];
        cell.titleOfItemLabel.text = item.titleOfItem;
        
        
        cell.durationTimeLabel.text = item.duration.stringValue;
        
        [cell.titleOfItemLabel sizeToFit];
        [cell.durationTimeLabel sizeToFit];
    }

    
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


#pragma mark - Core Data





@end
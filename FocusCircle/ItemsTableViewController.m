//
//  ItemsTableViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "ItemsNavigationController.h"
#import "ItemTextInputViewController.h"
#import "ItemEditingViewController.h"
#import "TimeController.h"

@interface ItemsTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSArray *runningTableViewCells;

@end

@implementation ItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelection = YES;

    [self configureNavigationBar];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
    dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
    dict[NSLocalizedFailureReasonErrorKey] = failureReason;
    dict[NSUnderlyingErrorKey] = error;
    
    [self.fetchedResultController performFetch:&error];
}

- (void)viewWillAppear:(BOOL)animated{
    
//    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.tableFooterView.frame.size.width, self.tableView.tableFooterView.frame.size.height)];
    self.tableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configure View Controller and View

- (void)configureNavigationBar{
    self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addingButtonTapped:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.title = @"Timers";
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark - Actions of Controls

- (void)addingButtonTapped:(id)sender{
    ItemsNavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addingNavigation"];

    ItemTextInputViewController *nvcRoot = (ItemTextInputViewController *)[nvc topViewController];
    
    nvcRoot.managedObjectContext = self.managedObjectContext;
    
    [self presentViewController:nvc animated:YES completion:nil];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultController sections]objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.shouldIndentWhileEditing = YES;
    
    
    ItemModel *item =  (ItemModel *)[self.fetchedResultController objectAtIndexPath:indexPath];
    
    cell.titleOfItemLabel.text = item.titleOfItem;
    [cell.titleOfItemLabel sizeToFit];
    

    NSInteger hours = item.duration.integerValue/3600;
    NSInteger minutes = item.duration.integerValue/60%60;
    NSInteger seconds = item.duration.integerValue%3600 - minutes * 60;
    
    cell.durationTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    [cell.durationTimeLabel sizeToFit];
    

    UITapGestureRecognizer *tapReconizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondToTimerButtonTapped:)];
    tapReconizer.numberOfTapsRequired = 1;
    [cell.timerButtonView addGestureRecognizer:tapReconizer];
    cell.timerButtonView.currentIndexPath = indexPath;
    
    
    TimeController *timeController = [[TimeController alloc]initWithDurationTime:item.duration];
    cell.timeController = timeController;
    
    return cell;
}

-(CGFloat)tableView:(nonnull UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(tableView.indexPathsForSelectedRows.count){
        if ([tableView.indexPathsForSelectedRows indexOfObject:indexPath] != NSNotFound){
            return 150;
        }else{
            return 95;
        }
    }else{
        return 95;
    }
}


#pragma mark - Editing Table View Cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(nonnull UITableView *)tableView editingStyleForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.fetchedResultController.managedObjectContext deleteObject:[self.fetchedResultController objectAtIndexPath:indexPath]];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }   
}


#pragma mark - Action of Table View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editing){
    
        ItemModel *item =  (ItemModel *)[self.fetchedResultController objectAtIndexPath:indexPath];
        
        NSInteger hours = item.duration.integerValue/3600;
        NSInteger minutes = item.duration.integerValue/60%60;
        NSInteger seconds = item.duration.integerValue%3600 - minutes * 60;
        
        ItemsNavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editingNavigation"];
        ItemEditingViewController *editingViewController = (ItemEditingViewController *)nvc.topViewController;
        editingViewController.managedObjectContext = self.managedObjectContext;
        editingViewController.titleOfItem = item.titleOfItem;
        editingViewController.hours = [NSNumber numberWithInteger:hours];
        editingViewController.minutes = [NSNumber numberWithInteger:minutes];
        editingViewController.seconds = [NSNumber numberWithInteger:seconds];
        editingViewController.indexPath = indexPath;
        editingViewController.fetchedResulesController = self.fetchedResultController;
        
        [self presentViewController:nvc animated:YES completion:nil];
    }else{
        [self updateTableView:tableView];
    }

}

-(void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [self updateTableView:tableView];
}

#pragma mark - Configure Core Data

-(NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"ItemModel" inManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sortValue" ascending:NO];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    _fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultController.delegate = self;
    
    return _fetchedResultController;
}

-(NSManagedObjectContext *)managedObjectContext{
    AppDelegate *appdelegate = [[UIApplication sharedApplication]delegate];
    
    _managedObjectContext = appdelegate.managedObjectContext;
    
    return _managedObjectContext;
}

#pragma mark - Delegeate of NSFetchedResultController
-(void)controllerWillChangeContent:(nonnull NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void)controller:(nonnull NSFetchedResultsController *)controller didChangeObject:(nonnull __kindof NSManagedObject *)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    
    
    if (type == NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if(type == NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(type == NSFetchedResultsChangeUpdate){
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}

-(void)controllerDidChangeContent:(nonnull NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}


-(void)updateTableView:(UITableView *)tableView{
    [tableView beginUpdates];
    [tableView endUpdates];
}

#pragma mark - Gesture Recognizer

-(void)respondToTimerButtonTapped:(UITapGestureRecognizer *)sender{
    if (self.editing) {
    }else{
        TimerButton *timerView = (TimerButton *)[sender view];
        ItemTableViewCell *tableViewCell = (ItemTableViewCell *)[self.tableView cellForRowAtIndexPath:timerView.currentIndexPath];
        TimeController *timeController = tableViewCell.timeController;
        switch (timeController.status) {
            case TimerPausing:
                break;
            case TimerStopped:
                timeController.status = TimerRunning;
                timeController.startTime = [self getCurrentTime];
                [self createTimerForTableViewCell:tableViewCell];
                
                break;
            case TimerRunning:
                break;
            default:
                break;
        }
    }

}

#pragma mark - Timer
-(void)createTimerForTableViewCell: (ItemTableViewCell *)tableViewCell{
    NSTimer *countdown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownForTimer:) userInfo:tableViewCell repeats:YES];
    tableViewCell.timeController.timer = countdown;
    [countdown fire];
}

-(void)countdownForTimer: (NSTimer *)sender{
    if (sender.valid) {
        ItemTableViewCell *tableViewCell = (ItemTableViewCell *)sender.userInfo;
        
        if([tableViewCell.timeController.remainingTime isEqualToNumber:[NSNumber numberWithDouble:0.0]]){
            [sender invalidate];
            NSInteger hours = tableViewCell.timeController.durationTime.integerValue/3600;
            NSInteger minutes = tableViewCell.timeController.durationTime.integerValue/60%60;
            NSInteger seconds = tableViewCell.timeController.durationTime.integerValue%3600 - minutes * 60;
            
            tableViewCell.durationTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
            [tableViewCell.durationTimeLabel sizeToFit];
            tableViewCell.timeController.remainingTime = tableViewCell.timeController.durationTime;
            tableViewCell.timeController.status = TimerStopped;
            
        }else if(tableViewCell.timeController.remainingTime.doubleValue > 0){
            NSNumber *oldNumer = tableViewCell.timeController.remainingTime;
            tableViewCell.timeController.remainingTime = [NSNumber numberWithDouble:oldNumer.doubleValue - 1];
            oldNumer = nil;

            NSInteger hours = tableViewCell.timeController.remainingTime.integerValue/3600;
            NSInteger minutes = tableViewCell.timeController.remainingTime.integerValue/60%60;
            NSInteger seconds = tableViewCell.timeController.remainingTime.integerValue%3600 - minutes * 60;
            
            tableViewCell.durationTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
            [tableViewCell.durationTimeLabel sizeToFit];
        }else{
            
        }
    }
}

-(NSDate*)getCurrentTime{
    NSDate *now = [NSDate date];
    NSTimeZone *currentTimeZone = [NSTimeZone systemTimeZone];
    NSInteger seconds = [currentTimeZone secondsFromGMTForDate:now];
    NSDate *localTimeNow = [now dateByAddingTimeInterval:seconds];
    
    return localTimeNow;
}


@end
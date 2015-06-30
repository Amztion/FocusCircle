//
//  TimersTableViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/5/29.
//  Copyright (c) 2015年 Liang Zhao. All rights reserved.
//

int BadgeNumer = 0;

#import "TimersTableViewController.h"

@interface TimersTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultController;
@property (nonatomic, strong) NSMutableArray *runningTimerControllers;

@end

@implementation TimersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"load");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreTimerControllers) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(saveTimerControllers) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveTimerControllers) name:UIApplicationWillResignActiveNotification object:nil];

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
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.tableFooterView.frame.size.width, self.tableView.tableFooterView.frame.size.height)];
    self.tableView.tableFooterView.backgroundColor = [UIColor lightGrayColor];

    NSLog(@"appear");
    [self restoreTimerControllers];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSMutableArray *)runningTimerControllers{
    
    if (_runningTimerControllers) {
        return _runningTimerControllers;
    }else{
        _runningTimerControllers = [[NSMutableArray alloc]init];
    }
    
    return _runningTimerControllers;
}

#pragma mark - Save and Restore TimerController

-(void)saveTimerControllers{
    
    NSLog(@"save");
    NSPropertyListFormat format;
    NSError *error;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingString:@"/TimerControllers.plist"];
    if([[NSFileManager defaultManager]fileExistsAtPath:plistPath]){
        
        NSData *plistXML = [[NSFileManager defaultManager]contentsAtPath:plistPath];
        NSMutableArray *statusToRestore = (NSMutableArray *)[NSPropertyListSerialization propertyListWithData:plistXML options:0 format:&format error:&error];
        if (statusToRestore || statusToRestore.count != 0) {
            [statusToRestore removeAllObjects];
            [statusToRestore writeToFile:plistPath atomically:YES];
        }
    }
    

    
    if (self.runningTimerControllers.count != 0) {
        
        NSMutableArray *timerControllersToSave = [[NSMutableArray alloc]init];
        
        for (TimerController *timerController in self.runningTimerControllers) {
            [timerController.timer setFireDate:[NSDate distantFuture]];
            [timerController.timer invalidate];
            timerController.timer = nil;
            
            if (timerController.currentStatus == TimerRunning) {
                [self createNotificationWithTitleOfTimer:timerController.relatedTimerModel.titleOfTimer andRemainingTime:timerController.remainingTime];
            }
            
            NSDate *shouldEndTime = [timerController.startedTime dateByAddingTimeInterval:timerController.durationTime.doubleValue];
            NSNumber *remainingTime = [timerController remainingTime];
            NSDate *startedTime = timerController.startedTime;
            NSNumber *row = [NSNumber numberWithInteger:timerController.indexPath.row];
            NSNumber *section = [NSNumber numberWithInteger:timerController.indexPath.section];
            NSNumber *currentStatus = [NSNumber numberWithInt:timerController.currentStatus];
            
            NSMutableDictionary *status = [NSMutableDictionary dictionary];
            
            [status setObject:section forKey:@"section"];
            [status setObject:row forKey:@"row"];
            [status setObject:startedTime forKey:@"startedTime"];
            [status setObject:remainingTime forKey:@"remainingTime"];
            [status setObject:shouldEndTime forKey:@"shouldEndTime"];
//            NSLog(@"%@, %@, %@", startedTime, remainingTime, shouldEndTime);
            [status setObject:currentStatus forKey:@"currentStatus"];
            
            [timerControllersToSave addObject:status];
        }
        
        self.runningTimerControllers = nil;
        
        
        NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:timerControllersToSave format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
        
        if (plistData) {
            [plistData writeToFile:plistPath atomically:YES];
        }else{
            NSLog(@"%@",error);
        }
    }
}

-(void)restoreTimerControllers{
    
    NSLog(@"restore");
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    BadgeNumer = 0;
    
    NSPropertyListFormat format;
    NSError *error;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingString:@"/TimerControllers.plist"];
    if(![[NSFileManager defaultManager]fileExistsAtPath:plistPath]){
        return;
    }
    
    NSData *plistXML = [[NSFileManager defaultManager]contentsAtPath:plistPath];
    NSMutableArray *statusToRestore = (NSMutableArray *)[NSPropertyListSerialization propertyListWithData:plistXML options:0 format:&format error:&error];
    if (!statusToRestore) {
        NSLog(@"%@", error);
    }
    if(statusToRestore.count == 0){
        return;
    }
    
    _runningTimerControllers = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < statusToRestore.count; ++i) {
        TimerController *timerController = [[TimerController alloc]init];
        NSDictionary *dict = (NSDictionary *)statusToRestore[i];
        NSInteger section = ((NSNumber *)[dict objectForKey:@"section"]).integerValue;
        NSInteger row = ((NSNumber *)[dict objectForKey:@"row"]).integerValue;
        
        NSDate *startedTime = (NSDate *)[dict objectForKey:@"startedTime"];
        NSNumber *remainingTime = (NSNumber *)[dict objectForKey:@"remainingTime"];
        NSDate *shouldEndTime = (NSDate *)[dict objectForKey:@"shouldEndTime"];
        
        int currentStatus = ((NSNumber *)[dict objectForKey:@"currentStatus"]).intValue;
        
        timerController.indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        timerController.startedTime = startedTime;
        timerController.currentStatus = currentStatus;
        timerController.relatedTimerModel = (TimerModel *)[self.fetchedResultController objectAtIndexPath:timerController.indexPath];
        timerController.relatedTimerModel.timerController = timerController;
        timerController.durationTime = timerController.relatedTimerModel.durationTime;
        
        
//        NSLog(@"%@, %@, %@", startedTime, remainingTime, shouldEndTime);
        NSDate *currentDate = [NSDate date];
        
        if ([shouldEndTime compare:currentDate] == NSOrderedDescending && timerController.currentStatus == 2) {
            timerController.remainingTime = [NSNumber numberWithDouble:[shouldEndTime timeIntervalSinceDate:currentDate] + 1];
            NSLog(@"%@",timerController.remainingTime);
            [self createTimerForTimerController:timerController isRestored:YES];
            [self.runningTimerControllers addObject:timerController];
        }else{
            if (timerController.currentStatus == 1) {
                timerController.remainingTime = [NSNumber numberWithDouble:remainingTime.doubleValue + 1];
                [self createTimerForTimerController:timerController isRestored:YES];
                timerController.timer.fireDate = [NSDate distantFuture];
                [self.runningTimerControllers addObject:timerController];
            }else{
                timerController.remainingTime = [timerController.durationTime copy];
                timerController.currentStatus = TimerStopped;
                timerController.relatedTimerModel.lastUsedTime = shouldEndTime;
            }
        }
        
        TimerTableViewCell *cell =  (TimerTableViewCell *)[self.tableView cellForRowAtIndexPath:timerController.indexPath];
        cell.timerButtonView.relatedTimerController = timerController;
        
    }
    
    [statusToRestore removeAllObjects];
    [statusToRestore writeToFile:plistPath atomically:YES];
}

#pragma mark - UILocalNotification

-(void)createNotificationWithTitleOfTimer: (NSString *)titleOfTimer andRemainingTime: (NSNumber *)remainingTime{
    UILocalNotification *newNotification = [[UILocalNotification alloc]init];
    newNotification.timeZone = [NSTimeZone systemTimeZone];
    newNotification.alertBody = titleOfTimer;
    newNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:remainingTime.doubleValue];
    newNotification.soundName = UILocalNotificationDefaultSoundName;
    newNotification.applicationIconBadgeNumber = BadgeNumer + 1;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
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
    NavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"addingNavigation"];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)settingButtonTapped:(id)sender{
    NavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingNavigation"];
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
    NSLog(@"cell");
    TimerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"timerCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.shouldIndentWhileEditing = YES;
    
    TimerModel *timerModel =  (TimerModel *)[self.fetchedResultController objectAtIndexPath:indexPath];
    TimerController *timerController = timerModel.timerController;
    
    cell.titleOfTimerLabel.text = timerModel.titleOfTimer;
    cell.durationTimeLabel.text = [NSString stringWithSeconds:timerController.remainingTime];
    if ([timerModel.lastUsedTime description]) {
        cell.lastUsedTime.text = [NSString stringWithFormat:@"上次使用 %@", [timerController.relatedTimerModel.lastUsedTime displayDateWithFormateInCurrentTimeZone]];
    }else{
        cell.lastUsedTime.text = @"尚未使用";
    }

    UITapGestureRecognizer *tapReconizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondToTimerButtonTapped:)];
    tapReconizer.numberOfTapsRequired = 1;
    [cell.timerButtonView addGestureRecognizer:tapReconizer];
    cell.timerButtonView.relatedTimerController = timerController;
    
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
        TimerModel *timerModelToDelete = [self.fetchedResultController objectAtIndexPath:indexPath];
        if (timerModelToDelete.timerController.currentStatus != TimerStopped) {
            [self stopTimerForTimerController:timerModelToDelete.timerController andStopNormally:NO];
        }
        [self.fetchedResultController.managedObjectContext deleteObject:timerModelToDelete];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}


#pragma mark - Action of Table View
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.editing){
        TimerModel *timerModel = (TimerModel *)[self.fetchedResultController objectAtIndexPath:indexPath];
        TimerController *timerController = timerModel.timerController;
        if (timerController.currentStatus != TimerStopped) {
            UIAlertController *editAlert = [UIAlertController alertControllerWithTitle:@"正在运行" message:@"请先停止计时器" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *stopTimer = [UIAlertAction actionWithTitle:@"停止" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction){
                [self stopTimerForTimerController:timerController andStopNormally:NO];
            }];
            [editAlert addAction:stopTimer];
            UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [editAlert addAction:cancelAlert];
            [self presentViewController:editAlert animated:YES completion:nil];
        }else{
            NavigationController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"editingNavigation"];
            TimerEditingViewController *editingViewController = (TimerEditingViewController *)nvc.topViewController;
            [editingViewController setValueForFetchedResultsController:self.fetchedResultController forTimerIndexPath:indexPath];
            [self presentViewController:nvc animated:YES completion:nil];           
        }

        
    }else{
        
        TimerTableViewCell *currentCell = (TimerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [tableView beginUpdates];
        currentCell.lastUsedTime.hidden = NO;
        [tableView endUpdates];
    }

}

-(void)tableView:(nonnull UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    TimerTableViewCell *currentCell = (TimerTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView beginUpdates];
    currentCell.lastUsedTime.hidden = YES;
    [tableView endUpdates];
}

#pragma mark - Configure Core Data

-(NSFetchedResultsController *)fetchedResultController{
    if (_fetchedResultController != nil) {
        return _fetchedResultController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TimerModel" inManagedObjectContext:self.managedObjectContext];
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
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        TimerTableViewCell *cell = (TimerTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        TimerModel *timerModel = [self.fetchedResultController objectAtIndexPath:indexPath];
        cell.titleOfTimerLabel.text = timerModel.titleOfTimer;
        cell.durationTimeLabel.text = [NSString stringWithSeconds:timerModel.durationTime];
        if ([timerModel.lastUsedTime description]) {
            cell.lastUsedTime.text = [NSString stringWithFormat:@"上次使用 %@", [timerModel.lastUsedTime displayDateWithFormateInCurrentTimeZone]];
        }else{
            cell.lastUsedTime.text = @"尚未使用";
        }
    }

}

-(void)controllerDidChangeContent:(nonnull NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
    [self loadIndexPathForRunningTimerControllers];
    
    NSError *error;
    [self.managedObjectContext save:&error];
}




#pragma mark - Gesture Recognizer

-(void)respondToTimerButtonTapped:(UITapGestureRecognizer *)sender{
    if (self.editing) {
    }else{
        TimerButton *currentTimerButtonView = (TimerButton *)sender.view;
        TimerController *timerController = (TimerController *)currentTimerButtonView.relatedTimerController;
        
        switch (timerController.currentStatus) {
            case TimerPausing:
                [self resumeTimerForTimerController:timerController];
                break;
            case TimerStopped:
                [self createTimerForTimerController:timerController isRestored:NO];
                break;
            case TimerRunning:
                [self pauseTimerForTimerController:timerController];
                break;
            default:
                break;
        }
    }

}

#pragma mark - Timer

-(void)createTimerForTimerController: (TimerController *)timerController isRestored: (BOOL)restored{

    NSTimer *countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownForTimer:) userInfo:timerController repeats:YES];
    
    timerController.timer = countdownTimer;
    countdownTimer = nil;
    
    if (!restored) {
        timerController.currentStatus = TimerRunning;
        timerController.startedTime = [NSDate date];
        [self.runningTimerControllers addObject:timerController];
        [self loadIndexPathForRunningTimerControllers];
    }
    
    [[NSRunLoop currentRunLoop]addTimer:timerController.timer forMode:NSDefaultRunLoopMode];
    [timerController.timer fire];

}

-(void)countdownForTimer: (NSTimer *)sender{
    if (sender.valid) {
        TimerController *timerController = (TimerController *)sender.userInfo;
        if(timerController.remainingTime.doubleValue > 0){
            NSLog(@"running");
            NSNumber *oldNumer = timerController.remainingTime;
            timerController.remainingTime = [[NSNumber numberWithDouble:oldNumer.doubleValue - 1] copy];
            oldNumer = nil;
            
            TimerTableViewCell *currentCell = (TimerTableViewCell *)[self.tableView cellForRowAtIndexPath:[self.fetchedResultController indexPathForObject:timerController.relatedTimerModel]];
            currentCell.durationTimeLabel.text = [NSString stringWithSeconds:timerController.remainingTime];
        }else{

            [self stopTimerForTimerController:timerController andStopNormally:YES];
            
            NSString *alertMessage = [NSString stringWithFormat:@"%@完成", timerController.relatedTimerModel.titleOfTimer];
            UIAlertController *completionalert = [UIAlertController alertControllerWithTitle:@"计时器完成" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
            [completionalert addAction:okAlertAction];
            [self presentViewController:completionalert animated:YES completion:nil];

            
            
        }
    }
}

-(void)stopTimerForTimerController:(TimerController *)timerController andStopNormally: (BOOL)normal{
    TimerTableViewCell *currentCell = (TimerTableViewCell *)[self.tableView cellForRowAtIndexPath:timerController.indexPath];
    currentCell.durationTimeLabel.text = [NSString stringWithSeconds:timerController.durationTime];
    if (normal) {
        [timerController.relatedTimerModel setValue:[NSDate date] forKey:@"lastUsedTime"];
    }
    
    [timerController.timer invalidate];
    timerController.timer = nil;
    
    timerController.currentStatus = TimerStopped;
    timerController.remainingTime = timerController.durationTime;

    timerController.indexPath = nil;
    [self.runningTimerControllers removeObject:timerController];
}

-(void)pauseTimerForTimerController: (TimerController *)timerController{
    timerController.currentStatus = TimerPausing;
    [timerController.timer setFireDate:[NSDate distantFuture]];
}

-(void)resumeTimerForTimerController: (TimerController *)timerController{
    timerController.currentStatus = TimerRunning;
    timerController.startedTime = [NSDate date];
    [timerController.timer setFireDate:[NSDate distantPast]];
}


-(void)loadIndexPathForRunningTimerControllers{
    for (TimerController *timerController in self.runningTimerControllers) {
        timerController.indexPath = [[self.fetchedResultController indexPathForObject:timerController.relatedTimerModel] copy];
    }
}
@end
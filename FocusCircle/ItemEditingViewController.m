//
//  ItemEditingViewController.m
//  FocusCircle
//
//  Created by Liang Zhao on 15/6/15.
//  Copyright © 2015年 Liang Zhao. All rights reserved.
//

#import "ItemEditingViewController.h"

typedef enum timePicker{
    hours = 0,
    minutes,
    second
}TimeComponent;

@interface ItemEditingViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *durationTimePickerView;

@end

@implementation ItemEditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleTextField.text = self.titleOfItem;
    [self configurePickerView];
    [self configureNavigationBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureNavigationBar{
//    self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
    self.navigationItem.title = @"修改项目";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonTapped)];
}

- (IBAction)deleteButtonTapped:(id)sender {
    UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"删除项目" message:@"确认删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAlert = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self.managedObjectContext deleteObject:[self.fetchedResulesController objectAtIndexPath:self.indexPath]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deleteAlert addAction:cancelAlert];
    [deleteAlert addAction:confirmAlert];
    [self presentViewController:deleteAlert animated:YES completion:nil];
    
}



- (void)cancelButtonTapped{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTapped{
    NSTimeInterval secondsDuration = self.hours.doubleValue * 60 * 60 + self.minutes.doubleValue * 60 + self.seconds.doubleValue;
    
    if((![self.titleTextField.text isEqualToString:@""]) && (secondsDuration != 0)){
        
        NSNumber *dutation = [NSNumber numberWithDouble:secondsDuration]; //Convert NSTimeInterval to NSNumber
        
        [self updateDataWithTitle:self.titleTextField.text andDurationTime:dutation];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        
        UIAlertController *emptyAlert = [UIAlertController alertControllerWithTitle:@"输入为空" message:@"请输入有效值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [emptyAlert addAction:cancelAlert];
        [self presentViewController:emptyAlert animated:YES completion:nil];
        
    }
}


#pragma mark - Configure Picker View

-(void)configurePickerView{
    self.durationTimePickerView.showsSelectionIndicator = YES;
    [self setDefaultValue:self.hours.integerValue inComponent:hours];
    [self setDefaultValue:self.minutes.integerValue inComponent:minutes];
    [self setDefaultValue:self.seconds.integerValue inComponent:second];
}

-(void)setDefaultValue: (NSInteger)value inComponent:(TimeComponent)component{
    [self.durationTimePickerView selectRow:value inComponent:component animated:YES];
    [self pickerView:self.durationTimePickerView didSelectRow:value inComponent:component];
}

-(NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return 24;
            break;
        case 1:
            return 60;
            break;
        case 2:
            return 60;
            break;
            
        default:
            break;
    }
    
    return 0;
}

-(NSString *)pickerView:(nonnull UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%ld 小时", row];
            break;
        case 1:
            return [NSString stringWithFormat:@"%ld 分钟", row];
            break;
        case 2:
            return [NSString stringWithFormat:@"%ld 秒", row];
            break;
            
        default:
            break;
    }
    return nil;
}

-(CGFloat)pickerView:(nonnull UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

-(void)pickerView:(nonnull UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            self.hours = [NSNumber numberWithInteger:row];
            break;
        case 1:
            self.minutes = [NSNumber numberWithInteger:row];
            break;
        case 2:
            self.seconds = [NSNumber numberWithInteger:row];
            break;
            
        default:
            break;
    }
}

#pragma mark - Update Data in Core Data
-(void)updateDataWithTitle: (NSString *)titleOfItem andDurationTime: (NSNumber *)duration{
    ItemModel *itemModel = [self.fetchedResulesController objectAtIndexPath:self.indexPath];
    
    NSNumber *createdDate = [NSNumber numberWithDouble:[[NSDate date]timeIntervalSince1970]];
    
    [itemModel setValue:titleOfItem forKey:@"titleOfItem"];
    [itemModel setValue:duration forKey:@"duration"];
    [itemModel setValue:createdDate forKey:@"sortValue"];
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

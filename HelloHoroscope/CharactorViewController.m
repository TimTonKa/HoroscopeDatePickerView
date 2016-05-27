//
//  CharactorViewController.m
//  HelloHoroscope
//
//  Created by XueXin Tsai on 2016/5/12.
//  Copyright © 2016年 XueXin Tsai. All rights reserved.
//

#import "CharactorViewController.h"

@interface CharactorViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) NSArray * horoscopes;
@end

@implementation CharactorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 讀取 Plist 的資料
    // 首先取得 Plist 的路徑
    NSString * plistFilePath = [[NSBundle mainBundle] pathForResource:@"HoroscopesList" ofType:@"plist"];
    // 從該路徑讀取陣列，並指給上面的 property
    self.horoscopes = [[NSArray alloc] initWithContentsOfFile:plistFilePath];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.horoscopes.count;
    
    
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary * horoscope = self.horoscopes[row];
    NSString * chineseName = horoscope[@"chineseName"];
    return chineseName;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary * horoscope = self.horoscopes[row];
    NSString * charactorInfo = horoscope[@"description"];
    self.textView.text = charactorInfo;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

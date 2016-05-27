//
//  ViewController.m
//  HelloHoroscope
//
//  Created by XueXin Tsai on 2016/5/12.
//  Copyright © 2016年 XueXin Tsai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic,strong) NSArray * horoscopes;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 讀取 Plist 的資料
    // 首先取得 Plist 的路徑
    NSString * plistFilePath = [[NSBundle mainBundle] pathForResource:@"HoroscopesList" ofType:@"plist"];
    // 從該路徑讀取陣列，並指給上面的 property
    self.horoscopes = [[NSArray alloc] initWithContentsOfFile:plistFilePath];
}

-(NSDictionary*)horoscopeForBirthday:(NSDate*)birthday
{
    // 製作日曆，處理使用者丟進來的日期。將日期拆成數個單位，例如年份、月份、日期等等…
    NSCalendar * calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    // 利用日曆，將生日拆分成日期單位
    NSDateComponents * components = [calendar components:NSCalendarUnitYear  fromDate:birthday];
    
    // 拿到生日的年份  U--> Unsigned
    NSUInteger year = components.year;
    
    // 拿生日的年份合成各大星座的起始日與終止日
    // 準備 文字轉日期的格式器
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    __block NSDictionary * userHoroscope = nil;
    
    // 將陣列裡的每個星座取出，並在取出的星座起始日及截止日上加入 year
    [self.horoscopes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 陣列裡取出來的每個物件都會是 NSDictionary (星座)。
        NSDictionary * tempDictionary = (NSDictionary*)obj;
        
        // 將 Dictionary 中的起始日取出，並與 year 結合成一個新字串
        NSString * beginDateString = [NSString stringWithFormat:@"%li%@000000",year,[tempDictionary objectForKey:@"startDate"]];
        
        // 將上行人類才能看懂的時間字串，轉成電腦看得懂的，方便稍候進行時間的比較
        NSDate * beginDate = [formatter dateFromString:beginDateString];
        
        // 換處理結尾
        NSString * endDateString = [NSString stringWithFormat:@"%li%@235959",year,[tempDictionary objectForKey:@"endDate"]];
        NSDate * endDate = [formatter dateFromString:endDateString];
        
        BOOL result = [self date:birthday isBetween:beginDate andSecondDate:endDate];
        if (result) {
            //找到星座了
            userHoroscope = tempDictionary;
            *stop = YES;
        }
        
    }];
    
    return userHoroscope;
}

-(BOOL)date:(NSDate*)compareDate isBetween:(NSDate*)date1 andSecondDate:(NSDate*)date2
{
    /*
     date1 < compareDate < date2
     */
    //如果 compareDate 比 date1 早
    if ([compareDate compare:date1] == NSOrderedAscending) {
        return NO;
    }
    //如果 compareDate 比 date2 晚
    if ([compareDate compare:date2] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

- (IBAction)userChooseBirthday:(UIDatePicker *)sender {
    NSDate * date = sender.date;
    NSDictionary * dict = [self horoscopeForBirthday:date];
    NSString * name = dict[@"chineseName"];
    self.label.text = name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

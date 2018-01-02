//
//  FYLCityPickView.m
//

#import "FYLCityPickView.h"
#import "FYLCityModel.h"

#define kHeaderHeight 40

#define kPickViewHeight 220

#define kCancleBtnColor [UIColor colorWithRed:120/255.f green:120/255.f blue:120/255.f alpha:1.0]

#define THScreenW [UIScreen mainScreen].bounds.size.width

#define THScreenH [UIScreen mainScreen].bounds.size.height

#define THWParam [UIScreen mainScreen].bounds.size.width/375.0f

#define THfloat(a) a*THWParam


@interface FYLCityPickView()<UIPickerViewDataSource,UIPickerViewDelegate>


@property (nonatomic,strong)NSMutableArray *allProvinces;
/**
 *  省份对应的下标
 */
@property (nonatomic,assign)NSInteger rowOfProvince;
/**
 *  市对应的下标
 */
@property (nonatomic,assign)NSInteger rowOfCity;
/**
 *  区对应的下标
 */
@property (nonatomic,assign)NSInteger rowOfTown;


@end

@implementation FYLCityPickView

+ (FYLCityPickView *)showPickViewWithComplete:(FYLCityBlock)block withProvince:(NSString *)provinceStr withCity:(NSString *)city withTown:(NSString *)townStr withThreeScroll:(BOOL)threeScroll{
    
    return [self showPickViewWithDefaultProvince:provinceStr withCity:city withTown:townStr withThreeScroll:threeScroll complete:block];
}

+ (FYLCityPickView *)showPickViewWithDefaultProvince:(NSString *)province withCity:(NSString *)cityStr withTown:(NSString *)townStr withThreeScroll:(BOOL)threeScroll complete:(FYLCityBlock)block{

    scroll = threeScroll;

    CGFloat screenWitdth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    FYLCityPickView *pickView= [[FYLCityPickView alloc] initWithFrame:CGRectMake(0, 0, screenWitdth, screenHeight)];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:pickView];
    pickView.completeBlcok = block;
    
    if (province != nil) {
        
        NSInteger customProvince = [pickView rowOfProvinceWithName:province];
        
        if (customProvince != recordRowOfProvince) {
            recordRowOfProvince = [pickView rowOfProvinceWithName:province];
            recordRowOfCity = [pickView rowOfCityWithName:cityStr];
            if (townStr != nil){
                recordRowOfTown = [pickView rowOfTownWithName:townStr];
            }
        }
    }
    
    [pickView scrollToRow:recordRowOfProvince secondRow:recordRowOfCity thirdRow:recordRowOfTown];
    
    return pickView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        [self setupUI];
    }
    return self;
}

- (void)loadData{
    
    _allProvinces = [NSMutableArray array];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"FYLCity" ofType:@"plist"];
    
    NSArray *arrData = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSDictionary *dic in arrData) {
        ///此处用到底 "YYModel"  
        FYLProvince *provice = [FYLProvince yy_modelWithDictionary:dic];
        [_allProvinces addObject:provice];
    }
}

- (void)setupUI{
    
    CGFloat width = self.frame.size.width;
    
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    
    UIView *viewBg = [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-(kPickViewHeight+kHeaderHeight),width,kPickViewHeight+kHeaderHeight)];
    [viewBg setBackgroundColor:[UIColor whiteColor]];
    viewBg.layer.cornerRadius = 5;
    viewBg.layer.masksToBounds = YES;
    [self addSubview:viewBg];
    
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0,0, width,kHeaderHeight)];
    [viewHeader setBackgroundColor:[UIColor lightGrayColor]];
    [viewBg addSubview:viewHeader];
    
    UILabel *cancelButton = [[UILabel alloc]initWithFrame:CGRectMake(15,4, 200, 32)];
    cancelButton.text = @"请上下拖动列表以选择项目";
    cancelButton.textColor =kCancleBtnColor;
    cancelButton.font = [UIFont systemFontOfSize:THfloat(14)];
    [viewHeader addSubview:cancelButton];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureButton setFrame:CGRectMake(viewHeader.frame.size.width-60,4, 50, 32)];
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont systemFontOfSize:THfloat(18)];
    [sureButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureACtion:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:sureButton];
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,kHeaderHeight,width,kPickViewHeight)];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [viewBg addSubview:self.pickerView];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}

- (void)cancelAction:(UIButton *)btn{
    [self removeFromSuperview];
}
- (void)sureACtion:(UIButton *)btn{
    NSArray *arr = [self getChooseCityArr];
    if (self.completeBlcok != nil) {
        self.completeBlcok(arr);
    }
    [self removeFromSuperview];
}

#pragma mark - PickerView的数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (scroll == YES){
        return 3;
    }else{
        return 2;

    }
        
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    FYLProvince *province = self.allProvinces[self.rowOfProvince];
    FYLCity *city = province.city[self.rowOfCity];
    
    if (component == 0) {
        //返回省个数
        return self.allProvinces.count;
    }
    
    if (component == 1) {
        //返回市个数
        return province.city.count;
    }
    
    if (scroll == YES){
        if (component == 2) {
            //返回区个数
            return city.town.count;
        }
    }
    
    return 0;
    
}
#pragma mark - PickerView的代理方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *showTitleValue=@"";
    if (component==0){//省
        FYLProvince *province = self.allProvinces[row];
        showTitleValue = province.name;
    }
    if (component==1){//市
        FYLProvince *province = self.allProvinces[self.rowOfProvince];
        FYLCity *city = province.city[row];
        showTitleValue = city.name;
    }
    if (scroll == YES){
        if (component==2) {//区
            FYLProvince *province = self.allProvinces[self.rowOfProvince];
            FYLCity *city = province.city[self.rowOfCity];
            FYLTown *town = city.town[row];
            showTitleValue = town.name;
        }
    }
   
    return showTitleValue;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - 30) / 3,40)];
    label.textAlignment=NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

static NSInteger recordRowOfProvince = 0;//上海
static NSInteger recordRowOfCity;
static NSInteger recordRowOfTown;
static BOOL scroll;


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (component == 0) {
        self.rowOfProvince = recordRowOfProvince = row;
        self.rowOfCity = recordRowOfCity = 0;
        [pickerView reloadComponent:1];
        if (scroll == YES){
            [pickerView reloadComponent:2];
        }
        
    }
    else if(component == 1){
        self.rowOfCity = recordRowOfCity = row;
        if (scroll == YES){
            [pickerView reloadComponent:2];
        }
        
    }
    
     if (scroll == YES){
         if(component==2){
             self.rowOfTown = recordRowOfTown = row;
         }
     }
 
    
    if (self.autoGetData) {
        NSArray *arr = [self getChooseCityArr];
        if (self.completeBlcok != nil) {
            self.completeBlcok(arr);
        }
    }
    
}

#pragma mark - Tool
-(NSArray *)getChooseCityArr{
    NSArray *arr;
    
    if (self.rowOfProvince < self.allProvinces.count) {
        FYLProvince *province = self.allProvinces[self.rowOfProvince];
        if (self.rowOfCity < province.city.count) {
            FYLCity *city = province.city[self.rowOfCity];
            if (scroll == YES){
                if (self.rowOfTown < city.town.count) {
                    FYLTown *town = city.town[self.rowOfTown];
                    arr = @[province.name,city.name,town.name];
                }
            }else{
                arr = @[province.name,city.name];
            }
            
        }
    }
    return arr;
}


-(void)scrollToRow:(NSInteger)firstRow  secondRow:(NSInteger)secondRow thirdRow:(NSInteger)thirdRow{
    if (firstRow < self.allProvinces.count) {
        self.rowOfProvince = firstRow;
        FYLProvince *province = self.allProvinces[firstRow];
        if (secondRow < province.city.count) {
            self.rowOfCity = secondRow;
            [self.pickerView reloadComponent:1];
            
            if (scroll == YES){
                FYLCity *city = province.city[secondRow];
                
                if (thirdRow < city.town.count) {
                    self.rowOfTown = thirdRow;
                    [self.pickerView reloadComponent:2];
                    [self.pickerView selectRow:thirdRow inComponent:2 animated:YES];
                }
            }
            
            [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
            [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
           
        }
    }
    
    if (self.autoGetData) {
        NSArray *arr = [self getChooseCityArr];
        if (self.completeBlcok != nil) {
            self.completeBlcok(arr);
        }
    }
}
- (NSInteger)rowOfProvinceWithName:(NSString *)provinceName{
    
    NSInteger row = 0;
    for (FYLProvince *province in self.allProvinces) {
        if ([province.name containsString:provinceName]) {
            return row;
        }
        row++;
    }
    return row;
}

- (NSInteger)rowOfCityWithName:(NSString *)cityName{
    
    NSInteger row = 0;
    
    FYLProvince *province = self.allProvinces[recordRowOfProvince];
    
    for (FYLCity *city in province.city) {
        if ([city.name containsString:cityName]) {
            return row;
        }
        row++;
    }
    return row;
}

- (NSInteger)rowOfTownWithName:(NSString *)townName{
    
    NSInteger row = 0;
    
    FYLProvince *province = self.allProvinces[recordRowOfProvince];

    for (FYLCity *city in province.city) {
        FYLTown *town = city.town[self.rowOfTown];

        if ([town.name containsString:townName]) {
            return row;
        }
        row++;
    }
    return row;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end

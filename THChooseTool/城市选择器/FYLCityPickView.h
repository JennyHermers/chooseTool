//
//  FYLCityPickView.h
//  QinYueHui
//
//  Created by FuYunLei on 2017/4/14.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YYModel.h"

/**
 选择完成回调

 @param arr @[省,市,区]
 */
typedef void(^FYLCityBlock)(NSArray *arr);

@interface FYLCityPickView : UIView

@property (nonatomic,copy)FYLCityBlock completeBlcok;
@property (nonatomic,strong)UIPickerView *pickerView;

/**
 自动执行回调,默认为NO
 */
@property (nonatomic,assign)BOOL autoGetData;



///滚动到对应行
- (void)scrollToRow:(NSInteger)firstRow  secondRow:(NSInteger)secondRow thirdRow:(NSInteger)thirdRow;
///获取省份对应的row
- (NSInteger)rowOfProvinceWithName:(NSString *)provinceName;




/**
 弹出城市选择器

 @param block block
 @param provinceStr 默认显示的省
 @param city 默认显示的省
 @param townStr 默认显示的省
 @param threeScroll 是否是三级选择（no为二级选择，省市）
 @return self
 */
+ (FYLCityPickView *)showPickViewWithComplete:(FYLCityBlock)block withProvince:(NSString *)provinceStr withCity:(NSString *)city withTown:(NSString *)townStr withThreeScroll:(BOOL)threeScroll;

///弹出城市选择器,可指定默认选中省份,只有首次会生效
+ (FYLCityPickView *)showPickViewWithDefaultProvince:(NSString *)province withCity:(NSString *)cityStr withTown:(NSString *)townStr withThreeScroll:(BOOL)threeScroll complete:(FYLCityBlock)block;

@end

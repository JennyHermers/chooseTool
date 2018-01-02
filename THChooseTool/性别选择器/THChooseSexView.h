//
//  THChooseSexView.h
//  THChooseTool
//

#import <UIKit/UIKit.h>

@interface THChooseSexView : UIView


@property (nonatomic, copy) void(^buttonClick)(THChooseSexView *chooseSexView,NSInteger buttonIndex);


/**
 Description

 @param title 弹出框标题
 @param buttons 按钮列表
 @param block 选择项
 @return self
 */
- (id)initWithTitle:(NSString *)title buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(THChooseSexView *chooseSexView,NSInteger buttonIndex))block;


/**
 显示弹出框
 */
- (void)showView;

@end

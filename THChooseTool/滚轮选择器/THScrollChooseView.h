//
//  THScrollChooseView.h
//  THChooseTool


#import <UIKit/UIKit.h>

typedef void(^THScrollChooseViewBlock)(NSInteger selectedValue);

@interface THScrollChooseView : UIView

@property (strong, nonatomic) THScrollChooseViewBlock confirmBlock;


/**
 布局
 
 @param questionArray 问题数组
 @return self
 */
- (instancetype)initWithQuestionArray:(NSArray *)questionArray withDefaultDesc:(NSString *)defaultDesc;


- (void)showView;

@end

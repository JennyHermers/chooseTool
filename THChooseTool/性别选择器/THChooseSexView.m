//
//  THChooseSexView.m
//  THChooseTool


#import "THChooseSexView.h"

#define Margin  6
#define ButtonHeight  50
#define TitleHeight   50
#define LineHeight    0.5

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface THChooseSexView ()

@property (nonatomic, assign) CGFloat toolbarH;

@end
@implementation THChooseSexView

- (id)initWithTitle:(NSString *)title buttons:(NSArray<NSString *> *)buttons buttonClick:(void (^)(THChooseSexView *, NSInteger))block{
    
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _toolbarH = buttons.count*(ButtonHeight+LineHeight)+(buttons.count>1?Margin:0)+(title.length?TitleHeight:0);
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-_toolbarH, CGRectGetWidth(self.frame), _toolbarH)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        CGFloat buttonMinY = 0;
        
        if (title.length) {
            
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TitleHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = [UIColor lightGrayColor];
            label.text = title;
            [whiteView addSubview:label];
            buttonMinY = TitleHeight;
            
            UIView *line= [UIView new];
            line.backgroundColor = [UIColor grayColor];
            [whiteView addSubview:line];
            line.frame = CGRectMake(0, 49.5, CGRectGetWidth(self.frame), LineHeight);
        }
        
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.8];
            [button setTitle:obj forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
            button.tag = 101+idx;
            [button setEnabled:YES];
            
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (idx==buttons.count-1&&buttons.count>1) {
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx+Margin,CGRectGetWidth(self.frame),ButtonHeight};
            }else{
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(self.frame),ButtonHeight};
            }
            
            [whiteView addSubview:button];
            
            //分割线
            UIView *view= [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(self.frame), LineHeight)];
            view.backgroundColor = [UIColor grayColor];
            [whiteView addSubview:view];
            
            
        }];
        
        self.buttonClick = block;
        
    }
    
    
    return self;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}


- (void)buttonTouch:(UIButton *)button{
    
    if (self.buttonClick) {
        self.buttonClick(self, button.tag-101);
    }
    [self dismissView];
    
}


- (void)showView{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end

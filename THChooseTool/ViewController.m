//
//  ViewController.m
//  THChooseTool


#import "ViewController.h"
#import "THChooseSexView.h"
#import "THScrollChooseView.h"
#import "FYLCityPickView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titleArray = @[@"普通选择器",@"滚轮选择器",@"二级城市选择器"];
    
    for (int i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200+i*40+i*30, 200, 40)];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        [btn addTarget:self action:@selector(chooseValue:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.view addSubview:btn];
    }
    
    
}


- (void)chooseValue:(UIButton *)btn{
    
    NSLog(@"tag == %ld",(long)btn.tag);
    switch (btn.tag) {
            //普通样式的选择器
        case 0:
        {
            THChooseSexView *sheetView = [[THChooseSexView alloc]initWithTitle:@"性别修改" buttons:@[@"男",@"女",@"取消"] buttonClick:^(THChooseSexView *chooseSexView, NSInteger buttonIndex) {
                
                if (buttonIndex == 0){
                    [btn setTitle:@"男" forState:UIControlStateNormal];
                }else if (buttonIndex == 1){
                    [btn setTitle:@"女" forState:UIControlStateNormal];

                }
                
            }];
            [sheetView showView];
            
        }
            break;
        case 1:
            //滚轮样式的选择器
        {
            NSArray *questionArray = @[@"选项一",@"选项二",@"选项三",@"选项四",@"选项五",@"选项六",@"选项七"];
            THScrollChooseView *scrollChooseView = [[THScrollChooseView alloc] initWithQuestionArray:questionArray withDefaultDesc:@"选项三"];
            [scrollChooseView showView];
            scrollChooseView.confirmBlock = ^(NSInteger selectedQuestion) {
                
                [btn setTitle:questionArray[selectedQuestion] forState:UIControlStateNormal];

            };
            
        }
            break;
            
            case 2:
            //城市选择器
        {
            
           
            [FYLCityPickView showPickViewWithComplete:^(NSArray *arr) {
                
              NSString *str =  [self replaceUnicode:[NSString stringWithFormat:@"%@%@%@",arr[0],arr[1],arr[2]]];
                 [btn setTitle:str forState:UIControlStateNormal];
                
            } withProvince:@"安徽省" withCity:@"六安市" withTown:nil withThreeScroll:YES];
        }
            break;
        default:
            break;
    }
    
}


/**
 转码为中文

 @param TransformUnicodeString 转码前
 @return 转码后
 */
-(NSString*) replaceUnicode:(NSString*)TransformUnicodeString

{
    
    NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString*tepStr3 = [[@"\""  stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
    NSData*tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
    NSString*axiba = [NSPropertyListSerialization propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
    
    return  [axiba stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
    
}

    

@end

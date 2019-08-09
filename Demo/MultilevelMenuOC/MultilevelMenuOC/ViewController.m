//
//  ViewController.m
//  MultilevelMenuOC
//
//  Created by forwor on 2019/8/9.
//  Copyright © 2019 forwor. All rights reserved.
//

#import "ViewController.h"
#import "MultilevelMenuOC-Swift.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)testAction:(id)sender {
    NSMutableArray *dataSource = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"businessType" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *tempArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    for (NSDictionary *dic in tempArray) {
        //将字典数组转换成模型数组
        MenuDataModel *model = [[MenuDataModel alloc] initWithDict:dic];
        //将模型存入到属性中
        [dataSource addObject:model];
    }
    
    __weak typeof(self) weakSelf = self;
    MultilevelStyle1Menu *menu = [[MultilevelStyle1Menu alloc]initWithTitle:@"行业类型" dataSouce:dataSource option:nil customView:nil completion:^(NSString * text, MenuDataModel * model) {
        weakSelf.resultLabel.text = text;
    }];
    [menu show];
}

- (IBAction)customMenu:(id)sender {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"businessType" ofType:@"json"];
    NSURL *url = [NSURL fileURLWithPath:path];
    MultilevelMenuOption *option = [[MultilevelMenuOption alloc]init];
    option.rightBarButtonTitle = @"ok";
    option.rightBarButtonColor = [UIColor redColor];
    __weak typeof(self) weakSelf = self;
    MultilevelStyle2Menu *menu = [[MultilevelStyle2Menu alloc] initWithTitle:@"请选择行业类型" fileUrl:url option:option customView:nil completion:^(NSString * text, MenuDataModel * model) {
        weakSelf.resultLabel.text = text;
    }];
    [menu show];
                                                                                       
}
    

@end

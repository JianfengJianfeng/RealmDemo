//
//  ViewController.m
//  Realm
//
//  Created by 徐建峰 on 2018/6/20.
//  Copyright © 2018年 Jianfeng Xu. All rights reserved.
//

#import "ViewController.h"
#import <Realm.h>
#import "Dog.h"

@interface ViewController (){
    
    RLMRealm *_customRealm;
}

@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *sexText;
@property (weak, nonatomic) IBOutlet UITextField *ageText;
@property (weak, nonatomic) IBOutlet UITextField *weightText;


@property (nonatomic, strong) RLMResults *locArray;
@property (nonatomic, strong) RLMNotificationToken *token;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    可以使用默认的
    //    _customRealm = [RLMRealm defaultRealm];
    
    //自己创建一个新的RLMRealm
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathStr = paths.firstObject;
    //pathStr = /Users/JianfengXu/Library/Developer/CoreSimulator/Devices/65C5882D-FB2B-4DE0-BAA3-14D3B75203A4/data/Containers/Data/Application/60206BC2-5A60-42F3-B858-AC7FA0504DE4/Documents

    
    NSLog(@"pathStr = %@",pathStr);
    _customRealm = [RLMRealm realmWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",pathStr,@"dog.realm"]]];
}
//增
- (IBAction)addButtonAction:(id)sender {
    
    // 获取默认的 Realm 实例
    //    RLMRealm *realm = [RLMRealm defaultRealm];
    
    Dog *dog = [[Dog alloc] init];
    dog.name = self.nameText.text;
    dog.sex = self.sexText.text;
    dog.age = [self.ageText.text intValue];
    dog.weight = [self.weightText.text intValue];
    
    
    NSLog(@"name - %@ sex = %@ age = %d weight = %d",dog.name, dog.sex, dog.age, dog.weight);
    // 数据持久化
    [_customRealm transactionWithBlock:^{
        [self->_customRealm addObject:dog];
    }];
    // 通过事务将数据添加到 Realm 中
    //    [_customRealm beginWriteTransaction];
    //    [_customRealm addObject:dog];
    //    [_customRealm commitWriteTransaction];
    NSLog(@"增加成功啦");
    [self findButtonAction:nil];
}
//删
- (IBAction)deledateButtonAction:(id)sender {
    // 获取默认的 Realm 实例
    //    RLMRealm *realm = [RLMRealm defaultRealm];
    [_customRealm beginWriteTransaction];
    [_customRealm deleteAllObjects];
    [_customRealm commitWriteTransaction];
    [self findButtonAction:nil];
}
//改
- (IBAction)modifyButtonAction:(id)sender {
    
    for (Dog *dog in self.locArray) {
        NSLog(@"name - %@ sex = %@ age = %d weight = %d",dog.name, dog.sex, dog.age, dog.weight);
    }
    
    // 获取默认的 Realm 实例
    //    RLMRealm *realm = [RLMRealm defaultRealm];
    Dog *dog = self.locArray[0];
    [_customRealm beginWriteTransaction];
    dog.name = @"阿黄";
    [_customRealm commitWriteTransaction];
    
    NSLog(@"修改成功");
    for (Dog *dog in self.locArray) {
        NSLog(@"name - %@ sex = %@ age = %d weight = %d",dog.name, dog.sex, dog.age, dog.weight);
    }
    
}
//查
- (IBAction)findButtonAction:(id)sender {
    //自己创建一个新的RLMRealm
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathStr = paths.firstObject;
    NSLog(@"pathStr = %@",pathStr);
    
    // 查询指定的 Realm 数据库
    RLMRealm *dogRealm = [RLMRealm realmWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",pathStr,@"dog.realm"]]];
    // 获得一个指定的 Realm 数据库
    self.locArray = [Dog allObjectsInRealm:dogRealm]; // 从该 Realm 数据库中，检索所有model
    
    // 这是默认查询默认的realm
    //    self.locArray = [Dog allObjects];
    //查询所有元素个数
   // NSLog(@"self.locArray.count = %ld",self.locArray.count);
    
    // 根据年龄排序
//    self.locArray = [[Dog allObjectsInRealm:dogRealm] sortedResultsUsingKeyPath:@"age" ascending:YES];
//    NSLog(@"%@",self.locArray);
    
    
     //查找年龄大于3的
//    self.locArray = [[Dog allObjectsInRealm:dogRealm] objectsWhere:@"age > 3"];
//    NSLog(@"%@",self.locArray);
    
    //查找姓名为阿黄的狗
//    self.locArray = [[Dog allObjectsInRealm:dogRealm] objectsWhere:@"name BEGINSWITH '阿黄'"];
//    NSLog(@"%@",self.locArray);
    
  //  RLMResults *tanDogs = [Dog objectsWhere:@"color = '棕黄色' AND name BEGINSWITH '大'"];
    //查找姓名为阿黄并且年龄为5的狗
    self.locArray = [[Dog allObjectsInRealm:dogRealm] objectsWhere:@"name BEGINSWITH '阿黄' AND age = 5"];
    NSLog(@"%@",self.locArray);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

@end

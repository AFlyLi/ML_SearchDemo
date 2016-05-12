//
//  ViewController.m
//  搜索Demo
//
//  Created by 马文星 on 16/5/12.
//  Copyright © 2016年 Demos. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
#import "UserDTO.h"
#import "NSString+pinyin.h"
#import "UIView+Frame.h"


///屏幕宽高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

/** 我比较喜欢使用TextField 来充当searchbar使用 */
@property (weak, nonatomic) IBOutlet UITextField *searchBar;

/** tableview */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 存储模型的数组 */
@property (nonatomic, strong) NSMutableArray *storeUserDTOList;

/** 搜索数组 */
@property (nonatomic, strong) NSMutableArray *seachUserDTOList;

/** 是否在搜索状态 */
@property (nonatomic, assign) BOOL isSearchState;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupUI];
    [self loadData];
}

-(void)setupUI{
    
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

/** 监听 */
- (void)textChange:(NSNotification *)note{

    UITextField *textField = (UITextField *)[note object];

    //如果项目大，搜索的地方多，就要使用多线程，然后在刷新tableview的时候，回到主线程
    [self startSearch:textField.text];
}

//开始搜索
-(void)startSearch:(NSString *)string{
    
    if (self.seachUserDTOList.count>0) {
        
        [self.seachUserDTOList removeAllObjects];
    }

    //开始搜索
    NSString *key = string.lowercaseString;
    NSMutableArray *tempArr = [NSMutableArray array];
    
    // NSLog(@"key = %@",key);
    
    if (![key isEqualToString:@""] && ![key isEqual:[NSNull null]] && key != nil) {
        
        [self.storeUserDTOList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UserDTO *dto = self.storeUserDTOList[idx];
            
            //担心框架有时候会误转，再次都设置转为小写
            NSString *name = dto.name.lowercaseString;
            NSString *namePinyin = dto.namePinYin.lowercaseString;
            NSString *nameFireLetter = dto.nameFirstLetter.lowercaseString;
            
            NSRange rang1 = [name rangeOfString:key];
            if (rang1.length>0) { ///比牛 -比
                
                [tempArr addObject:dto];
            }else{
                
                if ([nameFireLetter containsString:key]) { //bn - b
                    
                    [tempArr addObject:dto];
                    
                }else{  //ershou
                    
                    if ([nameFireLetter containsString:[key substringToIndex:1]]) {
                        
                        if ([namePinyin containsString:key] ) {
                            [tempArr addObject:dto];
                        }
                    }
                }
            }
        }];
        
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![self.seachUserDTOList containsObject:tempArr[idx]]) {
                
                [self.seachUserDTOList addObject:tempArr[idx]];
            }
        }];
        
        //NSLog(@"self.searchResultList  = %@",self.seachUserDTOList);
        self.isSearchState = YES;
    }else{
    
        self.isSearchState = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark  - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    //如果想自定义更多，就把noResultLab 换成一个大的BJView，里面再填充很多个小的控件
    UILabel *noResultLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    noResultLab.font = [UIFont systemFontOfSize:20];
    noResultLab.textColor = [UIColor lightGrayColor];
    noResultLab.textAlignment = NSTextAlignmentCenter;
    noResultLab.hidden = YES;
    noResultLab.text = @"抱歉！没有搜索到相关数据";
    tableView.backgroundView = noResultLab;
    
    
    if (_isSearchState) {
        
        if (self.seachUserDTOList.count > 0) {
            
            noResultLab.hidden = YES;
            
            return self.seachUserDTOList.count;
            
        }else{
            
            noResultLab.hidden = NO;
            
            return 0;
        }
    }else{
    
        return self.storeUserDTOList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    UserDTO *dto = nil;
    
    if (_isSearchState) {
        
        dto = self.seachUserDTOList[indexPath.row];
    }else{
        
        dto = self.storeUserDTOList[indexPath.row];
    }
    
    cell.textLabel.text = dto.name;

    return cell;
}


/** 制造假数据 */
-(void)loadData{
    
    NSArray *nameArr = @[@"中国",@"上海",@"浦江",@"三鲁公路",@"传智播客",@"屌炸天",@"训练营",@"iOS2期",@"PanJinLian",@"三鲁公路1239号"];
    
    for (int i = 0; i < nameArr.count; ++i) {
        
        UserDTO *dto = [[UserDTO alloc] init];
        
        //转拼音
        NSString *PinYin =  [nameArr[i] transformToPinyin];
        
        //首字母
        NSString *FirstLetter = [nameArr[i] transformToPinyinFirstLetter];
       
//        NSLog(@"pinyin = %@ -- %@",PinYin,FirstLetter);
        
        dto.name = nameArr[i];
        dto.namePinYin = PinYin;
        dto.nameFirstLetter = FirstLetter;
        
        [self.storeUserDTOList addObject:dto];
    }
    
    [self.tableView reloadData];
}

#pragma mark  - Lazy
- (NSMutableArray *)storeUserDTOList{
    if (_storeUserDTOList == nil) {
        _storeUserDTOList = [[NSMutableArray alloc] init];
    }
    return _storeUserDTOList;
}

- (NSMutableArray *)seachUserDTOList{
    if (_seachUserDTOList == nil) {
        _seachUserDTOList = [[NSMutableArray alloc] init];
    }
    return _seachUserDTOList;
}


@end

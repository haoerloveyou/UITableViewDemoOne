//
//  ViewController.m
//  UITableViewDemoOne
//
//  Created by LHL on 16/5/5.
//
//

#import "ViewController.h"
#import "NewSearchViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
}
@property (nonatomic ,strong)UITableView *demoTableView;
@property (nonatomic ,strong)UISearchBar *searchBar;
@property (nonatomic ,strong)UISearchDisplayController *searchDC;
@property (nonatomic ,strong)NSMutableArray *exampleArr;
@property (nonatomic ,strong)NSMutableArray *searchArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _exampleArr = [NSMutableArray arrayWithCapacity:200];
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.demoTableView.frame = CGRectMake(0, rectStatus.size.height, self.view.frame.size.width, self.view.frame.size.height - rectStatus.size.height);
    self.searchBar.frame = CGRectMake(0, rectStatus.size.height, self.view.frame.size.width, 50.0);
    for (int i = 0; i < 200; i ++) {
        int NUMBER_OF_CHARS = 5;
        char data[NUMBER_OF_CHARS];//生成一个五位数的字符串
        for (int x=0;x<10;data[x++] = (char)('A' + (arc4random_uniform(26))));
        NSString *string = [[NSString alloc] initWithBytes:data length:5 encoding:NSUTF8StringEncoding];//随机给字符串赋值
        [_exampleArr addObject:string];
    }//随机生成200个五位数的字符串
    NSLog(@"%@",_exampleArr);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath//cell
{
    static NSString *identify = @"cellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (tableView == self.demoTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_exampleArr[indexPath.row]];

    }else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@",_searchArr[indexPath.row]];

    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDC.searchResultsTableView) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",_searchDC.searchBar.text];
        _searchArr =  [[NSMutableArray alloc] initWithArray:[_exampleArr filteredArrayUsingPredicate:predicate]];

        return self.searchArr.count;//搜索结果
    }else
    return self.exampleArr.count;//原始数据
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewSearchViewController *vc = [[NewSearchViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText != nil && searchText.length > 0)
    {
        self.searchArr = [NSMutableArray array];//这里可以说是清空tableview旧datasouce
        for (NSString *str in _exampleArr)
        {
            if ([str rangeOfString:searchText options:NSCaseInsensitiveSearch].length > 0)
            {
                [_searchArr addObject:str];
            }
        }
        [_demoTableView reloadData];
    }else
    {
        self.searchArr = [NSMutableArray arrayWithArray:_exampleArr];
        [_demoTableView reloadData];
    }
}

- (UITableView *)demoTableView
{
    if (!_demoTableView) {
        _demoTableView = [[UITableView alloc] init];
        _demoTableView.showsVerticalScrollIndicator = YES;
        _demoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _demoTableView.delegate = self;
        _demoTableView.dataSource = self;
        [self.view addSubview:_demoTableView];
    }
    return _demoTableView;
}
- (UISearchDisplayController *)searchDC
{
    if (!_searchDC) {
        _searchDC = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self];
        _searchDC.delegate = self;
        _searchDC.searchResultsDelegate = self;
        _searchDC.searchResultsDataSource = self;
    }
    return _searchDC;
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _demoTableView.tableHeaderView = _searchBar;
    }
    return _searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  AlbumViewController.m
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumTableCell.h"
#import "PhotosViewController.h"
@interface AlbumViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSArray *albumArray;
@end

@implementation AlbumViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.albumArray = [[PhotosImagesManager manager] getAllAlbumCompletion];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 1. PHAsset: 代表照片库中的一个资源, 跟ALAsset类似, 通过PHAsset可以获取保存资源和保存资源
    // 2. PHFetchOptions: 获取资源时的参数, 可以传nil, 表示一个相册或者一个时刻, 或者一个[智能相册(系统提供的特定的一系列的相册, 如:最近删除, 视频列表, 收藏等, )]
    // 3. PHFetchResult: 表示一系列的资源结果集合，也可以是相册的集合，从 PHCollection 的类方法中获得
    // 4. PHImageManager: 用于处理资源的加载，加载图片的过程带有缓存处理，可以通过传入一个 PHImageRequestOptions 控制资源的输出尺寸等规格
    // 5. PHImageRequestOptions: 如上面所说，控制加载图片时的一系列参数
    // 6. 这里还有一个额外的概念 PHCollectionList，表示一组 PHCollection，它本身也是一个 PHCollection，因此 PHCollection 作为一个集合，可以包含其他集合，这使到 PhotoKit 的组成比 ALAssetLibrary 要复杂一些。另外与 ALAssetLibrary 相似，一个 PHAsset 可以同时属于多个不同的 PHAssetCollection，最常见的例子就是刚刚拍摄的照片，至少同时属于“最近添加”、“相机胶卷”以及“照片 - 精选”这三个 PHAssetCollection
    
    self.albumArray = [[PhotosImagesManager manager] getAllAlbumCompletion];
    [self.view addSubview:self.table];

    // Do any additional setup after loading the view.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _albumArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlbumTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlbumTableCell"];
    cell.model = _albumArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    albumModel *model = _albumArray[indexPath.row];
    PhotosViewController *photoVC = [[PhotosViewController alloc] initWithPHFetchResult:model.result];
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (UITableView *)table {
    if (!_table) {
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = CGRectGetWidth(self.view.frame);
        CGFloat h = CGRectGetHeight(self.view.frame);
        _table = [[UITableView alloc] initWithFrame:CGRectMake(x, y, w, h) style:UITableViewStylePlain];
        UINib *nib = [UINib nibWithNibName:@"AlbumTableCell" bundle:[NSBundle mainBundle]];
        [_table registerNib:nib forCellReuseIdentifier:@"AlbumTableCell"];
        _table.rowHeight = 80;
        _table.delegate = self;
        _table.dataSource = self;
        _table.tableFooterView = [[UIView alloc] init];
    }
    return _table;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

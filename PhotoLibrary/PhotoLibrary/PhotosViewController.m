//
//  PhotosViewController.m
//  PhotoLibrary
//
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "PhotosViewController.h"
#import "CollectionViewCell.h"
@interface PhotosViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *PhotoCollectionView;
@property (nonatomic, strong) NSArray <PHAsset *> *phtotArray;
@property (nonatomic, strong) PHFetchResult *result
;

@end


@implementation PhotosViewController

- (instancetype)initWithPHFetchResult:(PHFetchResult *)result
{
    self = [super init];
    if (self) {
        
        self.result = result;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.phtotArray = [[PhotosImagesManager manager] getAssetsFromFetchResult:self.result];
    [self.view addSubview:self.PhotoCollectionView];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _phtotArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"c" forIndexPath:indexPath];
    cell.model = self.phtotArray[indexPath.row];
    return cell;
}

- (UICollectionView *)PhotoCollectionView {
    if (!_PhotoCollectionView) {
        CGFloat padding  = 5;
        CGFloat preWidth = (self.view.frame.size.width - padding * 5) / 4;
        UICollectionViewFlowLayout *collectionFlow = [[UICollectionViewFlowLayout alloc] init];
        collectionFlow.minimumLineSpacing = 5;
        collectionFlow.minimumInteritemSpacing = 5;
        collectionFlow.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectionFlow.itemSize = CGSizeMake(preWidth, preWidth);
        collectionFlow.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _PhotoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:collectionFlow];
        [_PhotoCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"c"];
        _PhotoCollectionView.delegate = self;
        _PhotoCollectionView.dataSource = self;        
    }
    return _PhotoCollectionView;
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

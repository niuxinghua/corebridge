//
//  ViewController.m
//  GoHaier
//
//  Created by niuxinghua on 2018/11/23.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "ViewController.h"
#import "HaierCoreWebView.h"
#import "H5Downloader.h"
#import "GHaierH5Context.h"
#import "PatchManager.h"
@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)HaierCoreWebView *webView;
@property(nonatomic,copy)NSString * patchUrl;
@property(nonatomic,copy)NSString * zipUrl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _webView = [[HaierCoreWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_webView];
    
    [self loadHtml];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleH5downLoad:) name:DidDownloadH5Success object:nil];
    
}

- (void)downLoadPatch
{
    _patchUrl = @"https://github.com/niuxinghua/GOHaierHTMLResource/blob/master/diff_GoHaier?raw=true";
     [[H5Downloader sharedInstance] downLoadZipFile:_patchUrl fileName:@"GoHaierPatch" unZipToPathwithVersion:@"v0.0.1"];
    
}
- (void)loadHtml
{
    if ([GHaierH5Context isExitResource:@"GoHaier" appVersion:@"v0.0.1PATCHVERSIONDIDAPPLY"]) {
        __weak ViewController *weakSelf = self;
        NSString *urlPath = [[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"];
        NSLog(@"%@",urlPath);
        NSString *indexhtml = [NSString stringWithFormat:@"%@/%@/demo.html",urlPath,@"GoHaier"];
        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
    }
   else if ([GHaierH5Context isExitResource:@"GoHaier" appVersion:@"v0.0.1"]) {
        __weak ViewController *weakSelf = self;
        NSString *urlPath = [[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"];
        NSLog(@"%@",urlPath);
        NSString *indexhtml = [NSString stringWithFormat:@"%@/demo.html",urlPath];
        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
        [self downLoadPatch];
    }
    else
    {
        _zipUrl = @"https://github.com/niuxinghua/GOHaierHTMLResource/blob/master/GoHaier.zip?raw=true";
        [[H5Downloader sharedInstance] downLoadZipFile:_zipUrl fileName:@"GoHaier" unZipToPathwithVersion:@"v0.0.1"];
    }
   
    
    
    
    //    NSString *onlineurl = @"http://10.138.40.223:8081/test/";
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"];
    //    NSURL* url = [NSURL  URLWithString:onlineurl];//创建URL
    //    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    //    [_webView loadRequest:request];
    
}

- (void)handleH5downLoad:(NSNotification *)notification
{
    if ([notification.object isEqualToString:_zipUrl]) {
        __weak ViewController *weakSelf = self;
        NSString *urlPath = [[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"];
        NSLog(@"%@",urlPath);
        NSString *indexhtml = [NSString stringWithFormat:@"%@/demo.html",urlPath];
        NSURL* url = [NSURL  URLWithString:indexhtml];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.webView loadRequest:request];
        });
        [self downLoadPatch];
    }
   if ([notification.object isEqualToString:_patchUrl])
   {
       dispatch_async(dispatch_get_main_queue(), ^{
           NSString *oldZip = [NSString stringWithFormat:@"%@/%@",[[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaier" versionName:@"v0.0.1"],@"GoHaier"];
             NSString *differPath = [NSString stringWithFormat:@"%@/%@",[[GHaierH5Context sharedContext] getBaseZipSavePath:@"GoHaierPatch" versionName:@"v0.0.1"],@"GoHaierPatch"];
            [[PatchManager sharedInstance] mergePatch:oldZip differFilePath:differPath appName:@"GoHaier" versionName:@"v0.0.1"];
           
       });
      
   }
}
@end

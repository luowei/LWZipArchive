//
//  CancelDelegate.m
//  ObjectiveCExample
//
//  Created by Antoine Cœur on 04/10/2017.
//

#import "CancelDelegate.h"

@implementation CancelDelegate
- (void)ssZipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo
{
    _numFilesUnzipped = (int)fileIndex + 1;
}
- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex totalFiles:(NSInteger)totalFiles archivePath:(NSString *)archivePath fileInfo:(unz_file_info)fileInfo
{
    //return YES;
    return _numFilesUnzipped < _numFilesToUnzip;
}
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath
{
    _didUnzipArchive = YES;
}
- (void)ssZipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total
{
    _loaded = (int)loaded;
    _total = (int)total;
}
@end

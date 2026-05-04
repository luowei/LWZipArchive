# Graph Report - /Users/luowei/projects/libs/LWZipArchive  (2026-05-04)

## Corpus Check
- 88 files · ~169,474 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 799 nodes · 1494 edges · 33 communities detected
- Extraction: 67% EXTRACTED · 33% INFERRED · 0% AMBIGUOUS · INFERRED: 488 edges (avg confidence: 0.8)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Community 0|Community 0]]
- [[_COMMUNITY_Community 1|Community 1]]
- [[_COMMUNITY_Community 2|Community 2]]
- [[_COMMUNITY_Community 3|Community 3]]
- [[_COMMUNITY_Community 4|Community 4]]
- [[_COMMUNITY_Community 5|Community 5]]
- [[_COMMUNITY_Community 6|Community 6]]
- [[_COMMUNITY_Community 7|Community 7]]
- [[_COMMUNITY_Community 8|Community 8]]
- [[_COMMUNITY_Community 9|Community 9]]
- [[_COMMUNITY_Community 10|Community 10]]
- [[_COMMUNITY_Community 11|Community 11]]
- [[_COMMUNITY_Community 12|Community 12]]
- [[_COMMUNITY_Community 13|Community 13]]
- [[_COMMUNITY_Community 14|Community 14]]
- [[_COMMUNITY_Community 15|Community 15]]
- [[_COMMUNITY_Community 16|Community 16]]
- [[_COMMUNITY_Community 17|Community 17]]
- [[_COMMUNITY_Community 18|Community 18]]
- [[_COMMUNITY_Community 19|Community 19]]
- [[_COMMUNITY_Community 20|Community 20]]
- [[_COMMUNITY_Community 21|Community 21]]
- [[_COMMUNITY_Community 22|Community 22]]
- [[_COMMUNITY_Community 23|Community 23]]
- [[_COMMUNITY_Community 24|Community 24]]
- [[_COMMUNITY_Community 25|Community 25]]
- [[_COMMUNITY_Community 26|Community 26]]
- [[_COMMUNITY_Community 27|Community 27]]
- [[_COMMUNITY_Community 28|Community 28]]
- [[_COMMUNITY_Community 29|Community 29]]
- [[_COMMUNITY_Community 30|Community 30]]
- [[_COMMUNITY_Community 31|Community 31]]
- [[_COMMUNITY_Community 32|Community 32]]

## God Nodes (most connected - your core abstractions)
1. `SSZipArchiveTests` - 34 edges
2. `mz_stream_seek()` - 30 edges
3. `mz_zip_entry_write_header()` - 22 edges
4. `mz_zip_recover_cd()` - 21 edges
5. `mz_zip_reader_entry_save_file()` - 21 edges
6. `mz_zip_entry_read_header()` - 20 edges
7. `mz_zip_entry_is_open()` - 20 edges
8. `mz_stream_tell()` - 20 edges
9. `mz_stream_read()` - 19 edges
10. `mz_stream_write()` - 19 edges

## Surprising Connections (you probably didn't know these)
- `mz_stream_pkcrypt_write()` --calls--> `mz_stream_write()`  [INFERRED]
  SSZipArchive/minizip/mz_strm_pkcrypt.c → SSZipArchive/minizip/mz_strm.c
- `mz_stream_pkcrypt_tell()` --calls--> `mz_stream_tell()`  [INFERRED]
  SSZipArchive/minizip/mz_strm_pkcrypt.c → SSZipArchive/minizip/mz_strm.c
- `mz_stream_pkcrypt_seek()` --calls--> `mz_stream_seek()`  [INFERRED]
  SSZipArchive/minizip/mz_strm_pkcrypt.c → SSZipArchive/minizip/mz_strm.c
- `mz_zip_entry_open_int()` --calls--> `mz_stream_zlib_create()`  [INFERRED]
  SSZipArchive/minizip/mz_zip.c → SSZipArchive/minizip/mz_strm_zlib.c
- `unzEndOfFile()` --calls--> `mz_zip_entry_get_info()`  [INFERRED]
  SSZipArchive/minizip/mz_compat.c → SSZipArchive/minizip/mz_zip.c

## Communities (57 total, 8 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (82): unzGetCurrentFileInfo(), unzGetCurrentFileInfo64(), zipOpenNewFileInZip5(), mz_stream_buffered_error(), mz_stream_close(), mz_stream_copy_stream_to_end(), mz_stream_copy_to_end(), mz_stream_error() (+74 more)

### Community 1 - "Community 1"
Cohesion: 0.05
Nodes (60): fill_memory_filefunc(), mz_crypt_sha_update(), mz_os_ms_time(), mz_stream_mem_create(), mz_stream_mem_delete(), mz_stream_mem_get_buffer(), mz_stream_mem_get_buffer_at(), mz_stream_mem_get_buffer_at_current() (+52 more)

### Community 2 - "Community 2"
Cohesion: 0.05
Nodes (67): fill_fopen64_filefunc(), fill_fopen_filefunc(), fill_win32_filefunc(), fill_win32_filefunc64(), fill_win32_filefunc64A(), fill_win32_filefunc64W(), unzClose(), unzCloseCurrentFile() (+59 more)

### Community 3 - "Community 3"
Cohesion: 0.07
Nodes (47): unzClose_MZ(), zipClose2_MZ(), zipClose_MZ(), mz_file_get_crc(), mz_stream_buffered_close(), mz_stream_buffered_create(), mz_stream_buffered_delete(), mz_stream_buffered_flush() (+39 more)

### Community 4 - "Community 4"
Cohesion: 0.05
Nodes (17): App, AsyncAwaitExamples, ZipViewModel, CompactZipView, ContentView, ContentView_Previews, ZipArchiveApp, ZipViewModel (+9 more)

### Community 5 - "Community 5"
Cohesion: 0.06
Nodes (6): SwiftSSZipArchiveExamples, ZipDelegate, SSZipArchiveDelegate, SSZipArchiveTests, TestDelegate, XCTestCase

### Community 6 - "Community 6"
Cohesion: 0.05
Nodes (37): NSData, -_base64RFC4648, -_hexString, NSString, -_sanitizedPath, SSZipArchive, -initNS_DESIGNATED_INITIALIZER, -close (+29 more)

### Community 7 - "Community 7"
Cohesion: 0.1
Nodes (31): mz_dir_make(), mz_path_append_slash(), mz_path_combine(), mz_path_compare_wc(), mz_path_convert_slashes(), mz_path_get_filename(), mz_path_remove_filename(), mz_path_remove_slash() (+23 more)

### Community 8 - "Community 8"
Cohesion: 0.06
Nodes (35): NSString, -_sanitizedPath, SSZipArchiveTests, -_cachesPath, -_calculateMD5Digest, -setUp, -tearDown, -testDirectoryZipping (+27 more)

### Community 9 - "Community 9"
Cohesion: 0.11
Nodes (10): mz_stream_raw_create(), mz_stream_pkcrypt_create(), mz_stream_pkcrypt_seek(), mz_stream_pkcrypt_set_password(), mz_stream_pkcrypt_set_verify(), mz_stream_pkcrypt_tell(), mz_stream_pkcrypt_write(), mz_stream_wzaes_set_encryption_mode() (+2 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (17): SSZipArchiveError, failedOpenFileInZip, failedOpenZipFile, failedToWriteFile, fileContentNotReadable, fileInfoNotLoadable, invalidArguments, Error (+9 more)

### Community 11 - "Community 11"
Cohesion: 0.15
Nodes (17): mz_crypt_aes_create(), mz_crypt_aes_delete(), mz_crypt_aes_reset(), mz_crypt_aes_set_decrypt_key(), mz_crypt_aes_set_encrypt_key(), mz_crypt_hmac_create(), mz_crypt_sha_begin(), mz_crypt_sha_create() (+9 more)

### Community 13 - "Community 13"
Cohesion: 0.12
Nodes (3): AnyObject, SSZipArchiveDelegate, SSZipArchiveDelegate

### Community 14 - "Community 14"
Cohesion: 0.17
Nodes (5): mz_stream_zlib_close(), mz_stream_zlib_create(), mz_stream_zlib_deflate(), mz_stream_zlib_flush(), mz_stream_zlib_write()

### Community 15 - "Community 15"
Cohesion: 0.16
Nodes (9): mz_crypt_aes_encrypt(), mz_crypt_hmac_end(), mz_crypt_hmac_update(), mz_stream_wzaes_close(), mz_stream_wzaes_ctr_encrypt(), mz_stream_wzaes_read(), mz_stream_wzaes_seek(), mz_stream_wzaes_tell() (+1 more)

### Community 20 - "Community 20"
Cohesion: 0.2
Nodes (3): AppDelegate, UIApplicationDelegate, UIResponder

### Community 21 - "Community 21"
Cohesion: 0.2
Nodes (9): unzReadCurrentFile(), zipWriteInFileInZip(), mz_crypt_rand(), mz_crypt_crc32_update(), mz_stream_pkcrypt_init_keys(), mz_stream_pkcrypt_open(), mz_stream_pkcrypt_update_keys(), mz_zip_entry_read() (+1 more)

### Community 22 - "Community 22"
Cohesion: 0.33
Nodes (3): SSZipArchive, UnzipProgress, ZipProgress

### Community 23 - "Community 23"
Cohesion: 0.22
Nodes (8): ViewController, -hasPassword, -resetPressed, -tempUnzipPath, -tempZipPath, -unzipPressed, -viewDidLoad, -zipPressed

### Community 24 - "Community 24"
Cohesion: 0.22
Nodes (8): ProgressDelegate, -init, -ssZipArchiveDidUnzipFileAtIndextotalFilesarchivePathfileInfo, -ssZipArchiveProgressEventtotal, -zipArchiveDidUnzipArchiveAtPathzipInfounzippedPath, -zipArchiveShouldUnzipFileAtIndextotalFilesarchivePathfileInfo, -zipArchiveWillUnzipArchiveAtPathzipInfo, -zipArchiveWillUnzipFileAtIndextotalFilesarchivePathfileInfo

### Community 25 - "Community 25"
Cohesion: 0.33
Nodes (9): mz_crypt_aes_set_mode(), mz_crypt_hmac_copy(), mz_crypt_hmac_delete(), mz_crypt_hmac_free(), mz_crypt_hmac_init(), mz_crypt_hmac_reset(), mz_crypt_hmac_set_algorithm(), mz_crypt_pbkdf2() (+1 more)

### Community 26 - "Community 26"
Cohesion: 0.25
Nodes (7): AppDelegate, -applicationDidBecomeActive, -applicationDidEnterBackground, -applicationdidFinishLaunchingWithOptions, -applicationWillEnterForeground, -applicationWillResignActive, -applicationWillTerminate

### Community 27 - "Community 27"
Cohesion: 0.33
Nodes (5): CancelDelegate, -ssZipArchiveDidUnzipFileAtIndextotalFilesarchivePathfileInfo, -ssZipArchiveProgressEventtotal, -zipArchiveDidUnzipArchiveAtPathzipInfounzippedPath, -zipArchiveShouldUnzipFileAtIndextotalFilesarchivePathfileInfo

### Community 31 - "Community 31"
Cohesion: 0.4
Nodes (3): NSApplicationDelegate, NSObject, AppDelegate

### Community 32 - "Community 32"
Cohesion: 0.5
Nodes (3): CollectingDelegate, -init, -ssZipArchiveDidUnzipFileAtIndextotalFilesarchivePathunzippedFilePath

## Knowledge Gaps
- **105 isolated node(s):** `failedOpenZipFile`, `failedOpenFileInZip`, `fileInfoNotLoadable`, `fileContentNotReadable`, `failedToWriteFile` (+100 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **8 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `mz_stream_write()` connect `Community 0` to `Community 1`, `Community 3`, `Community 9`, `Community 14`, `Community 15`, `Community 21`, `Community 25`?**
  _High betweenness centrality (0.026) - this node is a cross-community bridge._
- **Why does `mz_zip_entry_open_int()` connect `Community 9` to `Community 0`, `Community 3`, `Community 11`, `Community 14`?**
  _High betweenness centrality (0.021) - this node is a cross-community bridge._
- **Why does `mz_stream_seek()` connect `Community 0` to `Community 1`, `Community 2`, `Community 3`, `Community 9`, `Community 15`?**
  _High betweenness centrality (0.020) - this node is a cross-community bridge._
- **Are the 25 inferred relationships involving `mz_stream_seek()` (e.g. with `mz_stream_pkcrypt_seek()` and `mz_zip_search_eocd()`) actually correct?**
  _`mz_stream_seek()` has 25 INFERRED edges - model-reasoned connections that need verification._
- **Are the 13 inferred relationships involving `mz_zip_entry_write_header()` (e.g. with `mz_stream_mem_create()` and `mz_stream_mem_set_buffer()`) actually correct?**
  _`mz_zip_entry_write_header()` has 13 INFERRED edges - model-reasoned connections that need verification._
- **Are the 11 inferred relationships involving `mz_zip_recover_cd()` (e.g. with `mz_stream_set_prop_int64()` and `mz_stream_tell()`) actually correct?**
  _`mz_zip_recover_cd()` has 11 INFERRED edges - model-reasoned connections that need verification._
- **Are the 17 inferred relationships involving `mz_zip_reader_entry_save_file()` (e.g. with `mz_path_convert_slashes()` and `mz_path_remove_filename()`) actually correct?**
  _`mz_zip_reader_entry_save_file()` has 17 INFERRED edges - model-reasoned connections that need verification._
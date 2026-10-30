# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 424.7 mb | 754.8 mb | -330.1 mb |
| eight sites | 730.6 mb | 1145.3 mb | -414.7 mb |
| sixteen sites | 982.0 mb | 1447.8 mb | -465.8 mb |
| image decode | 633.2 mb | 1021.2 mb | -388.0 mb |
| image feed | 666.2 mb | 1036.5 mb | -370.3 mb |

cpu seconds per run 5.2, 9.8, 12.7, 11.0, 7.2 against 14.0, 18.8, 23.7, 16.8, 16.5

startup 50 ms against 511, idle cpu 1.28 per 30 s against 5.75

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

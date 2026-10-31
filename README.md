# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 386.8 mb | 754.8 mb | -368.0 mb |
| eight sites | 644.6 mb | 1145.3 mb | -500.7 mb |
| sixteen sites | 756.0 mb | 1447.8 mb | -691.8 mb |
| image decode | 567.1 mb | 1021.2 mb | -454.1 mb |
| image feed | 588.0 mb | 1036.5 mb | -448.5 mb |

cpu seconds per run 7.5, 13.6, 18.0, 12.2, 9.8 against 14.0, 18.8, 23.7, 16.8, 16.5

five heavy sites, youtube x reddit twitch cnn: 1893 mb and 55.2 cpu seconds in 13 processes against 3541 mb, 64.2 cpu seconds and 58 processes, normal sites share one web process while logged in and coop sites stay isolated

startup 72 ms against 511, idle cpu 0.36 per 30 s against 5.75

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

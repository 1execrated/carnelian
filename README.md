# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 432.6 mb | 754.8 mb | -322.2 mb |
| eight sites | 726.0 mb | 1145.3 mb | -419.3 mb |
| sixteen sites | 821.6 mb | 1447.8 mb | -626.2 mb |
| image decode | 623.6 mb | 1021.2 mb | -397.6 mb |
| image feed | 645.7 mb | 1036.5 mb | -390.8 mb |

cpu seconds per run 5.2, 10.8, 16.3, 13.5, 10.6 against 14.0, 18.8, 23.7, 16.8, 16.5

five heavy sites, youtube x reddit twitch cnn: 2003 mb and 56.8 cpu seconds in 14 processes against 3541 mb, 64.2 cpu seconds and 58 processes, normal sites share one web process while logged in and coop sites stay isolated

startup 96 ms against 511, idle cpu 0.37 per 30 s against 5.75

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

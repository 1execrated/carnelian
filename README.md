# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 423.4 mb | 754.8 mb | -331.4 mb |
| eight sites | 707.8 mb | 1145.3 mb | -437.5 mb |
| sixteen sites | 802.5 mb | 1447.8 mb | -645.3 mb |
| image decode | 624.6 mb | 1021.2 mb | -396.6 mb |
| image feed | 643.6 mb | 1036.5 mb | -392.9 mb |

cpu seconds per run 8.2, 15.4, 17.3, 12.6, 9.9 against 14.0, 18.8, 23.7, 16.8, 16.5

five heavy sites, youtube x reddit twitch cnn: 1919 mb and 52.3 cpu seconds in 14 processes against 3541 mb, 64.2 cpu seconds and 58 processes, normal sites share one web process while logged in and coop sites stay isolated

startup 84 ms against 511, idle cpu 0.36 per 30 s against 5.75

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

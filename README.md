# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 363.8 mb | 754.8 mb | -391.0 mb |
| eight sites | 654.4 mb | 1145.3 mb | -490.9 mb |
| sixteen sites | 747.8 mb | 1447.8 mb | -700.0 mb |
| image decode | 554.4 mb | 1021.2 mb | -466.8 mb |
| image feed | 586.4 mb | 1036.5 mb | -450.1 mb |

cpu seconds per run 6.4, 14.7, 17.6, 12.6, 9.5 against 14.0, 18.8, 23.7, 16.8, 16.5

five heavy sites, youtube x reddit twitch cnn: 1884 mb and 52.2 cpu seconds in 13 processes against 3541 mb, 64.2 cpu seconds and 58 processes, normal sites share one web process while logged in and coop sites stay isolated

startup 81 ms against 511, idle cpu 0.3 per 30 s against 5.75

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

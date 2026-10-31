# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 361.7 mb | 754.8 mb | -393.1 mb |
| eight sites | 565.4 mb | 1145.3 mb | -579.9 mb |
| sixteen sites | 670.8 mb | 1447.8 mb | -777.0 mb |
| image decode | 485.4 mb | 1021.2 mb | -535.8 mb |
| image feed | 499.8 mb | 1036.5 mb | -536.7 mb |

cpu seconds per run 7.2, 14.2, 16.7, 14.3, 9.4 against 14.0, 18.8, 23.7, 16.8, 16.5

five heavy sites, youtube x reddit twitch cnn: 1904 mb and 42.2 cpu seconds in 13 processes against 3541 mb, 64.2 cpu seconds and 58 processes, normal sites share four web processes while logged in and coop sites stay isolated

startup 82 ms against 511, idle cpu 0.31 per 30 s against 5.75

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

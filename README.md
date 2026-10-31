# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of two runs, same profile and pages, stock firefox 159 alongside

| workload | carnelian | stock | delta |
|---|---|---|---|
| blank window | 363.2 mb | 754.8 mb | -391.6 mb |
| eight sites | 499.8 mb | 1145.3 mb | -645.5 mb |
| sixteen sites | 576.2 mb | 1447.8 mb | -871.6 mb |
| image decode | 471.4 mb | 1021.2 mb | -549.8 mb |
| image feed | 494.6 mb | 1036.5 mb | -541.9 mb |

cpu seconds per run 4.4, 8.9, 9.8, 8.2, 6.5 against 14.0, 18.8, 23.7, 16.8, 16.5

five heavy sites, youtube x reddit twitch cnn: 1652 mb and 35.6 cpu seconds in 13 processes against 3541 mb, 64.2 cpu seconds and 58 processes, normal sites share four web processes while logged in and coop sites stay isolated

startup 81 ms against 511, idle cpu 0.1 per 30 s once settled, stock idles at 0.2 and spikes to 12 on update checks

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

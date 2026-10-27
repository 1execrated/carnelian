# carnelian

firefox fork for windows, low ram without cutting features, and quick

## numbers

private bytes, whole process tree, median of three runs, same profile and pages each time

| workload | before | after | delta |
|---|---|---|---|
| blank window | 594.8 mb | 506.2 mb | -88.6 mb |
| three tabs | 698.9 mb | 612.5 mb | -86.4 mb |
| js heavy page | 716.1 mb | 576.5 mb | -139.6 mb |

## build

mozconfig, then mach build

## releases

source tarballs with a sha256 alongside, tools/make_source_archive.sh so the same tag rebuilds to the same bytes

function play_tutorial($acc_name){
  $global:minms = 250
  $global:maxms = 450
  $sec_val = 0
  while($sec_val -lt 1){
    all_tuto_clks
    $sec_val = check_fb_connect
    start-sleep -s 10
  }
  write_acc_name $acc_name
}

function write_acc_name($name){
  click-screen 530 581
  click-screen 530 380
  click-screen 530 380
  click-screen 530 380
  start-sleep -s 1
  $delval
  while($delval -lt 12){
    click-screen 1012 1812
    $delval++
  }
  write-acc-name $name
  click-screen 528 797
  start-sleep -s 1
  click-screen 540 1590
}

function check_fb_connect(){
  $checkval = doOCR 1 "check" "obj_fb_connect"
  return $checkval
}

function all_tuto_clks(){
click-screen 929 1826
click-screen 836 1813
click-screen 497 963
click-screen 582 396
click-screen 352 956
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 805 1824
click-screen 777 931
click-screen 845 1822
click-screen 845 1824
click-screen 85 333
click-screen 784 721
click-screen 921 1834
click-screen 645 474
click-screen 575 1506
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 577 1527
click-screen 579 1531
click-screen 531 1009
click-screen 600 529
click-screen 287 992
click-screen 763 1843
click-screen 733 946
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 95 291
click-screen 794 760
click-screen 935 1845
click-screen 527 455
click-screen 556 1819
click-screen 832 1857
click-screen 472 870
click-screen 472 872
click-screen 474 876
click-screen 474 881
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 478 885
click-screen 382 500
click-screen 539 521
click-screen 537 521
click-screen 356 992
click-screen 721 883
click-screen 721 887
click-screen 721 893
click-screen 556 1299
click-screen 556 1299
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 556 1299
click-screen 556 1299
click-screen 556 1299
click-screen 556 1300
click-screen 87 278
click-screen 813 742
click-screen 493 443
click-screen 556 1580
click-screen 603 961
click-screen 540 756
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 306 942
click-screen 740 980
click-screen 758 942
click-screen 760 942
click-screen 78 247
click-screen 817 748
click-screen 346 464
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 615 1500
click-screen 537 1575
click-screen 571 1003
click-screen 548 1116
click-screen 525 1013
click-screen 459 982
click-screen 786 906
click-screen 83 344
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 880 744
click-screen 394 436
click-screen 594 1293
click-screen 535 1304
click-screen 470 1333
click-screen 565 447
click-screen 552 1832
click-screen 862 1845
click-screen 485 942
click-screen 346 455
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 380 1009
click-screen 790 1108
click-screen 106 331
click-screen 845 735
click-screen 790 1819
click-screen 430 483
click-screen 617 1542
click-screen 457 906
click-screen 459 910
click-screen 899 1826
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 455 550
click-screen 849 1805
click-screen 392 1078
click-screen 773 1794
click-screen 773 1796
click-screen 735 1813
click-screen 900 721
click-screen 99 335
click-screen 800 735
click-screen 908 1796
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 480 1493
click-screen 480 1499
click-screen 615 1177
click-screen 100 1807
click-screen 554 950
click-screen 960 1820
click-screen 556 961
click-screen 474 1285
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 916 1828
click-screen 916 1832
click-screen 916 1838
click-screen 916 1843
click-screen 916 1849
click-screen 916 1855
click-screen 845 1809
click-screen 906 1868
click-screen 857 1859
click-screen 780 1860
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 748 1775
click-screen 750 1775
click-screen 752 1779
click-screen 756 1780
click-screen 758 1786
click-screen 760 1790
click-screen 763 1792
click-screen 765 1796
click-screen 786 1817
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 483 1786
click-screen 860 1864
click-screen 323 297
click-screen 586 445
click-screen 857 1838
click-screen 1020 160
start-sleep -s 5
$adbArgList = @(
  "-s $global:adbname",
  "shell monkey -p com.plarium.vikings --throttle 200 --pct-touch 100 -v 2500"
)
run-prog-clk $global:adbpath $adbArgList
click-screen 182 339
click-screen 93 287
click-screen 815 748
click-screen 904 1819
click-screen 847 1801
}

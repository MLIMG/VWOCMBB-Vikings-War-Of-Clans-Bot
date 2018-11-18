function play_tutorial($acc_name){
  click-screen 555 1574
  start-sleep -s 3
  click-screen 555 1281
  start-sleep-prog 15 "Killing Plarium's T6..."
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
  while($delval -lt 20){
    click-screen 1012 1812
    $delval++
  }
  write-acc-name $name
  start-sleep -s 2
  click-screen 528 797 "tuto"
  start-sleep -s 2
  click-screen 540 1590 "tuto"
  start-sleep -s 2
  click-screen 530 1388 "tuto"
  start-sleep -s 2
  click-screen 530 1580 "tuto"
  start-sleep -s 2
  click-screen 870 1830 "tuto"
  start-sleep -s 2
  click-screen 681 1230 "tuto"
  start-sleep -s 2
  click-screen 870 1830 "tuto"
  start-sleep -s 2
}

function move_to_kd($params){
  map
  click-screen 80 290 "tuto"
  start-sleep-prog $global:smcd "open map"
  start-sleep-prog $global:smcd "open map"
  click-screen 180 123 "tuto"
  start-sleep -s 2
  click-screen 700 993 "tuto"
  start-sleep -s 2
  click-screen 700 810 "tuto"
  start-sleep -s 2
  write_number $params[0]
  hide_beyboard
  click-screen 715 1135 "tuto"
  start-sleep -s 1
  click-screen 520 870 "tuto"
  start-sleep -s 1
  click-screen 520 557 "tuto"
  start-sleep -s 1
  click-screen 518 1436 "tuto"
  start-sleep -s 1
  start-sleep-prog $global:smcd "open map"
  click-screen 436	136 "tuto"
  start-sleep -s 1
  click-screen 372	996 "tuto"
  start-sleep -s 1
  write_number $params[1]
  hide_beyboard
  click-screen 750	950 "tuto"
  start-sleep -s 1
  write_number $params[2]
  hide_beyboard
  click-screen 726	1160 "tuto"
  start-sleep -s 1
  click-screen 520	974 "tuto"
  start-sleep -s 1
  click-screen 716	1236 "tuto"
  start-sleep -s 1
  click-screen 372	1286 "tuto"
  start-sleep -s 1
  start-sleep-prog $global:smcd "open map"
  click-screen 688	1348 "tuto"
  start-sleep -s 1
  close-shop-window
}

function join_clan($params){
  click-screen 800 1830 "tuto"
  start-sleep -s 2
  click-screen 460 471 "tuto"
  start-sleep -s 2
  click-screen 460 471 "tuto"
  start-sleep -s 2
  click-screen 460 471 "tuto"
  start-sleep -s 2
  write_acc_name $params
  click-screen 930 456 "tuto"
  start-sleep -s 2
  click-screen 896 894 "tuto"
  start-sleep -s 2
}

function check_fb_connect(){
  $checkval = doOCR 1 "check" "obj_fb_connect"
  return $checkval
}

function add_to_mb($accname){
  $adbArgList = @(
    "-s $global:adbname",
    "shell monkey -p ch.easy_develope.vwocmb.vikingswarofclansmultibox -v 1"
  )
  run-prog $global:adbpath $adbArgList
  start-sleep-prog 10 "Kidnapping Plarium..."
  click-screen 1014 1852 "tuto"
  click-screen 540 960 "tuto"
  click-screen 540 816 "tuto"
  $adbArgList = @(
    "-s $global:adbname",
    'shell input text "'+$accname+'"'
  )
  run-prog $global:adbpath $adbArgList
  start-sleep -s 1
  click-screen 540 890 "tuto"
  Start-Sleep-Prog $global:vld "Reload ak 47 to headshot plarium"
  $adbArgList = @(
    "-s $global:adbname",
    "shell monkey -p ch.easy_develope.vwocmb.vikingswarofclansmultibox -v 1"
  )
  run-prog $global:adbpath $adbArgList
  start-sleep-prog 10 "Grind knife for plarium"
  $adbArgList = @(
    "-s $global:adbname",
    "shell input keyevent 3"
  )
  run-prog $global:adbpath $adbArgList
}

function all_tuto_clks(){
click-screen 929 1826 "tuto"
click-screen 836 1813 "tuto"
click-screen 497 963 "tuto"
click-screen 582 396 "tuto"
click-screen 352 956 "tuto"
click-screen 805 1824 "tuto"
click-screen 777 931 "tuto"
click-screen 845 1822 "tuto"
click-screen 845 1824 "tuto"
click-screen 85 333 "tuto"
click-screen 784 721 "tuto"
click-screen 921 1834 "tuto"
click-screen 645 474 "tuto"
click-screen 575 1506 "tuto"
click-screen 577 1527 "tuto"
click-screen 579 1531 "tuto"
click-screen 531 1009 "tuto"
click-screen 600 529 "tuto"
click-screen 287 992 "tuto"
click-screen 763 1843 "tuto"
click-screen 733 946 "tuto"
click-screen 95 291 "tuto"
click-screen 794 760 "tuto"
click-screen 935 1845 "tuto"
click-screen 527 455 "tuto"
click-screen 556 1819 "tuto"
click-screen 832 1857 "tuto"
click-screen 472 870 "tuto"
click-screen 472 872 "tuto"
click-screen 474 876 "tuto"
click-screen 474 881 "tuto"
click-screen 478 885 "tuto"
click-screen 382 500 "tuto"
click-screen 539 521 "tuto"
click-screen 537 521 "tuto"
click-screen 356 992 "tuto"
click-screen 721 883 "tuto"
click-screen 721 887 "tuto"
click-screen 721 893 "tuto"
click-screen 556 1299 "tuto"
click-screen 556 1299 "tuto"
click-screen 556 1299 "tuto"
click-screen 556 1299 "tuto"
click-screen 556 1299 "tuto"
click-screen 556 1300 "tuto"
click-screen 87 278 "tuto"
click-screen 813 742 "tuto"
click-screen 493 443 "tuto"
click-screen 556 1580 "tuto"
click-screen 603 961 "tuto"
click-screen 540 756 "tuto"
click-screen 306 942 "tuto"
click-screen 740 980 "tuto"
click-screen 758 942 "tuto"
click-screen 760 942 "tuto"
click-screen 78 247 "tuto"
click-screen 817 748 "tuto"
click-screen 346 464 "tuto"
click-screen 615 1500 "tuto"
click-screen 537 1575 "tuto"
click-screen 571 1003 "tuto"
click-screen 548 1116 "tuto"
click-screen 525 1013 "tuto"
click-screen 459 982 "tuto"
click-screen 786 906 "tuto"
click-screen 83 344 "tuto"
click-screen 880 744 "tuto"
click-screen 394 436 "tuto"
click-screen 594 1293 "tuto"
click-screen 535 1304 "tuto"
click-screen 470 1333 "tuto"
click-screen 565 447 "tuto"
click-screen 552 1832 "tuto"
click-screen 862 1845 "tuto"
click-screen 485 942 "tuto"
click-screen 346 455 "tuto"
click-screen 380 1009 "tuto"
click-screen 790 1108 "tuto"
click-screen 106 331 "tuto"
click-screen 845 735 "tuto"
click-screen 790 1819 "tuto"
click-screen 430 483 "tuto"
click-screen 617 1542 "tuto"
click-screen 457 906 "tuto"
click-screen 459 910 "tuto"
click-screen 899 1826 "tuto"
click-screen 455 550 "tuto"
click-screen 849 1805 "tuto"
click-screen 392 1078 "tuto"
click-screen 773 1794 "tuto"
click-screen 773 1796 "tuto"
click-screen 735 1813 "tuto"
click-screen 900 721 "tuto"
click-screen 99 335 "tuto"
click-screen 800 735 "tuto"
click-screen 908 1796 "tuto"
click-screen 480 1493 "tuto"
click-screen 480 1499 "tuto"
click-screen 615 1177 "tuto"
click-screen 100 1807 "tuto"
map
click-screen 554 950 "tuto"
click-screen 960 1820 "tuto"
click-screen 556 961 "tuto"
click-screen 474 1285 "tuto"
click-screen 916 1828 "tuto"
click-screen 916 1832 "tuto"
start-sleep -s 20
click-screen 916 1838 "tuto"
city
click-screen 916 1843 "tuto"
click-screen 916 1849 "tuto"
click-screen 916 1855 "tuto"
click-screen 845 1809 "tuto"
click-screen 906 1868 "tuto"
click-screen 857 1859 "tuto"
click-screen 780 1860 "tuto"
click-screen 748 1775 "tuto"
click-screen 750 1775 "tuto"
click-screen 752 1779 "tuto"
click-screen 756 1780 "tuto"
#unknown
click-screen 758 1786 "tuto"
click-screen 760 1790 "tuto"
click-screen 763 1792 "tuto"
click-screen 765 1796 "tuto"
click-screen 786 1817 "tuto"
click-screen 483 1786 "tuto"
click-screen 860 1864 "tuto"
click-screen 323 297 "tuto"
click-screen 586 445 "tuto"
click-screen 857 1838 "tuto"
click-screen 1020 160 "tuto"
click-screen 182 339 "tuto"
click-screen 93 287 "tuto"
click-screen 815 748 "tuto"
click-screen 904 1819 "tuto"
click-screen 847 1801 "tuto"
}

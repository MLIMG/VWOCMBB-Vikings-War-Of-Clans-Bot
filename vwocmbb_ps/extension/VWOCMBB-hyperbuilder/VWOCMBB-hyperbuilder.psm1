#BTC
$global:hybutype = ""
#param 1 type
function hyperbuilder([array]$params){
  $global:whereami = "hyperbuilder"
  foreach($param_arr in $params){
    [array]$param_arr = $param_arr.Split(",")
    $global:hybutype = $param_arr[0]
    $hy_p = $param_arr[1]
    $hy_mp = $param_arr[2]
    if($global:hybutype -eq "silver"){
      if($hy_p -eq "p0"){
        bot_notify "Stay on P position"
      }
      if($hy_p -eq "p1"){
        start-sleep -s 2
        map
        city
        $scroll_arg = @("-s $global:adbname","shell input swipe 500 1000 500 600 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 600 500 1000 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 600 500 1000 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
      }
      if($hy_p -eq "p2"){
        start-sleep -s 2
        map
        city
        $scroll_arg = @("-s $global:adbname","shell input swipe 600 500 1000 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 500 1000 500 600 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
      }
      if($hy_p -eq "p3"){
        start-sleep -s 2
        map
        city
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 500 600 500 1000 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
      }
      foreach($mp_pos in $param_arr){
        if($mp_pos -eq "mp1"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 65 1184
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 65 1184
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp2"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 145 1554
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 145 1554
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp3"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 330 1004
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 330 1004
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp4"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 359 1339
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 359 1339
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp5"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 558 912
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 558 912
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp6"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 501 1190
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 501 1190
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp7"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 556 1520
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 556 1520
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp8"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 950 1063
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 950 1063
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp9"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 850 1324
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 850 1324
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp10"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 553 752
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 553 752
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp11"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 852 921
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 852 921
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp12"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 995 1185
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 995 1185
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp13"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 854 1383
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 854 1383
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp14"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 91 1211
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 91 1211
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp15"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 357 1385
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 357 1385
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp16"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 369 1107
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 369 1107
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp18"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 526 1239
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 526 1239
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp18"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 524 852
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 524 852
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp19"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 773 716
          Start-Sleep -m 1500
          click-screen 137 547
          Start-Sleep -m 1500
          click-screen 773 716
          Start-Sleep -m 1500
          ai_builder
        }
      }
    } else {
      if($global:hybutype -eq "food"){
        [int]$pr_x = 123
        [int]$pr_y = 325
      }
      if($global:hybutype -eq "wood"){
        [int]$pr_x = 123
        [int]$pr_y = 545
      }
      if($global:hybutype -eq "stone"){
        [int]$pr_x = 123
        [int]$pr_y = 771
      }
      if($global:hybutype -eq "iron"){
        [int]$pr_x = 123
        [int]$pr_y = 979
      }
      if($hy_p -eq "p0"){
        bot_notify "Stay on P position"
      }
      if($hy_p -eq "p1"){
        start-sleep -s 2
        map
        city
        $scroll_arg = @("-s $global:adbname","shell input swipe 500 1000 500 600 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 500 1000 500 600 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
      }
      if($hy_p -eq "p2"){
        start-sleep -s 2
        map
        city
        $scroll_arg = @("-s $global:adbname","shell input swipe 500 600 500 700 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
        $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 600 500 5000")
        Start-Sleep -m 500
        run-prog $global:adbpath $scroll_arg
        Start-Sleep -m 500
      }
      foreach($mp_pos in $param_arr){
        if($mp_pos -eq "mp1"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 193 840
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 193 840
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp2"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 400 968
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 400 968
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp3"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 560 1083
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 560 1083
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp4"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 460 786
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 460 786
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp5"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 644 922
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 644 922
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp6"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 884 1051
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 884 1051
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp7"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 531 569
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 531 569
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp8"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 744 709
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 744 709
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp9"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 966 851
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 966 851
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp10"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 596 379
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 596 379
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp11"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 780 475
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 780 475
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp12"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 441 1532
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 441 1532
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp13"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 700 1626
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 700 1626
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp14"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 535 1331
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 535 1331
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp15"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 780 1425
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 780 1425
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp16"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 184 1008
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 184 1008
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp18"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 443 1070
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 443 1070
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp18"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 656 1189
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 656 1189
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp19"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 211 732
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 211 732
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp20"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 354 820
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 354 820
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp21"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 550 918
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 550 918
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp22"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 813 1041
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 813 1041
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp23"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 345 556
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 345 556
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp24"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 588 657
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 588 657
          Start-Sleep -m 1500
          ai_builder
        }
        if($mp_pos -eq "mp25"){
          if((doOCR 1 "check" "hide_progress") -eq 1){
            doOCR 0 "single" "hide_progress"
            $fail_clk = 0
          }
          click-screen 813 772
          Start-Sleep -m 1500
          click-screen $pr_x $pr_y
          Start-Sleep -m 1500
          click-screen 813 772
          Start-Sleep -m 1500
          ai_builder
        }
      }
    }
  }
}

function ai_builder{
  start-sleep -m 2500
  $maxfails = 18
  $maxgoldscroll = 4
  $goldscrolled = 1
  $maxprogscroll = 2
  $progscrolled = 1
  [int]$fail_clk = 0
  $do_count = 0
  $check_count = 0
  $bo_val = 0
  $he_val = 0
  [array]$obj_array = @("btn_no","btc_build_free","free_2","free_1","build_free","btc_goto","build_3","build_1","help_1","btc_build_help","faster_1","btn_use","btn_faster","btc_faster","build_rss")
  do{
    reconnect_device
    if((doOCR 1 "pixel-check" "no_food_obj") -eq 1 -or (doOCR 0 "pixel-check" "break_rss_booster_use") -eq 1){
      $fail_clk = 18
      break
    } else {
    [string]$ai_name = "ai_builder"+$global:hybutype+$do_count
    if((doOCR 0 "pixel-check" "obj_castle_cancel") -eq 1){
      $fail_clk = 15
      break
    } else {
      if($bo_val -le 3){
        if((doOCR 1 "check" "boost_other") -eq 1){
          doOCR 0 "single" "boost_other"
          $fail_clk = 0
        }
        if((doOCR 0 "check" "help_other") -eq 1){
          doOCR 0 "single" "help_other"
          $fail_clk = 0
        }
        $bo_val++
      }
      if((doOCR 1 "check" "btn_use") -eq 1){
        $btn_use_visable = 1
        while($btn_use_visable -eq 1){
          $ai_name = $ai_name+"obj_btn_use-eq1"
          doOCR 1 "single-long" "btn_use"
          start-sleep -m 600
          click-screen 691 1025
          start-sleep -m 600
          click-screen 290 1842
          start-sleep -m 2000
          $btn_use_visable = doOCR 1 "check" "btn_use"
          if($progscrolled -lt $maxprogscroll){
            $ai_name = $ai_name+"progscrolled"
            if((doOCR 1 "pixel-check" "obj_boost_prog") -eq 1){
              $ai_name = $ai_name+"obj_boost_prog-eq1"
              $scroll_arg = @("-s $global:adbname","shell input swipe 500 550 500 300 2000")
              Start-Sleep -m 1500
              run-prog $global:adbpath $scroll_arg
              start-sleep -m 1500
              $fail_clk = 0
              $progscrolled++
            }
          }
        }
      } else {
        $ai_name = $ai_name+"obj_btn_use-eq0"
        if((doOCR 1 "check" "help_1") -eq 1){
          doOCR 0 "single" "help_1"
          $ai_name = $ai_name+"help_1-eq1"
          $goldscrolled = 0
          $progscrolled = 0
        }
        if((doOCR 1 "pixel-check" "close_top_right") -eq 0){
          $ai_name = $ai_name+"close-eq0"
          $fail_clk = 18
          doOCR 1 "single" "close"
          break
        }
        $ocr_val = 1
        $arrcount = 0
        $fail_clk = doOCR 1 "pixel" "btc_loop"
        if((doOCR 1 "pixel-check" "no_food_obj") -eq 1 -or (doOCR 0 "pixel-check" "break_rss_booster_use") -eq 1){
          $fail_clk = 18
          break
        }
        if($goldscrolled -lt $maxgoldscroll){
          $ai_name = $ai_name+"goldscrolled"
          $while_scroll_gold = 1
          while($while_scroll_gold -eq 1){
            if($goldscrolled -lt $maxgoldscroll){
            if((doOCR 1 "check" "obj_boost_gold") -eq 1){
              $ai_name = $ai_name+"obj_boost_gold-eq1"
              $scroll_arg = @("-s $global:adbname","shell input swipe 500 550 500 300 2000")
              Start-Sleep -m 500
              run-prog $global:adbpath $scroll_arg
              start-sleep -m 600
              $fail_clk = 0
              $goldscrolled++
            } else {
              $while_scroll_gold = 0
            }
          } else {
            $while_scroll_gold = 0
          }
        }
        }
        write-host "Failclicks are: $fail_clk"
        start-sleep -m 600
        if($fail_clk -ge $maxfails){
          $ai_name = $ai_name+"fail_clk-gemaxfails"
          doOCR 1 "single" "close"
          break
        }
      }
    }
  }
    $check_count++
    $do_count++
  }until($fail_clk -ge 18)
  $ai_name = $ai_name+"fail_clk-gemaxfails"
  start-sleep -m 600
  doOCR 1 "single" "close"
}

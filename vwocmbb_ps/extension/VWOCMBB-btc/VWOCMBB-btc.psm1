#BTC
function buildthecity([array]$params){
  $global:whereami = "buildthecity"
  #security Value
  if($params[0] -eq "t"){
    bot_notify "Build up Castle"
    #move view to perfect position
    scrolldown
    scrollright
    start-sleep -s 1
    #click on castle
    click-screen 1035 1075
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
    while($fail_clk -le 18){
      if((doOCR 1 "pixel-check" "no_food_obj") -eq 1 -or (doOCR 0 "pixel-check" "break_rss_booster_use") -eq 1){
        $fail_clk = 18
        break
      } else {
      [string]$ai_name = "buildthecity"+$do_count
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
          $fail_clk = 0
          start-sleep -m 600
          click-screen 540 960
          start-sleep -m 600
          $ocr_val = 1
          $arrcount = 0
          $fail_clk = doOCR 1 "pixel" "btc_loop"
          if((doOCR 1 "pixel-check" "no_food_obj") -eq 1 -or (doOCR 0 "pixel-check" "break_rss_booster_use") -eq 1){
            $fail_clk = 18
            break
          }
          start-sleep -m 600
          scrolldown
          scrolldown
          scrollright
          scrollright
          start-sleep -s 1
          #click on castle
          click-screen 1035 1075
          start-sleep -m 600
          $fail_clk = 0
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
      $check_count++
      $do_count++
    }
    $ai_name = $ai_name+"fail_clk-gemaxfails"
    doOCR 1 "single" "close"
  }
}

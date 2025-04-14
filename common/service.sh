#!/system/bin/sh
# 由於 Magisk 未必會固定掛載路徑，建議使用 $MODDIR
# 取得目前模組所在的資料夾位置
MODDIR=${0%/*}

# ============================================================================
# 函數：maintain_adb
# 說明：不斷檢查並維持 ADB TCP 功能在 5555 連接埠運行
# ============================================================================
maintain_adb() {
    while true
    do
        # 1) 如果 service.adb.tcp.port 不是 5555，就重設並重新啟動 adbd
        if [ "$(getprop service.adb.tcp.port)" != "5555" ]; then
            setprop service.adb.tcp.port 5555
            stop adbd
            # 視裝置需要可適度縮短或拉長這個 sleep
            sleep 1
            start adbd
        else
            # 2) 如果 adbd 沒有在運行，則啟動它
            if ! pgrep -x "adbd" >/dev/null 2>&1; then
                start adbd
            fi
        fi
        
        # 等待 120 秒後再檢查一次
        sleep 120
    done
}

# ============================================================================
# 主程序：等待系統開機完成後，再開始執行 maintain_adb
# ============================================================================
(
    # 等待系統開機完成
    until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
        sleep 10
    done
    
    # 開始維持 ADB TCP 連線
    maintain_adb
) &

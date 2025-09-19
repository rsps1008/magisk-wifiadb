#!/system/bin/sh

MODDIR=${0%/*}

# ============================================================================
# 主邏輯：按下 Magisk 模組「執行按鈕」時觸發
# ============================================================================
PORT=$(getprop service.adb.tcp.port)
if [ "$PORT" != "5555" ]; then
    echo "⚙️ 設定 ADB TCP 埠為 5555"
    setprop service.adb.tcp.port 5555
    echo "🔁 adbd 重啟中..."
    stop adbd
    sleep 2
    start adbd
    echo "🚀 ADB over Wi-Fi 已啟動"
else
    if ! pgrep -x "adbd" >/dev/null 2>&1; then
        echo "🔁 adbd 沒在跑，啟動中..."
        start adbd
    else
        echo "✅ ADB TCP 已啟動且 adbd 正常執行中"
    fi
fi

echo
echo "✅ 操作完成"
sleep 2
exit 0

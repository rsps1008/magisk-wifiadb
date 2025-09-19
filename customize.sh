#!/system/bin/sh

# 如果你不需要預設安裝流程，可啟用這行
# SKIPUNZIP=1

# 環境變數 MODPATH 指向模組安裝目錄
ui_print "⚙️ 設定 action.sh 執行權限..."

set_perm "${MODPATH}/action.sh" 0 0 0755

ui_print "✅ 權限設定完成"

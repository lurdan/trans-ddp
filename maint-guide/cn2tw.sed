# Run this after opencc autoconversion, sed script shoule be run in this order:
# doc content substitution
s/簡體/繁體/g
s/maint-guide-zh-cn/maint-guide-zh-tw/g
# idiom conversion
# Left:  string auto-converted from zh_CN to zh_TW with opencc
# Right: better string to use under zh_TW
s/軟件/軟體/g
s/軟體包/套件/g
s/文件/檔案/g
s/文檔/文件/g
s/示例/範例/g
s/程序/程式/g
s/解釋型/解譯型/g
s/配置/設定/g
s/數字簽名/數位簽章/g
s/源代碼/原始碼/g
s/刷新/更新/g
s/參看/參考/g
s/操作系統/作業系統/g
s/信息/訊息/g
s/源代碼包/原始碼套件/g
s/二進制包/二進位套件/g
s/代碼/程式碼/g
s/社區/社群/g
s/分發/散佈/g
s/二進制/二進位/g
s/主頁/首頁/g
s/擴展名/副檔名/g
s/歸檔檔案/壓縮檔/g
s/解包/解壓縮/g
s/屏幕/螢幕/g
s/自檢/自身測試/g
s/卸載/反安裝/g
s/老板本/舊版本/g
s/下劃綫/底線/g
s/內核模塊/核心模組/g
s/內核補丁/核心補丁/g
s/圖標/圖示/g


#!/bin/bash

# foo11e.sh

logfile="/tmp/terminal_tab_debug.log"
> "$logfile"  # ログ初期化

# === タイトル一覧取得・表示・選択 ===
titles=$(osascript <<EOF
tell application "Terminal"
    set output to ""
    repeat with w in windows
        repeat with t in tabs of w
            try
                set titleStr to (custom title of t as text)
                if titleStr is "" then
                    set output to output & "()\n"
                else
                    set output to output & titleStr & linefeed
                end if
            end try
        end repeat
    end repeat
    return output
end tell
EOF
)

echo "=== 開いているタブ一覧 ==="
i=1
valid_titles=()
while IFS= read -r line; do
    if [[ "$line" != "(empty)" && "$line" != "()" && -n "$line" ]]; then
        echo "$i) $line"
        valid_titles+=("$line")
        ((i++))
    fi
done <<< "$titles"

if (( ${#valid_titles[@]} == 0 )); then
    echo "有効なタブがありません。"
    exit 1
fi

printf "番号を選んでください: "
read -r choice

if ! [[ "$choice" =~ ^[0-9]+$ ]] || (( choice < 1 || choice > ${#valid_titles[@]} )); then
    echo "無効な番号です。"
    exit 1
fi

selected_title="${valid_titles[$((choice-1))]}"
echo "選ばれたタブタイトル: $selected_title"

tmpfile="/tmp/selected_title.$$"
echo "$selected_title" > "$tmpfile"

# === AppleScript 部分（安全なログ出力付き）===
osascript <<EOF
tell application "Terminal"
    set found to false
    set titlefile to POSIX file "$tmpfile"
    set selectedTitle to paragraphs of (read titlefile as «class utf8»)
    set logfile to POSIX path of "$logfile"

    repeat with w in windows
        repeat with t in tabs of w
            try
                set titleStr to (custom title of t as text)

                do shell script "printf %s\\\\n " & quoted form of ("titleStr(raw): " & titleStr) & " >> " & quoted form of logfile
                do shell script "printf %s\\\\n " & quoted form of ("selectedTitle(raw): " & item 1 of selectedTitle) & " >> " & quoted form of logfile

                set cleanTitleStr to do shell script "printf %s " & quoted form of titleStr & " | awk '{\$1=\$1; print}'"
                set cleanSelectedTitle to do shell script "printf %s " & quoted form of (item 1 of selectedTitle) & " | awk '{\$1=\$1; print}'"

                do shell script "printf %s\\\\n " & quoted form of ("cleanTitle: " & cleanTitleStr) & " >> " & quoted form of logfile
                do shell script "printf %s\\\\n " & quoted form of ("cleanSelected: " & cleanSelectedTitle) & " >> " & quoted form of logfile

                if cleanTitleStr is equal to cleanSelectedTitle then
                    do shell script "echo MATCHED >> " & quoted form of logfile
                    activate
                    set selected tab of w to t
                    set frontmost of w to true
                    set found to true
                    exit repeat
                else
                    do shell script "echo NOT MATCHED >> " & quoted form of logfile
                end if
            on error errMsg number errNum
                do shell script "printf 'ERROR %d: %s\\\\n' " & errNum & " " & quoted form of errMsg & " >> " & quoted form of logfile
            end try
        end repeat
        if found then exit repeat
    end repeat

    if found then
        do shell script "echo タブをアクティブにしました。 >> " & quoted form of logfile
        do shell script "echo タブをアクティブにしました。"
    else
        do shell script "echo タブが見つかりませんでした。 >> " & quoted form of logfile
        do shell script "echo タブが見つかりませんでした。"
    end if
end tell
EOF

ls -l "$tmpfile"
cat -n "$tmpfile"
echo
# echo "=== AppleScript デバッグログ ==="
# cat "$logfile"

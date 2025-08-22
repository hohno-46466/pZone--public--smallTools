#!/usr/bin/osascript

(*
  jump-to-tty.scpt (jt)

  Version: No.009
  Prev. update: 2025-08-22(Fri)  — updated for hybrid interactive/CLI exits (No.007)
  Prev. update: 2025-08-22(Fri) 20:55 JST / 2025-08-22(Fri) 11:55 UTC (No.008)
  Last update:  2025-08-22(Fri) 21:38 JST / 2025-08-22(Fri) 12:38 UTC (No.009)
  Author: @hohno_at_kuimc
*)

(*
  Terminal.app の全ウィンドウ/全タブを走査し、
  各タブのネイティブな `tty` を取得して前面にジャンプする

  使い方：
    1) 引数なし → 一覧から選んで Jump（ピッカーを表示）
       osascript /path/to/jump-to-tty.scpt
    2) 引数で tty を指定（/dev/tty018, /dev/ttys018, ttys018, tty018, 018 すべてOK）
       osascript /path/to/jump-to-tty.scpt /dev/tty018

  終了コード（CLI 連携向け）:
    0  正常終了（ジャンプ成功／またはピッカーを Cancel）
    1  Terminal のタブが 0 件
    2  指定した TTY が見つからない
*)

property VERSION : "No.009"

(*
  ─────────────────────────────────────────────────────────────────────────────
  on run ... end run : メインのエントリポイント
  - ここがスクリプトの「main」関数
  - 引数解析 → タブ情報の収集 → 直接ジャンプ or ピッカー表示、という流れ
  - 対話実行（引数なし）では GUI ダイアログを出しつつ、エラー時は exit code を返す
    「ハイブリッド」挙動にしている
  ─────────────────────────────────────────────────────────────────────────────
*)

on run argv
  ---------------------------------------------------------------------------
  -- 1) ヘルプ / バージョン（どのモードでも最優先で処理）
  ---------------------------------------------------------------------------
  if (count of argv) >= 1 then
    set a to (item 1 of argv as text)
    if a is "-h" or a is "--help" then ¬
      return "Usage: jt [TTY]\n  e.g. jt 018 | jt /dev/tty018 | jt ttys018\n  (no arg: show picker)"
    if a is "-V" or a is "--version" then ¬
      return "jump-to-tty " & VERSION
  end if

  ---------------------------------------------------------------------------
  -- 2) 実行モード判定
  --    isInteractive = 引数なし（= ピッカー前提の対話実行）
  --    引数ありのときは CLI モードとして扱い、TTY 直指定ジャンプを試みる
  ---------------------------------------------------------------------------
  set isInteractive to ((count of argv) = 0)

  ---------------------------------------------------------------------------
  -- 3) 引数（TTY）を取得（CLI モードのときのみ使用）
  ---------------------------------------------------------------------------
  set ttyQuery to ""
  if not isInteractive then set ttyQuery to item 1 of argv

  ---------------------------------------------------------------------------
  -- 4) 全タブの情報を収集
  --    ここで Terminal.app の各タブが持つネイティブ `tty` を読む
  ---------------------------------------------------------------------------
  set entries to collectTTYs() -- 各要素: {wIndex:int, tIndex:int, ttyText:string, titleText:string}

  ---------------------------------------------------------------------------
  -- 5) 異常系: タブが 0 件
  --    対話実行ならアラートも出しつつ、終了コード 1 で終了
  ---------------------------------------------------------------------------
  if (count of entries) = 0 then
    if isInteractive then display alert "No Terminal tabs found"
    error "No Terminal tabs found" number 1
  end if

  ---------------------------------------------------------------------------
  -- 6) CLI モード：TTY 直指定ジャンプ
  --    見つからなければ、対話実行時はアラートも出して終了コード 2
  ---------------------------------------------------------------------------
  if ttyQuery is not "" then
    set found to findByTTY(entries, ttyQuery)
    if found is missing value then
      if isInteractive then display alert "TTY not found" message ttyQuery
      error ("TTY not found: " & ttyQuery) number 2
    end if
    focusEntry(found)
    return -- 成功: 終了コード 0
  end if

  ---------------------------------------------------------------------------
  -- 7) 対話モード：ピッカー（choose from list）を表示して選択 → 前面へ
  --    「Cancel」の場合は何もしないで正常終了（終了コード 0）
  ---------------------------------------------------------------------------

  -- ピッカー用の表示行を組み立てる。
  -- 各行は人間が読みやすいラベルで、以下を含める：
  --   tty / ウィンドウ番号 / タブ番号 / タブのタイトル
  -- 'choose from list' は選択された「文字列」を返すため、プレーンテキストで保持する。
  set menuItems to {}
  repeat with e in entries
    set r to contents of e              -- e は参照なので、実体（4要素リスト）を取り出す
    set wIndex to item 1 of r           -- ウィンドウ番号（1始まり、Terminalの現在順）
    set tIndex to item 2 of r           -- タブ番号（1始まり、そのウィンドウ内）
    set ttyText to item 3 of r          -- "/dev/ttysNNN" または "(unknown)"
    set titleText to item 4 of r        -- カスタムタイトル or "Tab i"

    -- 1エントリ分の表示ラベルを文字列化。
    -- 下の逆引き時も同じフォーマットで再構成して照合する。
    set end of menuItems to (ttyText & "  -  Win " & (wIndex as text) & " / Tab " & (tIndex as text) & "  [" & titleText & "]")
  end repeat

  -- menuItems を作成し終えた直後に追加した
  set menuItems to my sortTextList(menuItems)

  -- ピッカー（モーダルのリスト）を表示。ボタン表示名も指定。
  -- - with prompt: ダイアログの説明文
  -- - OK button name "Jump": OKボタンのラベル
  -- - cancel button name "Cancel": キャンセルボタンのラベル
  -- - without multiple selections allowed: 単一選択
  set chosen to choose from list menuItems ¬
    with prompt "Select a tab to bring to front (tty / window / tab)" ¬
    OK button name "Jump" ¬
    cancel button name "Cancel" ¬
    without multiple selections allowed

  -- ユーザが「Cancel」を押すと 'chosen' は boolean の false。
  -- その場合はエラー扱いにせず、何もせずに return（終了コード 0 のまま）。
  if chosen is false then return

  -- 'choose from list' は選択要素のリストを返す。単一選択なので先頭の1件を取り出す。
  set chosenText to item 1 of chosen

  -- 選ばれたラベル文字列から、元のエントリ（4要素リスト）に逆引きする。
  -- ラベルの一意性は ttyText（item 3）がユニークであることに依存しており、実運用では十分。
  repeat with e in entries
    set r to contents of e
    set wIndex to item 1 of r
    set tIndex to item 2 of r
    set ttyText to item 3 of r
    set titleText to item 4 of r

    -- ここでも上と同じフォーマットでラベルを再構成して比較する。
    set lineStr to (ttyText & "  -  Win " & (wIndex as text) & " / Tab " & (tIndex as text) & "  [" & titleText & "]")

    -- 一致したら対応するタブを前面へ。
    if lineStr = chosenText then
      focusEntry(r)   -- r = {wIndex, tIndex, ttyText, titleText}
      exit repeat
    end if
  end repeat
end run

---------------------------------------------------------------------------

-- 収集：Terminal のネイティブ `tty` を読む
on collectTTYs()
  -- 返却用のリスト（各要素は {wIndex, tIndex, ttyText, titleText} の4要素リスト）
  set outList to {}

  tell application "Terminal"
    -- Terminal にウィンドウが1つも無い場合は、空コマンドで新規ウィンドウを開く
    -- （以降の windows/tabs 走査でエラーにならないようにするための保険）
    if (count of windows) = 0 then
      do script ""       -- 新しい Terminal ウィンドウを1つ開く
      delay 0.1          -- 生成が完了して内部状態が整うまでほんの少し待機
    end if

    -- 全ウィンドウを走査（w は 1 始まりのインデックス）
    repeat with w from 1 to (count of windows)
      -- 各ウィンドウ内の全タブを走査（i も 1 始まり）
      repeat with i from 1 to (count of tabs of window w)
        -- 現在のタブオブジェクトを取得
        set t to tab i of window w

        -- このタブの tty を読み取る
        -- Terminal の tab オブジェクトが持つ read-only プロパティ
        -- 例: "/dev/ttys018"（まだシェル未起動などで取得に失敗する可能性があるので try で保護）
        set ttyVal to ""
        try
          set ttyVal to (tty of t) as text
        on error
          -- 取得できなかった場合のフェイルセーフ文字列
          set ttyVal to "(unknown)"
        end try

        -- missing value（未定義）や空文字列のときも "(unknown)" に寄せておく
        if ttyVal is missing value or ttyVal is "" then set ttyVal to "(unknown)"

        -- タブのカスタムタイトル（ユーザ／スクリプトが設定したもの）
        -- 未設定のこともあるので、その場合は "Tab i" というデフォルト表示名にする
        set titleVal to (custom title of t)
        if titleVal is missing value or titleVal is "" then set titleVal to ("Tab " & i)

        -- 収集結果を1件追加
        -- ここでは「ウィンドウ番号」「タブ番号」「tty」「表示タイトル」の4つを並べた素のリストで持つ
        set end of outList to {w, i, ttyVal, titleVal as text}
      end repeat
    end repeat
  end tell

  -- 呼び出し元（run ハンドラなど）に、全タブ分の情報一覧を返す
  return outList
end collectTTYs

---------------------------------------------------------------------------

-- /dev/tty018, /dev/ttys018, tty018, ttys018, 018 などを受け入れて検索
on findByTTY(entries, ttyQuery)
  -- ユーザ入力を正規化（/dev/ を外す、小文字化、"tty" → "ttys"、数字だけなら "ttys" を付与）
  set qNorm to normalizeTTY(ttyQuery)
  -- 比較の最後の砦：末尾の連番だけを取り出す（ゼロ埋め差異などに強くするため）
  set qDigits to trailingDigits(qNorm)

  -- 収集済みエントリ（{wIndex, tIndex, ttyText, titleText}）を順に見る
  repeat with e in entries
    set r to contents of e
    -- このタブの tty（例: "/dev/ttys018"）
    set ttyText to item 3 of r
    -- タブ側も同じ規則で正規化
    set tNorm to normalizeTTY(ttyText)
    -- タブ側の末尾数字も抽出
    set tDigits to trailingDigits(tNorm)

    -- 1) 完全一致（正規化後）：最も厳格（例: "ttys018" = "ttys018"）
    if tNorm = qNorm then return r

    -- 2) 末尾一致：保険（例: "mac-ttys018" のような将来拡張に一応耐えるため）
    if tNorm ends with qNorm then return r

    -- 3) 数字だけ一致：ゼロ埋めの有無や "tty018" vs "ttys18" などの差異を吸収
    if qDigits is not "" and tDigits is not "" and qDigits = tDigits then return r
  end repeat

  -- どれにも当たらなかった
  return missing value
end findByTTY

---------------------------------------------------------------------------

-- 正規化：/dev/ を外し、小文字化し、"tty" を "ttys" へ正規化、数字だけなら "ttys" を付与
on normalizeTTY(s)
  -- 1) 前後の空白や改行を除去し、テキスト化
  set x to trimText(s as text)

  -- 2) 先頭の "/dev/" を剥がす（例："/dev/ttys018" → "ttys018"）
  if x starts with "/dev/" then set x to text 6 thru -1 of x

  -- 3) 大文字/小文字ぶれを無くす（外部コマンド tr を使った ASCII 小文字化）
  set x to toLowerASCII(x)

  -- 4) "tty…" で始まるが "ttys…" ではない場合は 's' を補う
  --    例："tty018" → "ttys018"
  if startsWith(x, "tty") then
    -- text 4 of x は "tty" の直後の1文字（存在しないケースもあるので try で保護）
    set after3 to ""
    try
      set after3 to text 4 of x
    end try
    if after3 is not "s" then set x to "ttys" & text 4 thru -1 of x
  end if

  -- 5) 文字列が数字だけなら、"ttys" を先頭に付ける
  --    例："018" → "ttys018"、"18" → "ttys18"
  if isAllDigits(x) then set x to "ttys" & x

  -- 6) 正規化した結果を返す
  return x
end normalizeTTY

---------------------------------------------------------------------------

-- 末尾の数字だけ取り出す（例: "ttys018" -> "018"、"abc" -> ""、"123" -> "123"）
on trailingDigits(s)
  set t to s as text
  set n to (length of t)
  if n = 0 then return "" -- 空文字なら空を返す

  -- 末尾から前へ走査して、数字が途切れる位置を探す
  set i to n
  repeat while i >= 1
    set c to text i of t
    -- ASCIIの'0'〜'9'の範囲か？
    if c < "0" or c > "9" then exit repeat
    set i to i - 1
  end repeat

  -- i が n のまま = 一番末尾が数字ではなかった → 末尾に数字は無い
  if i = n then return ""

  -- 末尾の連続した数字の塊だけ返す
  -- 例: "abc123" なら i は 'c' の位置で止まるので (i+1)〜n = "123"
  return text (i + 1) thru n of t
end trailingDigits

---------------------------------------------------------------------------

-- 文字列が全て数字（ASCII '0'〜'9'）かどうか判定
on isAllDigits(s)
  -- 1) 必ず text にしておく
  set t to s as text

  -- 2) 空文字は「全て数字」とは言えないので false
  if t = "" then return false

  -- 3) 1 文字ずつ走査し、'0'〜'9' の範囲外が見つかったら即 false
  repeat with c in characters of t
    set ch to contents of c
    if ch < "0" or ch > "9" then return false
  end repeat

  -- 4) 最後まで範囲外が無ければ true
  return true
end isAllDigits

---------------------------------------------------------------------------

-- 先頭一致（AppleScript 簡易版）
-- on startsWith(s, prefix)
--   set a to s as text              -- 比較対象
--   set p to prefix as text         -- 接頭辞
--   try
--     -- 長さチェックをせずに部分文字列を切り出すと、
--     -- prefix のほうが長い場合に "text 1 thru N of a" がエラーになる
--     if text 1 thru (length of p) of a = p then return true
--   on error
--     -- ↑のエラー（範囲外アクセス）をここで吸収して false を返す想定
--     return false
--   end try
--   return false                    -- 先頭一致しなかった
-- end startsWith

on startsWith(s, prefix)
  set a to s as text              -- 比較対象
  set p to prefix as text         -- 接頭辞
  if (length of p) = 0 then return true        -- 空プレフィックスは常に一致
  if (length of a) < (length of p) then return false
  return (text 1 thru (length of p) of a = p)
end startsWith

---------------------------------------------------------------------------

-- 小文字化（ASCII）
on toLowerASCII(s)
  try
    -- do shell script: 外部シェルを起動してパイプで tr に通す
    -- quoted form of ... : 引数をシェル安全にクォート（インジェクション防止）
    -- printf %s : 末尾に改行を付けず、そのままの本文を出力
    -- tr 'A-Z' 'a-z' : ASCII 大文字のみ小文字へ（非 ASCII は対象外）
    return do shell script "printf %s " & quoted form of (s as text) & " | tr 'A-Z' 'a-z'"
  on error
    -- 何か失敗した場合は元の文字列を返す（フェイルセーフ）
    return s
  end try
end toLowerASCII

---------------------------------------------------------------------------

-- タブを前面に
on focusEntry(entryList)
  -- entryList の構造: {wIndex:int, tIndex:int, ttyText:string, titleText:string}
  set wIndex to item 1 of entryList
  set tIndex to item 2 of entryList

  tell application "Terminal"
    activate
    -- ここで Terminal を前面アプリにする（Spaces を跨いでも前面に来る設定が一般的）

    -- 目的のタブを選択する：
    -- 「window wIndex の tab tIndex」を選び、そのあとウィンドウ順を最前面(index=1)にする
    set selected tab of window wIndex to tab tIndex of window wIndex

    -- 最前面へ（index は“Zオーダー”を表す 1 始まりの順位（1 が最前面））
    set index of window wIndex to 1
  end tell
end focusEntry


---------------------------------------------------------------------------

-- 前後空白・改行除去
on trimText(s)
  set s2 to s as text

  -- 先頭側を削る：先頭が [space, tab, return, linefeed] のどれかなら 1 文字ずつ落とす
  repeat while s2 starts with " " or s2 starts with tab or s2 starts with return or s2 starts with linefeed
    try
      set s2 to text 2 thru -1 of s2 -- 先頭を1文字落として残りを返す
    on error
      exit repeat -- 文字列が空になったなどでスライスできなければ終了
    end try
  end repeat

  -- 末尾側を削る：末尾が [space, tab, return, linefeed] のどれかなら 1 文字ずつ落とす
  repeat while s2 ends with " " or s2 ends with tab or s2 ends with return or s2 ends with linefeed
    try
      set s2 to text 1 thru -2 of s2 -- 末尾を1文字落として残りを返す
    on error
      exit repeat
    end try
  end repeat

  return s2
end trimText

---------------------------------------------------------------------------

-- 文字列リストを昇順にソート（BSD sort を利用）
-- 入力: xs = {"lineA", "lineB", ...}
-- 出力: 昇順に並んだ新しいリスト
on sortTextList(xs)
  -- 要素数 0/1 はそのまま返して早期終了
  if (count of xs) <= 1 then return xs

  -- それぞれの要素をシェル安全にクォートして配列化
  -- （中にスペース等が含まれても 1 引数として扱われるようにする）
  set args to {}
  repeat with s in xs
    set end of args to quoted form of (contents of s as text)
  end repeat

  -- printf で「各要素ごとに 1 行（%s\n）」を出力し、LC_ALL=C でバイト順ソート
  -- ここで joinWithSpace で複数引数として渡すのがポイント（1引数に連結しない）
  set cmd to "printf '%s\\n' " & my joinWithSpace(args) & " | LC_ALL=C sort"

  -- ソート実行
  set out to do shell script cmd

  -- 改行区切りで行配列に戻す。
  -- paragraphs は CR / LF のどちらでも分割してくれるので環境差に強い。
  set ys to paragraphs of out

  -- 末尾が空行（最後に改行が入っていた等）の場合は落とす
  if (count of ys) > 0 and (item -1 of ys) = "" then set ys to items 1 thru -2 of ys

  return ys
end sortTextList

---------------------------------------------------------------------------

-- スペース区切りでトークン列を 1 本の文字列に連結するヘルパ
-- ここに渡す各要素は「すでに quoted form 済み」であることを前提にしているため、
-- 要素内部にスペース等があっても安全に 1 トークンとして保持される。
on joinWithSpace(lst)
  -- TID（テキスト区切り文字）の一時変更で手早く結合
  set AppleScript's text item delimiters to " "
  set s to lst as text -- lst の各要素の間にスペースを挟んで連結
  -- TID を必ず元に戻す（グローバル設定なので副作用回避のための「お作法」）
  set AppleScript's text item delimiters to ""
  return s
end joinWithSpace

---------------------------------------------------------------------------

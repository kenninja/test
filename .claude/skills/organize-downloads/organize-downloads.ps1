# ============================================
# ダウンロードフォルダ自動整理スクリプト
# ============================================
# 使い方: 右クリック →「PowerShellで実行」
# または PowerShell で: .\organize-downloads.ps1
# ============================================

# --- 設定 ---
$DownloadPath = [Environment]::GetFolderPath("UserProfile") + "\Downloads"

# 仕分け先フォルダと対応する拡張子
$Categories = @{
    "画像"           = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg", ".webp", ".ico", ".tiff", ".heic")
    "ドキュメント"   = @(".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx", ".txt", ".rtf", ".odt", ".ods", ".odp", ".csv")
    "動画"           = @(".mp4", ".avi", ".mkv", ".mov", ".wmv", ".flv", ".webm", ".m4v")
    "音楽"           = @(".mp3", ".wav", ".flac", ".aac", ".ogg", ".wma", ".m4a")
    "圧縮ファイル"   = @(".zip", ".rar", ".7z", ".tar", ".gz", ".bz2", ".xz")
    "インストーラー" = @(".exe", ".msi", ".dmg", ".deb", ".rpm", ".appx", ".msix")
    "コード"         = @(".py", ".js", ".html", ".css", ".java", ".cpp", ".c", ".cs", ".php", ".rb", ".go", ".rs", ".json", ".xml", ".yml", ".yaml", ".sql", ".sh", ".bat", ".ps1")
    "フォント"       = @(".ttf", ".otf", ".woff", ".woff2", ".eot")
    "torrent"        = @(".torrent")
}

$DuplicateFolder = "_重複ファイル"
$OtherFolder     = "その他"

# --- カウンター ---
$movedCount     = 0
$duplicateCount = 0
$skippedCount   = 0

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ダウンロードフォルダ自動整理ツール" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "対象フォルダ: $DownloadPath" -ForegroundColor Yellow
Write-Host ""

# ダウンロードフォルダが存在するか確認
if (-not (Test-Path $DownloadPath)) {
    Write-Host "エラー: ダウンロードフォルダが見つかりません。" -ForegroundColor Red
    Read-Host "Enterキーで終了"
    exit
}

# ファイル一覧を取得（サブフォルダ内は対象外）
$files = Get-ChildItem -Path $DownloadPath -File

if ($files.Count -eq 0) {
    Write-Host "ダウンロードフォルダにファイルがありません。" -ForegroundColor Yellow
    Read-Host "Enterキーで終了"
    exit
}

Write-Host "ファイル数: $($files.Count) 件を処理します..." -ForegroundColor White
Write-Host ""

# --- 実行確認 ---
$confirm = Read-Host "実行しますか？ (Y/N)"
if ($confirm -ne "Y" -and $confirm -ne "y") {
    Write-Host "キャンセルしました。" -ForegroundColor Yellow
    Read-Host "Enterキーで終了"
    exit
}

Write-Host ""

foreach ($file in $files) {
    $fileName  = $file.Name
    $extension = $file.Extension.ToLower()

    # --- 重複ファイルの判定 ---
    # ファイル名に (1), (2) などが含まれているか
    if ($fileName -match '\(\d+\)\.[^.]+$') {
        $destFolder = Join-Path $DownloadPath $DuplicateFolder
        if (-not (Test-Path $destFolder)) {
            New-Item -Path $destFolder -ItemType Directory | Out-Null
        }
        $destPath = Join-Path $destFolder $fileName
        # 同名ファイルが既にある場合はスキップ
        if (Test-Path $destPath) {
            Write-Host "  スキップ (既に存在): $fileName" -ForegroundColor DarkGray
            $skippedCount++
            continue
        }
        Move-Item -Path $file.FullName -Destination $destPath
        Write-Host "  [重複] $fileName → $DuplicateFolder\" -ForegroundColor Magenta
        $duplicateCount++
        continue
    }

    # --- カテゴリ判定 ---
    $category = $null
    foreach ($cat in $Categories.Keys) {
        if ($Categories[$cat] -contains $extension) {
            $category = $cat
            break
        }
    }

    # どのカテゴリにも当てはまらない場合
    if (-not $category) {
        $category = $OtherFolder
    }

    # フォルダ作成 & 移動
    $destFolder = Join-Path $DownloadPath $category
    if (-not (Test-Path $destFolder)) {
        New-Item -Path $destFolder -ItemType Directory | Out-Null
    }

    $destPath = Join-Path $destFolder $fileName
    if (Test-Path $destPath) {
        Write-Host "  スキップ (既に存在): $fileName" -ForegroundColor DarkGray
        $skippedCount++
        continue
    }

    Move-Item -Path $file.FullName -Destination $destPath
    Write-Host "  [$category] $fileName" -ForegroundColor Green
    $movedCount++
}

# --- 結果表示 ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  整理完了！" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  仕分け済み:   $movedCount 件" -ForegroundColor Green
Write-Host "  重複ファイル: $duplicateCount 件" -ForegroundColor Magenta
Write-Host "  スキップ:     $skippedCount 件" -ForegroundColor DarkGray
Write-Host ""
Write-Host "作成されたフォルダ:" -ForegroundColor Yellow

# 作成されたサブフォルダを一覧表示
$subFolders = Get-ChildItem -Path $DownloadPath -Directory | Where-Object {
    $_.Name -ne "desktop.ini"
}
foreach ($folder in $subFolders) {
    $count = (Get-ChildItem -Path $folder.FullName -File).Count
    Write-Host "  📁 $($folder.Name) ($count 件)" -ForegroundColor White
}

Write-Host ""
Read-Host "Enterキーで終了"

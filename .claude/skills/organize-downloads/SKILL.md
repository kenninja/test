---
name: organize-downloads
description: ダウンロードフォルダを自動整理する。ファイルを拡張子ごとにカテゴリ分け（画像、ドキュメント、動画、音楽、圧縮ファイル等）し、重複ファイルも自動検出・分離する。
disable-model-invocation: true
allowed-tools: Bash(powershell *), Bash(printf *)
argument-hint: "[対象フォルダパス（省略時はDownloads）]"
---

# ダウンロードフォルダ自動整理スキル

ダウンロードフォルダ内のファイルを拡張子に基づいてカテゴリ別フォルダに自動仕分けする。

## 実行手順

1. スキルディレクトリ内の `organize-downloads.ps1` を使用する
2. 引数でフォルダパスが指定されている場合は、スクリプト内の `$DownloadPath` を書き換えてから実行する
3. ファイルはUTF-8 BOM付きなので、そのままPowerShellで実行可能

### 実行コマンド

```
printf "Y\n\n" | powershell -ExecutionPolicy Bypass -File "<スキルディレクトリ>/organize-downloads.ps1"
```

引数: $ARGUMENTS

引数がある場合は、スクリプトの `$DownloadPath` 変数を指定されたパスに変更してから実行すること。

## カテゴリ一覧

| カテゴリ | 拡張子 |
|---------|--------|
| 画像 | jpg, jpeg, png, gif, bmp, svg, webp, ico, tiff, heic |
| ドキュメント | pdf, doc, docx, xls, xlsx, ppt, pptx, txt, rtf, odt, ods, odp, csv |
| 動画 | mp4, avi, mkv, mov, wmv, flv, webm, m4v |
| 音楽 | mp3, wav, flac, aac, ogg, wma, m4a |
| 圧縮ファイル | zip, rar, 7z, tar, gz, bz2, xz |
| インストーラー | exe, msi, dmg, deb, rpm, appx, msix |
| コード | py, js, html, css, java, cpp, c, cs, php, rb, go, rs, json, xml, yml, yaml, sql, sh, bat, ps1 |
| フォント | ttf, otf, woff, woff2, eot |
| torrent | torrent |

## 注意事項

- 実行前に確認プロンプトが出るが、スキル実行時は自動的に「Y」を入力する
- 重複ファイル（ファイル名に `(1)`, `(2)` 等が含まれるもの）は `_重複ファイル` フォルダに移動される
- どのカテゴリにも当てはまらないファイルは `その他` フォルダに移動される
- サブフォルダ内のファイルは対象外（直下のファイルのみ）

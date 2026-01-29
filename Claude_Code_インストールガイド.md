# Claude Code インストール・セットアップガイド

このガイドでは、Claude Code（CLI版）のインストールから初回起動までを詳しく説明します。

## 目次
1. [前提条件](#前提条件)
2. [インストール方法](#インストール方法)
3. [初回セットアップ](#初回セットアップ)
4. [基本的な使い方](#基本的な使い方)
5. [よくあるエラーと対処法](#よくあるエラーと対処法)

---

## 前提条件

Claude Code を使用するには、以下が必要です：

### 1. Node.js のインストール
- **Node.js バージョン 18 以上**が必要
- 確認方法：
  ```bash
  node --version
  ```
- インストールされていない場合：
  - [Node.js 公式サイト](https://nodejs.org/)から最新のLTS版をダウンロード
  - インストール後、ターミナルを再起動

### 2. Anthropic API キー
- Claude Code を使用するには、Anthropic API キーが必要
- 取得方法：
  1. [Anthropic Console](https://console.anthropic.com/)にアクセス
  2. アカウントを作成（まだの場合）
  3. 「API Keys」セクションから新しいキーを作成
  4. キーをコピーして安全な場所に保存

---

## インストール方法

Claude Code は2つの方法でインストールできます：

### 方法1: グローバルインストール（推奨）
```bash
npm install -g @anthropic-ai/claude-code
```

インストール後、どのディレクトリからでも `claude-code` コマンドが使用可能になります。

### 方法2: npx で直接実行（インストール不要）
```bash
npx @anthropic-ai/claude-code
```

この方法は毎回パッケージをダウンロードするため、少し時間がかかります。

---

## 初回セットアップ

### ステップ1: Claude Code を起動

ターミナルで以下のコマンドを実行：

```bash
claude-code
```

または npx を使用する場合：

```bash
npx @anthropic-ai/claude-code
```

### ステップ2: API キーの設定

初回起動時、API キーの入力を求められます：

```
Welcome to Claude Code!
Please enter your Anthropic API key:
```

ここで、先ほど取得した API キーを貼り付けて Enter キーを押します。

**注意**:
- API キーは画面に表示されません（セキュリティのため）
- コピー＆ペーストで貼り付けてください
- 入力後 Enter キーを押すのを忘れずに

### ステップ3: API キーの保存

API キーは以下の場所に保存されます：
- **Windows**: `%USERPROFILE%\.clauderc`
- **macOS/Linux**: `~/.clauderc`

次回からは自動的にこのキーが使用されます。

---

## 基本的な使い方

### Claude Code の起動

作業したいディレクトリに移動してから起動：

```bash
cd c:\path\to\your\project
claude-code
```

### VSCode 拡張機能として使用

Claude Code は VSCode の拡張機能としても利用できます：

1. VSCode を開く
2. 拡張機能マーケットプレイスで「Claude Code」を検索
3. インストール
4. サイドバーに表示される Claude アイコンをクリック

---

## よくあるエラーと対処法

### エラー1: `claude-code` コマンドが見つからない

**エラーメッセージ**:
```
'claude-code' は、内部コマンドまたは外部コマンド、
操作可能なプログラムまたはバッチ ファイルとして認識されていません。
```

**原因**:
- グローバルインストールが正しく行われていない
- PATH 環境変数が設定されていない

**対処法**:
1. npm のグローバルパスを確認：
   ```bash
   npm config get prefix
   ```

2. 再インストールを試す：
   ```bash
   npm uninstall -g @anthropic-ai/claude-code
   npm install -g @anthropic-ai/claude-code
   ```

3. それでもダメな場合は npx を使用：
   ```bash
   npx @anthropic-ai/claude-code
   ```

### エラー2: API キー関連のエラー

**エラーメッセージ**:
```
Error: Invalid API key
```
または
```
Error: API key not found
```

**対処法**:
1. API キーを再設定：
   ```bash
   claude-code --reset-api-key
   ```

2. API キーが正しいか確認：
   - [Anthropic Console](https://console.anthropic.com/)で API キーを確認
   - キーをコピーし直して再設定

3. 環境変数で設定する方法：
   ```bash
   # Windows (PowerShell)
   $env:ANTHROPIC_API_KEY="your-api-key-here"

   # macOS/Linux
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```

### エラー3: ネットワークエラー

**エラーメッセージ**:
```
Error: connect ETIMEDOUT
```
または
```
Error: getaddrinfo ENOTFOUND
```

**対処法**:
1. インターネット接続を確認
2. プロキシを使用している場合、npm のプロキシ設定を確認：
   ```bash
   npm config get proxy
   npm config get https-proxy
   ```
3. プロキシ設定が必要な場合：
   ```bash
   npm config set proxy http://proxy.company.com:8080
   npm config set https-proxy http://proxy.company.com:8080
   ```

### エラー4: 権限エラー（Windows）

**エラーメッセージ**:
```
Error: EPERM: operation not permitted
```

**対処法**:
1. PowerShell を管理者権限で実行
2. または、npm のグローバルディレクトリを変更：
   ```bash
   mkdir "%APPDATA%\npm"
   npm config set prefix "%APPDATA%\npm"
   ```
3. 環境変数 PATH に `%APPDATA%\npm` を追加

### エラー5: Node.js バージョンが古い

**エラーメッセージ**:
```
Error: Node version 18.0.0 or higher is required
```

**対処法**:
1. Node.js のバージョンを確認：
   ```bash
   node --version
   ```
2. バージョンが 18 未満の場合、[Node.js 公式サイト](https://nodejs.org/)から最新版をインストール

---

## 便利なコマンド

```bash
# バージョン確認
claude-code --version

# ヘルプを表示
claude-code --help

# API キーをリセット
claude-code --reset-api-key

# 特定のディレクトリで起動
claude-code --cwd /path/to/directory
```

---

## トラブルシューティングのヒント

1. **ターミナルを再起動する**: インストール後は必ずターミナルを再起動してください

2. **キャッシュをクリア**: 問題が解決しない場合は npm キャッシュをクリア：
   ```bash
   npm cache clean --force
   ```

3. **ログを確認**: エラーの詳細を確認するには、デバッグモードで起動：
   ```bash
   DEBUG=* claude-code
   ```

4. **公式ドキュメント**: 最新情報は[公式 GitHub リポジトリ](https://github.com/anthropics/claude-code)を確認

5. **フィードバック**: 問題が解決しない場合は、GitHub Issues で報告してください

---

## まとめ

このガイドで Claude Code のインストールとセットアップができたはずです。
何か問題が発生した場合は、「よくあるエラーと対処法」のセクションを参照してください。

Happy Coding with Claude! 🚀

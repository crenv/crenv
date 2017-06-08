# crenv [![Build Status](https://travis-ci.org/pine/crenv.svg?branch=master)](https://travis-ci.org/pine/crenv)

[English](README.md) | 日本語

crenv は Ruby の [rbenv](https://github.com/sstephenson/rbenv) と同じ使い方ができる [Crystal](http://crystal-lang.org/) 用のバージョンマネージャーです。

## はじめに
### anyenv を使って crenv をインストールする (推奨)

[anyenv](https://github.com/riywo/anyenv) を利用すると、たったのコマンド一つで crenv をインストールできます。

以下のコマンドを実行する前に、事前に [anyenv](https://github.com/riywo/anyenv) をインストールしておく必要があります。

```
$ anyenv install crenv
$ exec $SHELL -l
$ crenv -v
crenv 1.0.0
```

### インストールスクリプトを用いて crenv をインストールする
以下のコマンドを使ってインストールが可能です。

```
$ curl -L https://raw.github.com/pine/crenv/master/install.sh | bash
```

`curl` ではなく、`wget` を用いる場合は、

```
$ wget -qO- https://raw.github.com/pine/crenv/master/install.sh | bash
```

インストール後は、下記コマンドのようにシェルの設定を追記する必要があります。

```
$ echo 'export PATH="$HOME/.crenv/bin:$PATH"' >> ~/.your_profile
$ echo 'eval "$(crenv init -)"' >> ~/.your_profile
$ exec $SHELL -l
```

## crenv を用いて Crystal をインストールする
上記の方法で crenv が正しくインストールされている場合、以下のコマンドで Crystal をインストールできます。

```
$ crenv install 0.19.0 # 対象のバージョンの Crystal をインストール
$ crenv global 0.19.0 # グローバルバージョンを指定

$ crenv rehash
$ crystal --version
Crystal 0.19.0 (2016-09-02)

$ shards --version
Shards 0.6.3 (2016-09-02)
```


## 使い方

詳細は、crenv コマンドのヘルプをご覧ください。

```
$ crenv help
Usage: crenv <command> [<args>]

Some useful crenv commands are:
   commands    List all available crenv commands
   local       Set or show the local application-specific Crystal version
   global      Set or show the global Crystal version
   shell       Set or show the shell-specific Crystal version
   rehash      Rehash crenv shims (run this after installing executables)
   version     Show the current Crystal version and its origin
   versions    List all Crystal versions available to crenv
   which       Display the full path to an executable
   whence      List all Crystal versions that contain the given executable

See `crenv help <command>' for information on a specific command.
For full documentation, see: https://github.com/pine/crenv#readme
```

より詳細なコマンドの使い方について知りたい場合、[rbenv#command-reference](https://github.com/sstephenson/rbenv#command-reference) をご覧ください。

### バージョンを指定して Crystal をインストールする

crenv は単体で Crystal のインストール機能を搭載していません。この機能を利用するには [crystal-build](https://github.com/pine/crystal-build) をプラグインとしてご利用ください。

[anyenv](https://github.com/riywo/anyenv) を使って crenv をインストールした場合、インストールスクリプトを使って crenv をインストールした場合は、[crystal-build](https://github.com/pine/crystal-build) も同時にインストールされます。

```
# 利用できるバージョンを一覧表示
$ crenv install -l

# バージョンを指定して Crystal をインストール
$ crenv install 0.19.0
```

### crenv を更新する
crenv を更新するには、以下のコマンドを実行してください。

```
$ cd ~/.crenv # or ~/.anyenv/envs/crenv
$ git pull origin master
$ cd plugins/crystal-build
$ git pull origin master
```

## 謝辞
この場を借りて、お礼申し上げます。

- [riywo](https://github.com/riywo)<br />
crenv は [ndenv](https://github.com/riywo/ndenv) よりフォークして作成されました。
- [sstephenson](https://github.com/sstephenson)<br />
crenv は [rbenv](https://github.com/rbenv/rbenv) のソースコードをコピーして作成されています。

## 参照
- [crystalbrew](https://github.com/pine/crystalbrew) 別の Crystal バージョンマネージャー

## パッチの送付方法

1. このリポジトリをフォークします ( https://github.com/pine/crenv/fork )
2. フォーク先で新しいブランチを切ります (git checkout -b my-new-feature)
3. 変更をコミットしてください (git commit -am 'Add some feature')
4. フォーク先にプッシュします (git push origin my-new-feature)
5. このリポジトリへプルリクエストを作成してください

## ライセンス
(The MIT license)

Copyright (c) 2015-2016 Pine Mizune

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## 作者
水音ぴね &lt;<pinemz@gmail.com>&gt;

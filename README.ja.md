# crenv [![Build Status](https://travis-ci.org/pine613/crenv.svg?branch=master)](https://travis-ci.org/pine613/crenv)

[English](README.md) | 日本語

crenv は Ruby の [rbenv](https://github.com/sstephenson/rbenv) と同じ使い方ができる [Crystal](http://crystal-lang.org/) 用のバージョンマネージャーです。

## anyenv を使ってインストール

あなたが [anyenv](https://github.com/riywo/anyenv) を使用している場合、crenv は以下のコマンドでインストールできます。

```
$ anyenv install crenv
$ exec $SHELL -l
```

## 通常インストール
以下のコマンドを使ってインストールが可能です。

```
$ curl -L https://raw.github.com/pine613/crenv/master/install.sh | bash
```

もしくは、`wget` を用いる場合、
```
$ wget -qO- https://raw.github.com/pine613/crenv/master/install.sh | bash

```

インストール後は、下記コマンドのようにシェルの設定を追記する必要があります。

```
$ echo 'export PATH="$HOME/.crenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(crenv init -)"' >> ~/.bash_profile
$ exec $SHELL -l
```

上記の方法で crenv が正しくインストールされている場合、以下のコマンドで Crystal をインストールできます。

```
$ crenv install 0.8.0
$ crenv global 0.8.0
$ crenv rehash
$ crystal --version
Crystal 0.8.0 [e363b63] (Sat Sep 19 12:18:15 UTC 2015)
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
For full documentation, see: https://github.com/pine613/crenv#readme
```

より詳細なコマンドの使い方について知りたい場合、[rbenv#command-reference](https://github.com/sstephenson/rbenv#command-reference) をご覧ください。

### バージョンを指定して Crystal をインストールする

crenv は単体で Crystal のインストール機能を搭載していません。この機能を利用するには [crystal-build](https://github.com/pine613/crystal-build) をプラグインとしてご利用ください。

```
# list all available versions:
$ crenv install -l

# install a Crystal version:
$ crenv install 0.8.0
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

- [riywo](https://github.com/riywo)
- [sstephenson](https://github.com/sstephenson)

## 参照
- [crystalbrew](https://github.com/pine613/crystalbrew) 別の Crystal バージョンマネージャー

## ライセンス
(The MIT license)

Copyright (c) 2015 Pine Mizune

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

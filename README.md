# crenv [![Build Status](https://travis-ci.org/pine613/crenv.svg?branch=master)](https://travis-ci.org/pine613/crenv)

[Crystal](http://crystal-lang.org/) version manager. crenv is inspired by [rbenv](https://github.com/sstephenson/rbenv).

English | [日本語](README.ja.md)

## Getting started
### Install crenv by anyenv (recommended)
It's very easy for you to install crenv, if you use [anyenv](https://github.com/riywo/anyenv).

First, you should install [anyenv](https://github.com/riywo/anyenv).

Next, you try to execute following commands:

```
$ anyenv install crenv
$ exec $SHELL -l
$ crenv -v
crenv 1.0.0
```

### Install crenv by install script
You try to execute following commands:

```
$ curl -L https://raw.github.com/pine613/crenv/master/install.sh | bash
```

or

```
$ wget -qO- https://raw.github.com/pine613/crenv/master/install.sh | bash
```

And, please add your shell profile:

```
$ echo 'export PATH="$HOME/.crenv/bin:$PATH"' >> ~/.your_profile
$ echo 'eval "$(crenv init -)"' >> ~/.your_profile
$ exec $SHELL -l
$ crenv -v
crenv 1.0.0
```

### Install Crystal by crenv

If you installed crenv, you may installed Crystal as following.

```
$ crenv install 0.12.0 # install Crystal
$ crenv global 0.12.0 # set global Crystal version
$ crenv rehash

$ crystal --version
Crystal 0.12.0 [90eaec1] (Tue Feb 16 14:21:22 UTC 2016)

$ shards --version
Shards 0.6.1 [02580d3] (2016-02-20)
```


## Usage

Please see help.

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

You might want to see [rbenv#command-reference](https://github.com/sstephenson/rbenv#command-reference) if you been looking for command reference.

### Installing Crystal Versions

The crenv install command doesn't ship with crenv out of the box, but is provided by the [crystal-build](https://github.com/pine613/crystal-build) project.

```
# list all available versions:
$ crenv install -l

# install a Crystal version:
$ crenv install 0.12.0

# set global Crystal version:
$ crenv global 0.12.0
```

### Updateing crenv
Please execute following commands to update crenv.

```
$ cd ~/.crenv # or ~/.anyenv/envs/crenv
$ git pull origin master
$ cd plugins/crystal-build
$ git pull origin master
```

## Development
The crenv source code is [hosted on GitHub](https://github.com/pine613/crenv). It's clean, modular, and easy to understand, even if you're not a shell hacker.

Tests are executed using [Bats](https://github.com/sstephenson/bats):

```
$ bats test
$ bats test/<file>.bats
```

## Contributing

1. Fork it ( https://github.com/pine613/crenv/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Acknowledgement

- [riywo](https://github.com/riywo)<br />
crenv is forked from [ndenv](https://github.com/riywo/ndenv). Thank you.
- [sstephenson](https://github.com/sstephenson)<br />
crenv is copied code from [rbenv](https://github.com/rbenv/rbenv). Thank you.

## See also
- [crystalbrew](https://github.com/pine613/crystalbrew) Another Crystal version manager

## License
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

## Author
Pine Mizune &lt;<pinemz@gmail.com>&gt;

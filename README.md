crenv
-----

[![Build Status](https://travis-ci.org/pine613/crenv.svg?branch=master)](https://travis-ci.org/pine613/crenv)

[Crystal](http://crystal-lang.org/) version manager. crenv is inspired by [rbenv](https://github.com/sstephenson/rbenv).

English | [日本語](README.ja.md)

## Install (for anyenv users)

If you used [anyenv](https://github.com/riywo/anyenv), it might be very easy for you to install crenv !

```
$ anyenv install crenv
$ exec $SHELL -l
```

## Install (for everyone)

```
$ git clone https://github.com/pine613/crenv ~/.crenv
$ echo 'export PATH="$HOME/.crenv/bin:$PATH"' >> ~/.bash_profile
$ echo 'eval "$(crenv init -)"' >> ~/.bash_profile
$ exec $SHELL -l
```

I recommend using crystal-build for installing Crystal itself. See also [crystal-build](https://github.com/pine613/crystal-build).

```
$ git clone https://github.com/pine613/crystal-build.git ~/.crenv/plugins/crystal-build
```

If you installed crystal-build plugin, you may installed Crystal as following.

```
$ crenv install 0.8.0
$ crenv global 0.8.0
$ crenv rehash
$ crystal --version
Crystal 0.8.0 [e363b63] (Sat Sep 19 12:18:15 UTC 2015)
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
$ crenv install 0.8.0
```

## Roadmap

- Support [shards](https://github.com/ysbaddaden/shards)

## Acknowledgement

- [riywo](https://github.com/riywo)<br />
crenv is forked from [ndenv](https://github.com/riywo/ndenv). Thank you.
- [sstephenson](https://github.com/sstephenson)<br />
crenv is copied code from [rbenv](https://github.com/sstephenson/rbenv). Thank you.

## See also
- [crystalbrew](https://github.com/pine613/crystalbrew) Another Crystal version manager

## License
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

## Author
Pine Mizune &lt;<pinemz@gmail.com>&gt;

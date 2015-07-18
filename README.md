crenv
-----

[Crystal](http://crystal-lang.org/) version manager. crenv is inspired by [rbenv](https://github.com/sstephenson/rbenv).

## Install using anyenv

If you used [anyenv](https://github.com/riywo/anyenv), it might be very easy for you to install crenv !

```
$ anyenv install crenv
$ exec $SHELL -l
```

## Install

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
$ crenv install 0.7.4
$ crenv rehash
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

## Acknowledgement

- [riywo](https://github.com/riywo)<br />
crenv is forked from [ndenv](https://github.com/riywo/ndenv). Thank you.
- [sstephenson](https://github.com/sstephenson)<br />
crenv is copied code from [rbenv](https://github.com/sstephenson/rbenv). Thank you.

## See also
- [crystalbrew](https://github.com/pine613/crystalbrew) Another Crystal version manager

## License
Please see LICENSE file.

## Author
Pine Mizune

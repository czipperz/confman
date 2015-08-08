#confman

              confman
              /// \\\
    configuration manager

Installation instructions at the bottom

This project aims to have the dotfiles configuration easily made through a simple
file of the form:

    $HOME/dotfiles
    zsh/zshrc                     '$HOME/.zsh/ space /deliniated path /with manually escaped \"'   # all text past the second word is discarded
    rc.lua                        $HOME/.config-w-'s/awesome/rc.lua                                # note how you NEED to write rc.lua in both places.

This allows you to just specify the (dotfiles) directory as the first line,
then use relative paths for the first argument but absolute paths for the second.

Any files found in the locations specified by the second argument will be moved
to `<their name>.backup`.

Due to how the file is parsed, the directory to prepend to the first argument
must be on the first line of the file: no whitespace is allowed before it.

##Options

* `-n` or `--nono` - lists what processes it would execute.
* `-c` or `--clean` - cleanup (delete) the backup files it would normally generate. DOES NOT do anything else.
* `-h` or `--hard` - `ln` the files instead of `ln -s`

##How to Install

* `git clone` the project
* `cd` into the directory
* `make install`

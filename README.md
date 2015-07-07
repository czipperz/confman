#confman

              confman
              /// \\\
    configuration manager

This project aims to have the dotfiles configuration easily made through a simple
file of the form:

	$HOME/dotfiles
    zsh/zshrc                     $HOME/.zshrc
	rc.lua                        $HOME/.config/awesome/rc.lua   # note how you NEED to write rc.lua in both places.
    "space delimiated/with 's"    'space delimiated/with "s'

This allows you to just specify the (dotfiles) directory as the first line,
then use relative paths for the first argument but absolute paths for the second.

Any files found in the locations specified by the second argument will be moved
to `<their name>.backup`.

Due to how the file is parsed, the directory to prepend to the first argument
must be on the first line of the file: no whitespace is allowed before it.

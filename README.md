Mudox's Vim Configuration
=========================

Totally 80+ plugins under the management of 'Neobundle'.

NOTE:
-----
This vimrc has several preconditions:

* This file 'vimrc' NOT '.vimrc' must reside in the root directory of .vim or
  vimfiles directory, while the formally '.vimrc' file, containing a single line
  to source this file, resides just outisde .vim or vimfiles direcotry. By doing
  this, we can conveniently use git to manage the whole vim configuration stuff.

* Assumes you haved defined a system or user environment variable: MDX_DROPBOX
  which holds the absolute path to dropbox root path. (deprecated)
This vimrc follows several predefined laws:

* Mapping scheme:
  1. use '\' to map relatively infrequently used functions.
  2. usr g:mapleader & b:localleader to map relatively frequently used functions.

* Use g:vim_config_root to gain the full path of .vim or vimfies directory.

TODO:
-----
* Add configurations to let 'Neobundle' to load plugins as later as possible,
thus improve startup speed.

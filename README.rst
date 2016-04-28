
Installation
============

Prerequisites
-------------

* Git
* Pygments

Bootstrapper
------------

The bootstrapper will back up all your existing files before it installs
anything new, it'll also warn you if a dependency isn't met.

.. code:: bash

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/benoistlaurent/dotfiles/master/bootstrap.sh)"


Don't worry, all your old files will be backed up!


Stay Updated
------------

Run the bootstrapper again!

.. code:: bash

    $ ~/.dotfiles/bootstrap.sh

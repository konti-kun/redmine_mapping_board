# Redmine Mapping board

This is a redmine plugin.
You can put(add)/move/peel off issues in the board like a sticky note.
This note has has the number as unique key in project.
The note has one issue and you can edit the number of the note in the issue edit form.

This plugin uses D3.js and SVG.
Therefore Internet Explore is not supported.


## Installation

From your Redmine plugins directory, clone this repository:

    git clone https://github.com/konti-kun/redmine_mapping_board.git

You will also need some libraries dependency, which can be installed by running

    bundle install

from the plugin directory.

This plugin has a model so you have to migrate.

    rake redmine:plugins:migrate



# Redmine Mapping board

[![Build Status](https://travis-ci.org/konti-kun/redmine_mapping_board.svg?branch=master)](https://travis-ci.org/konti-kun/redmine_mapping_board)

This is a redmine plugin.
You can put(add)/move/peel off issues in the board like a sticky note.

You would like to mapping issue with images.
If you upload image files in file module of redmine, you can map images in white board.

This plugin uses D3.js and SVG.
Therefore Internet Explore is not supported.

![](https://github.com/konti-kun/redmine_mapping_board/wiki/mapping_board_sample.png)

## Installation

From your Redmine plugins directory, clone this repository:

    git clone https://github.com/konti-kun/redmine_mapping_board.git

You will also need some libraries dependency, which can be installed by running

    bundle install

from the plugin directory.

This plugin has a model so you have to migrate.

    rake redmine:plugins:migrate



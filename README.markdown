git-history
===========

Usage
-----

    Usage : sh git-hist.sh filename
    You must be in a directory versionned with git for this to work.

Features
--------

At the moment, you can view previous, next, first, last version, scroll up, down & back to top.

Dependencies
------------

* terminal with color & cursor movement ansi codes
* bash
* tput
* git
* unix tools : tail head nl tac cut

Background
----------

I've been looking for a tool that would visually "replay" the programmer's work, like a 24h/24 screencast of their editor, but played at an accelerated speed. The aim is to :
1. See the evolution of the whole project.
2. See the evolution of the contents of a single file.

[Gource](http://code.google.com/p/gource/) provides a soluion for aim #1, and Apple's "time machine" (Mac OS X) seems to provide something somehow related. But both seem to work with a granularity of files & folders, which is too big for aim #2 (I want to see the acual code being modified).

So I created a short script that allows you to navigate through the different versions of a single file.

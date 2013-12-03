#!/usr/bin/env python
# encoding: utf-8

import webbrowser

import vim


def OpenCurHtmlInFirefox():
    """ Open current html buffer in firefox.

    :returns: none

    """
    OpenInFirefox(vim.current.buffer.name)


def OpenInFirefox(url):
    """@todo: Docstring for OpenInFirefox.

    :url: url to be opened in firefox's new tab.
    :returns: none

    """
    firefox = webbrowser.get('firefox')
    firefox.open(url)

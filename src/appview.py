#!/usr/bin/env python

import pygtk
pygtk.require('2.0')
import gtk

class AppView:
    def __init__(self):
        window = gtk.Window(gtk.WINDOW_TOPLEVEL);
        window.set_title("ShootM")
        window.connect("destroy", lambda x: gtk.main_quit())
        
        window.show()
    def start(self):
        gtk.main()
        return 0

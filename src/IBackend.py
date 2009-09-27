from Shooter import *
from Club import *
from Contest import *

class IBackend(object):

    """
     This interface is used for fetching and storing data. Multiple backends can
     implement for various data storage methods. Application is however modeled for
     database-like storage methods.

    :version:
    :author:
    """

    def open_file(self, filename):
        """
         

        @param string filename : 
        @return  :
        @author
        """
        pass

    def add_shooter(self, _shooter):
        """
         

        @param Shooter _shooter : 
        @return  :
        @author
        """
        pass

    def add_club(self, _club):
        """
         

        @param Club _club : Club to be added to the file
        @return  :
        @author
        """
        pass

    def add_contest(self, contest):
        """
         

        @param Contest contest : Contest to be added to the file
        @return  :
        @author
        """
        pass




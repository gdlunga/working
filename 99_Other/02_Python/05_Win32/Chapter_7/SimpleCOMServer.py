import bookset
import transac

import win32com.server.register
import win32com.server.util
import win32com.client.dynamic

import time

import sys;sys.path.append(r'C:\Program Files\eclipse\plugins\org.python.pydev_2.7.5.2013052819\pysrc')
import pydevd

class PythonUtilities:
    _public_methods_ = [ 'SplitString' ]
    _reg_progid_     = "PythonDemos.Utilities"
    _reg_clsid_      = "{9607A18F-34CE-425A-AD14-5F9988D16B7E}"
    
    def SplitString(self, val, item = None):
        import string
        if item != None: item = str(item)
        return string.split(str(val), item)

class COMTransaction:
    # we don't need all the _reg_ stuff, as we provide our own
    # API for creating these and do not use the registry.
    _public_methods_ = [
                'asString',
                'getDateString',
                'setDateString',
                'setCOMDate',
                'getCOMDate',
                'getComment',
                'setComment',
                'getLineCount',
                'getAccount',
                'getAmount',
                'addLine',
                'addLastLine',
                'getOneLineDescription'
                ]
    
    def __init__(self, tran=None):
        if tran is None:
            self._tran = transac.Transaction()
        else:
            self._tran = tran       
        
    def asString(self):
        return self._tran.asString()
    
    def getDateString(self):
        return self._tran.getDateString()
    
    def setDateString(self, aDateString): 
        self._tran.setDateString(str(aDateString))
    
    def setCOMDate(self, comdate):
        self._tran.date = (comdate - 25569.0) * 86400.0
        
    def getCOMDate(self):
        return (self._tran.date / 86400.0) + 25569.0

    def getComment(self):
        return self._tran.comment

    def setComment(self, aComment):
        self._tran.comment = str(aComment)
       
    def getOneLineDescription(self):
        return '%-15s %s %10.2f' % (
            self._tran.getDateString(), 
            self._tran.comment,
            self._tran.magnitude()
            )
    
    def getLineCount(self):
        return len(self._tran.lines)
    
    def getAccount(self, index):
        return self._tran.lines[index][0]
        
    def getAmount(self, index):
        return self._tran.lines[index][1]
    
    def addLine(self, account, amount):
        self._tran.addLine(str(account), amount)
       
    def addLastLine(self, account):
        self._tran.addLastLine(str(account))


class COMBookSet:
    _public_methods_ = [ 
                        'double'                , 
                        'count'                 , 
                        'load'                  , 
                        'add'                   ,
                        'edit'                  ,
                        'getOneLineDescription' ,
                        'createTransaction'     ,
                        'getTransaction'        ,
                        'getAccountList'        ,
                        'getAccountDetails'     ,
                        'getTransactionString'  ,
                        'drawAccountChart'      ,
                        'writeOnRange'
                       ]
    _reg_progid_     = "Doubletalk.BookServer"
    _reg_clsid_      = "{93d328b8-c99c-4081-9179-77adc17fee0b}"
    
    def __init__(self):
        pydevd.settrace()
        self.__BookSet = bookset.BookSet()
    
    def double(self,arg):
        return arg * 2
    
    def load(self, fileName):
        self.__BookSet.load(str(fileName))
        return 'It works!'

    def count(self):
        return len(self.__BookSet)
        
    def getTransactionString(self, index):
        return self.__BookSet[index].asString()
     
    def getOneLineDescription(self, index):
        #print "Now getting info for transaction " + str(index)
        return self.__BookSet[index].getOneLineDescription()   
    
    def createTransaction(self):
        comTran = COMTransaction()
        idTran = win32com.server.util.wrap(comTran)
        return idTran
 
    def add(self, idTran):
        comTran = win32com.server.util.unwrap(idTran)
        pyTran = comTran._tran
        self.__BookSet.add(pyTran)
        
    def getTransaction(self, index):
        python_tran = self.__BookSet[index]
        com_tran = COMTransaction(python_tran)
        return win32com.server.util.wrap(com_tran)
       
    def getAccountList(self):
        return self.__BookSet.getAccountList()
 
    def edit(self, index, idTran):
        comTran = win32com.server.util.unwrap(idTran)
        pyTran = comTran._tran
        self.__BookSet.edit(index, pyTran)

    def getAccountDetails(self, match):
        return self.__BookSet.getAccountDetails(str(match))
    
    
    def drawAccountChart(self, vbForm):
        """Draws a chart on the VB form.  Bad design as it ties the back end to VB,
        but demonstrates most features involved in callbacks. It also includes some
        print statements which will show up in the Trace Collector debugging tool -
        this tool is essential for debugging."""

        print 'Drawing chart...'
        
        # Make a Dispath wrapper around the vb Form object so we can call
        # any of its methods.
        idForm = win32com.client.Dispatch(vbForm)
        
        # access a property of the vb form
        idForm.Caption = "Python drew this chart at " + time.ctime(time.time())

    def writeOnRange(self, RangeIn, RangeOut):    
        idRangeIn  = win32com.client.Dispatch(RangeIn)
        idRangeOut = win32com.client.Dispatch(RangeOut)
        
        nRows = idRangeIn.CurrentRegion.Rows.Count
        nCols = idRangeIn.CurrentRegion.Columns.Count
        
        for i in range(1, nRows + 1):
            for j in range(1, nCols + 1):
                idRangeOut.Cells(i, j).Value = 2 * idRangeIn.CurrentRegion.Cells(i, j).Value
        
        #idRange.Cells(1,1).Value = "Python was here!"
        
#-------------------------------------------------------------------------------------------------------------------------------    
    
if __name__ == '__main__':
    print "Registering/Unregistering COM server..."
    import win32com.server.register
    #mode = raw_input('\nActivity ?\n 1 - Register \n 2 - Unregister\n')
    #if mode == '1':
    #    win32com.server.register.UseCommandLine(COMBookSet)
    #else:        
    #    win32com.server.register.UnregisterClasses(COMBookSet)
    win32com.server.register.UnregisterClasses(COMBookSet)
    win32com.server.register.UseCommandLine(COMBookSet)
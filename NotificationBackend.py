import xml.etree.ElementTree as ET
import urllib2
import msvcrt, time

def getXMLFromURL(url):
    response = urllib2.urlopen(url)
    xml = response.read()
    return xml;


class CurrencyXMLTree:
    

    def __init__(self, string):
        self.tree = ET.fromstring(string)

    def getCurrentRate(self, symbol):
        for child in self.tree:
            if(child.attrib['Symbol'].lower() == symbol.lower()):
                return float(child[0].text)
            
    def checkIfSymbolExists(self, symbol):
        for child in self.tree:
            if(child.attrib['Symbol'].lower() == symbol.lower()):
                return True
        return False


class CurrencyTester:

    def __init__(self, tree, currency, target, startingLine):
        self.currency = currency
        self.targetValue = target
        self.startingLine = startingLine

        ##if(self.targetValue >= tree.getCurrentRate(self.currency)):
            #self.startingLine = 1
        #else:
           # self.startingLine = -1

    def compareValues(self, tree):
        
        if(self.targetValue >= tree.getCurrentRate(self.currency)):
            finishLine = 1
        else:
            finishLine = -1
        if(finishLine != self.startingLine):
            return True
        else:
            return False

def getChoiceNumber(numberOfChoices = 3):
    while(True):
        try:
            choice = raw_input("Please enter the number of your selection [1-"+str(numberOfChoices)+"]: ")
            choiceNumber = int(choice)
            if (choiceNumber >= 1 and choiceNumber <= numberOfChoices):
                return choiceNumber
            else:
                print "Invalid selection, please try again."
                
        except ValueError:
            print "You did not enter an integer, please try again."

def getString(text="Please enter a string: "):
    while(True):
        try:
            choice = raw_input(text)
            return choice
                
        except:
            print "Error, please try again."

def getFloat(text="Please enter a decimal number"):
    while(True):
        try:
            choice = raw_input(text)
            floatNumber = float(choice)
            return floatNumber
                
        except ValueError:
            print "You did not enter a floating point number, please try again."

        
        

def mainLoop():
    i= time.time()
    checkRate = 10
    tree = CurrencyXMLTree(getXMLFromURL("http://rates.fxcm.com/RatesXML"))
    tester = CurrencyTester(tree, 'EURUSD', 1.38355, 1)
    print "Currently looking at currency "+tester.currency+" when it reaches target rate "+str(tester.targetValue)+" checking every "+str(checkRate)+" seconds."
    print "Press ENTER at any time to bring up the options menu."

    while True:
        if (time.time() - i > checkRate):
                tree = CurrencyXMLTree(getXMLFromURL("http://rates.fxcm.com/RatesXML"))
                #print tester.currency+" at: "+str(tree.getCurrentRate(tester.currency))
                if (tester.compareValues(tree)):
                    if(tester.startingLine == 1):
                        print tester.currency+" has gone above target rate "+str(tester.targetValue)+", current rate at "+str(tree.getCurrentRate(tester.currency))+"!"
                    elif(tester.startingLine == -1):
                        print tester.currency+" has gone below target rate "+str(tester.targetValue)+", current rate at "+str(tree.getCurrentRate(tester.currency))+"!"
                #print ("tester1 evaluates to: ",tester.compareValues(tree))
                i = time.time()
                
                                       
        if msvcrt.kbhit():
            if msvcrt.getwche() == '\r':
                print "What would you like to do?"
                print """
[1] Change my currency configuration.
[2] Exit the program.
                    """
                selection = getChoiceNumber(2)
                if(selection == 1):
                    step1 = False
                    while(not step1):
                        currencyName = getString("Please enter which currency you want to track: ")
                        if(not tree.checkIfSymbolExists(currencyName)):
                            print "This currency name was not found, please enter a valid currency name."
                        else:
                            step1 = True
                    
                    targetRate = getFloat("Please enter the target rate: ")
                    "get new target rate"
                    print "Would you like to be notified when the target rate is above [1] or below [2] the previously entered value?"
                    choiceAboveOrBelow = getChoiceNumber(2)
                    if(choiceAboveOrBelow == 1):
                        tester = CurrencyTester(tree,currencyName,targetRate,1)
                    else:
                        tester = CurrencyTester(tree,currencyName,targetRate,-1)

                    print "Currently looking at currency "+tester.currency+" when it reaches target rate "+str(tester.targetValue)+" checking every "+str(checkRate)+" seconds."
                elif(selection == 2):
                    break
        time.sleep(0.1)
    print i

mainLoop()

from utils import *
from myconfiguration import *

class TemplateInstance:

    def __init__(self,title=None,templatedef=None,lines=[],params={},subtemplates=[]):
        self.mtitle       = title
        self.mtemplatedef = templatedef
        self.mlines       = lines
        self.mparams      = params
        self.msubtemplates = subtemplates

def islinetemplatestart(line):
    return (line[0] == "*")

def linelevel(line):
    stars = line.split("*")
    nstars = 0
    for star in stars:
        if len(star) == 0:
            nstars += 1
        else:
            break
    puts("linelevel",line,nstars)
    return nstars

def linetitle(line):
    result = line.strip("*").strip()
    puts("linetitle",line,"title",result)
    return result

def parse_org(filepath):
    result    = []
    cinstancestack = []
    
    for line in flines(filepath):
        line = line.strip()
        if len(line) > 0:
            if islinetemplatestart(line):
                newlevel = linelevel(line)
                cinstancestack = cinstancestack[0:newlevel]
                cinstancestack.append(TemplateInstance())
                cinstancestack[-1].mtitle = linetitle(line)

                
def test():
    parse_org(dots2art_site())

test()
                

                

    

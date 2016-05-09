from utils import *
from myconfiguration import *

class TemplateInstance:

    def __init__(self):
        self.mtitle        = None
        self.mtemplatedef  = None
        self.mlines        = []
        self.mattributes   = {}
        self.msubtemplates = []

    def tostring(self):
        return "title " + self.mtitle

    def tostringall(self):
        content = []
        content.append("title : " + self.mtitle)
        content.append("templatedef : " + str(self.mtemplatedef))
        content.append("lines : " + " - ".join(self.mlines))
        content.append("params : " + " - ".join([key + " -+- " + str(self.mattributes[key]) for key in self.mattributes]))
        content.append("subtemplates : " + " - ".join([t.mtitle for t in self.msubtemplates]))
        return " # ".join(content)

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
    level = nstars - 1
    puts("linelevel",line,level)
    return level

def linetitle(line):
    result = line.strip("*").strip()
    puts("linetitle",line,"title",result)
    return result

def islineparam(line):
    return (line[0] == ":")

def lineparam(line):
    strings = line.split(":")
    key = strings[1].strip("-").strip()
    value = ":".join(strings[2:])

    keytype = "single"
    if key[-1] == "+":
        keytype = "list"
    result = (key,value,keytype)
    puts("lineparam",result)
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
                puts("strip instancestack before adding new tempalte",len(cinstancestack)," templates"," ### ".join([t.tostringall() for t in cinstancestack]))
                newtemplate = TemplateInstance()
                cinstancestack.append(newtemplate)
                newtemplate.mtitle = linetitle(line)
                if newlevel == 0:
                    result.append(cinstancestack[-1])
                else:
                    puts("cinstancestack[-2]",cinstancestack[-2].tostringall())
                    puts("cinstancestack[-1]",cinstancestack[-1].tostringall())
                    cinstancestack[-2].msubtemplates.append(cinstancestack[-1])
                puts("stack len",len(cinstancestack)," templates"," ### ".join([t.tostringall() for t in cinstancestack]))
                
            else:
                if islineparam(line):
                    (key,value,keytype) = lineparam(line)
                    
                    if key in cinstancestack[-1].mattributes and keytype == "single":
                        puts("ERROR","key",key,"with value",value,"already in instance",cinstancestack[-1].tostring())
                    if keytype == "single":
                        cinstancestack[-1].mattributes[key] = value
                    else:
                        if not key in cinstancestack[-1].mattributes:
                            cinstancestack[-1].mattributes[key] = []
                        cinstancestack[-1].mattributes[key].append(value)
                else:
                    cinstancestack[-1].mlines.append(line)
    return result
                
def test():
    result = parse_org(dots2art_site())
    for page in result:
        puts("page",page.tostringall())

test()

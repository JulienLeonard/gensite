from utils           import *
from myconfiguration import *

class TemplateInstance:

    def __init__(self):
        self.mtitle        = None
        self.mtemplate     = None
        self.mlines        = []
        self.mattributes   = {}
        self.msubtemplates = []

    def tostring(self):
        return "title " + str(self.mtitle)

    def tostringall(self):
        content = []
        content.append("title : " + str(self.mtitle))
        content.append("template : " + str(self.mtemplate))
        content.append("lines : " + " - ".join(self.mlines))
        content.append("params : " + " - ".join([key + " -+- " + str(self.mattributes[key]) for key in self.mattributes]))
        content.append("subtemplates : " + " - ".join([str(t.mtitle) for t in self.msubtemplates]))
        return " # ".join(content)

    def addattribute(self,key,value,keytype):
        if key in self.mattributes and keytype == "single":
            puts("ERROR","key",key,"with value",value,"already in instance",self.tostring())

        if keytype == "single":
            self.mattributes[key] = value
        else:
            if not key in self.mattributes:
                self.mattributes[key] = []
            self.mattributes[key].append(value)

    
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
    # puts("linelevel",line,level)
    return level

def linetitle(line):
    result = line.strip("*").strip()
    # puts("linetitle",line,"title",result)
    return result

def islineparam(line):
    return (line[0] == ":")

def attrtype(paramname):
    keytype = "single"
    if paramname[-1] == "+":
        keytype = "list"
    return keytype

def lineparam(line):
    strings = line.split(":")
    key = strings[1].strip("-").strip()
    value = ":".join(strings[2:]).strip()
    keytype = attrtype(key)
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
                # puts("strip instancestack before adding new tempalte",len(cinstancestack)," templates"," ### ".join([t.tostringall() for t in cinstancestack]))
                newtemplate = TemplateInstance()
                cinstancestack.append(newtemplate)
                newtemplate.mtitle = linetitle(line)
                if newlevel == 0:
                    result.append(cinstancestack[-1])
                else:
                    #puts("cinstancestack[-2]",cinstancestack[-2].tostringall())
                    #puts("cinstancestack[-1]",cinstancestack[-1].tostringall())
                    cinstancestack[-2].msubtemplates.append(cinstancestack[-1])
                # puts("stack len",len(cinstancestack)," templates"," ### ".join([t.tostringall() for t in cinstancestack]))
                
            else:
                if islineparam(line):
                    (key,value,keytype) = lineparam(line)
                    cinstancestack[-1].addattribute(key,value,keytype)
                else:
                    cinstancestack[-1].mlines.append(line)
    return result

#
# complete shortcuts notation
#
# - if no output, output = template.html
def parse_complete(pages):
    result = []
    for page in pages:
        page = parse_complete_template(page)

        if not "output" in page.mattributes:
            
            if not "template" in page.mattributes:
                puts("ERROR page missing template",page.tostringall())
                
            page.mattributes["output"] = page.mattributes["template"] + ".html"

        result.append(page)
    return result
#
# recursive to checl every template and recurse on subtemplates
#
# - if %title%, no title and template
# - puts lines as attributes
# - if subtemplate title is -XXX-, then it is a parameter and lines are value
#
def parse_complete_template(tinstance):
    if tinstance.mtitle[0] == "%":
        template = tinstance.mtitle.strip().strip("%")
        tinstance.mtitle = None
        tinstance.mattributes["template"] = template

    if not "template" in tinstance.mattributes:
        puts("ERROR missing attribute template",tinstance.tostringall())
    else:
        tinstance.mtemplate = tinstance.mattributes["template"]
    
    if tinstance.mtemplate == None:
        puts("ERROR tinstance no template",tinstance.tostringall())

    newsubtemplates = []
    for subtemplate in tinstance.msubtemplates:
        if subtemplate.mtitle[0] == "-":
            # this is a parameter
            newattrname = subtemplate.mtitle.strip("-")
            newattrtype = attrtype(newattrname)
            tinstance.addattribute(newattrname,subtemplate.mlines,newattrtype)
        else:
            newsubtemplates.append(subtemplate)
    tinstance.msubtemplates = newsubtemplates

    newsubtemplates = []
    for subtemplate in tinstance.msubtemplates:
        newsubtemplates.append(parse_complete_template(subtemplate))
    tinstance.msubtemplates = newsubtemplates
        
    return tinstance
    
    

def pagesparser(filepath):
    result = parse_org(dots2art_site())
    result = parse_complete(result)
    # TODO: consolidate description of pages
    return result

def test():
    result = pagesparser(dots2art_site())
    for page in result:
        puts("page",page.tostringall())

# test()

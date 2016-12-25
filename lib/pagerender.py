from utils import *
from myconfiguration import *

#
# render a page described as a recursive list of template instances
#
# rules:
# - each template have a %TITLE% and a %CONTENT% match
# - subtemplates contents are aggregated to compute %CONTENT%, or if not, lines are returned
# - for a page, template is output in corresponding file
#

def templateexec(tinstance,templates,ontologies):
    content = []
        
    if len(tinstance.msubtemplates):
        for subtemplate in tinstance.msubtemplates:
            subcontent = templateexec(subtemplate,templates)
            puts("subtemplate " + subtemplate.mtitle + " content " + subcontent )
            content.append(subcontent)
    else:
         content = tinstance.mlines   

    if not tinstance.mtemplate in templates:
        puts("ERROR : template " + tinstance.mtemplate + " is not defined: nothing generated" )
        return ""
    else:
        template = templates[tinstance.mtemplate]
        puts("tinstance " + tinstance.mtitle + " template " + template.mfilepath)
        
        
        if "enumerate" in template.mattributes:
            klass = template.mattributes["klass"]
            for obj in ontologies[klass]:
                objattributes = template.mattributes[:]
                for attr in objattributes:
                    attrval  = objattributes[attr]
                    if klass in attrval:
                        (attrklass,objattr) = attrval.split(".")
                        objattributes[attr] = obj.mattributes[objattr]
                        
        return template.doexec({"%TITLE%":str(tinstance.mtitle),"%CONTENT%":"\n".join(content)})
    

def pagerender(page,templates,ontologies):
    html = templateexec(page,templates,ontologies)
    puts("Generate file " + page.mattributes["output"] + " with content " + html)
    fput( gensite_outputdir() + "/" +  page.mattributes["output"],html)
    

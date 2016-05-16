from utils import *

#
# render a page described as a recursive list of template instances
#
# rules:
# - each template have a %TITLE% and a %CONTENT% match
# - subtemplates contents are aggregated to compute %CONTENT%, or if not, lines are returned
# - for a page, template is output in corresponding file
#

def templateexec(tinstance,templates):
    content = []
    if len(tinstance.msubtemplates):
        for subtemplate in tinstance.msubtemplates:
            content.append(templateexec(subtemplate,templates))
    else:
         content = tinstance.mlines   

    template = templates[tinstance.mtemplate]
    return template.doexec({"%TITLE%":tinstance.mtitle,"%CONTENT%":"\n".join(content)})
    

def pagerender(page,templates):

    html = templateexec(page,templates)
    fput(page.mattributes["output"],html)
    

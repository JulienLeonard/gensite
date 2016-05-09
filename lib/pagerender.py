from utils import *

#
# render a page described as a recursive list of template instances
#
def pagerender(page,templates):

    if not page.mtemplate in templates:
        puts("ERROR, no template named ",page.mtemplate)
    

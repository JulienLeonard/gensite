from basics          import *
from os import listdir
from os.path import isfile, join
from template import *

def templatesload(dirpath):
    dirpath = dirpath + "/"
    filepaths = [join(dirpath, f) for f in listdir(dirpath) if isfile(join(dirpath, f))]
    templates = [Template(filepath) for filepath in filepaths]
    result = { t.name() : t for t in templates }

    puts("templatesload result")
    for template in result:
        puts("template",template,":",result[template])
    
    return result
    


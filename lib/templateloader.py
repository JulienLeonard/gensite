from os import listdir
from os.path import isfile, join

class Template:
    def __init__(self,filepath):
        self.mfilepath = filepath

    def name(self):
        return self.mfilepath.split("/")[-1].split(".")[0]
    

def templatesload(dirpath):
    dirpath = dirpath + "/"
    filepaths = [join(dirpath, f) for f in listdir(dirpath) if isfile(join(dirpath, f))]
    templates = [Template(filepath) for filepath in filepaths]
    result = { t.name() : t for t in templates }
    return result
    


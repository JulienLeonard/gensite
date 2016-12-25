from basics import *

class Template:
    def __init__(self,filepath):
        self.mfilepath = filepath

    def name(self):
        return self.mfilepath.split("/")[-1].split(".")[0]

    def doexec(self,stringmap):
        result = fread(self.mfilepath)
        puts("doexec stringmap",stringmap)
        for key in stringmap:
            result = result.replace(key,stringmap[key])
        return result

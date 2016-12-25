from utils           import *
from myconfiguration import *

from distimport import *
org2obj = distimport("C:/DEV/org2obj","org2obj")

def parseobjects(orgfilepath):
    resulttmp = org2obj.org2obj(orgfilepath)

    result = []
    for level0 in resulttmp:
        for level1 in level0.mchildren:
            result.append(level1)

    return result

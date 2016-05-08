import sys
sys.path.append("../lib")

from gensite import *

def test_parse():
    parse_org(dots2art_site())

test_parse()

from utils           import *
from myconfiguration import *
from pageparser      import *
from ontology        import *
from templateloader  import *
from pagerender      import *

pages     = pagesparser(dots2art_site())
templates = templatesload(dots2art_templates_dir())

for page in pages:
    puts("page",page.tostringall())
    pagerender(page,templates)

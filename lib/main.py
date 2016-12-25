from basics          import *
from myconfiguration import *
from pageparser      import *
from objectparser    import *
from ontology        import *
from template        import *
from templateloader  import *
from pagerender      import *

from distimport import *
mmydb = distimport("C:/PROJECTS/MYDB","mydb")
mydb  = mmydb.MYDB()

#
# Parse pages
#
puts ("Pages parsing...")
pages     = pagesparser(dots2art_site())
puts ("Pages parsing OK")
puts ("")

#
# Parse templates
#
puts ("Templates parsing...")
templates = templatesload(dots2art_templates_dir())
puts ("Templates OK")
puts ("")

#
# Build ontologies
#
puts("Build ontologies...")
ontologies = {}
ontologies["WORK"]    = parseobjects(mydb.property("DOTS2ART-WORKS-ORG"))
ontologies["PROJECT"] = parseobjects(mydb.property("DOTS2ART-PROJECTS-ORG"))
ontologies["DYNAMIC"] = parseobjects(mydb.property("DOTS2ART-DYNAMICS-ORG"))
for project in ontologies["PROJECT"]:
    puts("Project",project.mtitle)
puts("Build ontologies OK")
puts ("")

#
# render pages
#
puts("Render pages...")
for page in pages:
    puts("")
    puts("-- Render page ...",page.tostringall())

    if not "nopage" in page.mattributes:
        pagerender(page,templates,ontologies)

    puts("-- Render page OK",page.tostringall())
    puts("")

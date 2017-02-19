
#
# gen pages
#
proc gen_pages {} {
    global pages

    set HEADER [gen_header]
    set FOOTER [gen_footer]

    foreach page $pages(list) {
	if {![string match %* $page]} {
	    puts "gen $page template $pages($page,template)"

	    foreach {template} [templates_load $pages($page,template)] break
	    
	    set CONTENT [list]
	    lappend CONTENT [h1 $page]

	    foreach line $pages($page,lines) {
		lappend CONTENT [p [org2html $line]]
	    }
	    
	    foreach section $pages($page,sections) {
		lappend CONTENT [h2 $section]
		foreach line $pages($page,$section,lines) {
		    lappend CONTENT [p [org2html $line]]
		}
	    }
	    set CONTENT [join $CONTENT \n]

	    set filepath [gensite_outputdir]/$page.html
	    set url      [relpath [gensite_outputdir]/ $filepath]
	    fput $filepath [string map [list %TITLE% $page %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
	    set pages($page,url) $url

	}
    }
}

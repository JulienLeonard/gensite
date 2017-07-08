source distsource.tcl
distsource ../../utils utils.tcl
distsource ../../utils mydb.tcl
set myDB [MYDB]


proc dots2art_site           {} {return [MYDBPROP "DOTS2ART-SITE-ORG"]}
proc dots2art_templates_dir  {} {return [MYDBPROP "DOTS2ART-SITE-TEMPLATE-DIR-TEMP"]}
proc gensite_outputdir       {} {return [MYDBPROP "DOTS2ART-SITE-OUTPUT-TEMP"]}
proc gensite_image_outputdir {} {return [MYDBPROP "DOTS2ART-SITE-IMAGE-OUTPUT-TEMP"]}
proc gensite_anim_outputdir  {} {return [MYDBPROP "DOTS2ART-SITE-ANIM-OUTPUT-TEMP"]}
proc gensite_anim_sourcedir  {} {return [MYDBPROP "DOTS2ART-ARCHIVE-DYNAMICS-DIR"]}


proc relpath {basepath path} {
    return [string map [list $basepath ""] $path]
}



proc genimageurl {imagepath} {
    # puts "genimageurl for imagepath $imagepath"
    set imagepath [string map [list file:// ""] $imagepath]
    set filename [lback [split $imagepath /]]
    set outputfilepath [gensite_image_outputdir]/[string map [list " " "-" "_" "-"] $filename]
    if {![file exists $imagepath]} {
	puts "ERROR: image filepath $imagepath does not exist"
	return ""
    } else {
	if {![file exists $outputfilepath]} {
	    file copy -force $imagepath $outputfilepath
	}
	set result [relpath [gensite_outputdir]/ $outputfilepath]
	# puts "genimageurl result $result"
	return $result
    }
}

proc template_load {name} {
    distsource [dots2art_templates_dir] $name.tcl
    return $template
}

proc templates_load {name} {
    distsource [dots2art_templates_dir] $name.tcl
    return $templates
}

proc htmlurlstring {string} {
    return [string map [list " " "-" "_" "-" "." "-"] [string tolower $string]]
}

proc htmlaltstring {string} {
    return [string map [list "-" " "] [htmlurlstring $string]]
}

proc workhtmlfilepath {work} {
    set work         [htmlurlstring $work]
    set workfilepath [gensite_outputdir]/$work.html
    return $workfilepath
}

proc projecthtmlfilepath {project} {
    set project         [htmlurlstring $project]
    set projectfilepath [gensite_outputdir]/$project.html
    return $projectfilepath
}

proc dynamichtmlfilepath {dynamic} {
    set dynamic         [htmlurlstring $dynamic]
    set dynamicfilepath [gensite_outputdir]/$dynamic.html
    return $dynamicfilepath
}

proc tutorialhtmlfilepath {tutorial} {
    set tutorial         [htmlurlstring $tutorial]
    set tutorialfilepath [gensite_outputdir]/$tutorial.html
    return $tutorialfilepath
}


proc workurl {work} {
    set workurl      [relpath [gensite_outputdir]/ [workhtmlfilepath $work]]
    return $workurl
}

proc projecturl {project} {
    set projecturl      [relpath [gensite_outputdir]/ [projecthtmlfilepath $project]]
    return $projecturl
}

proc dynamicurl {dynamic} {
    set dynamicurl      [relpath [gensite_outputdir]/ [dynamichtmlfilepath $dynamic]]
    return $dynamicurl
}

proc tutorialurl {tutorial} {
    set tutorialurl      [relpath [gensite_outputdir]/ [tutorialhtmlfilepath $tutorial]]
    return $tutorialurl
}



#
# map org concepts to html concepts (for the moment only links)
#
proc org2html {line} {
    set result [list]

    set line [string map {+BEGIN_HTML "" +END_HTML ""} $line]
    
    foreach word $line {
	# puts "word $word"
	
	if {[string match "\\\[*" $word]} {
	    # puts "match link $word  split [split $word \"\[\]\"]"
	    foreach {dum dum link dum text} [split $word "\[\]"] break
	    set word [a $link $text]
	} 
	lappend result $word
    }
    return [join $result " "]
}

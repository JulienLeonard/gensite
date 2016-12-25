
#
# gen tutorial thumbnail
#
proc gen_tutorial_thumbnail {atutorials tutorialtemplate tutorial} {
    array set tutorials $atutorials

    set imageurl [thumbnail_url [genimageurl $tutorials($tutorial,imageheader)]]
    set title    $tutorial
    set link     [tutorialurl $tutorial]
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl] $tutorialtemplate]
}


#
# gen_tutorials_page
#
proc gen_tutorials_page {atutorials} {

    array set tutorials $atutorials
    
    foreach {template tutorialtemplate} [templates_load index] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    
    set CONTENT [list]
    lappend CONTENT [h1 Tutorials]
    foreach tutorial $tutorials(list) {
	puts "gen thumbnail tutorial $tutorial"
	lappend CONTENT [gen_tutorial_thumbnail $atutorials $tutorialtemplate $tutorial]
    }	
    
    set CONTENT [join $CONTENT \n]
    
    set filepath [gensite_outputdir]/tutorials.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    return [array get tutorials]
}


#
# generate page for each tutorials
#
proc gen_tutorials {atutorials maxntutorials} {
    # array set tutorials $atutorials
    
    # first generate all the tutorial pages
    array set tutorials $atutorials
    # set maxntutorials 1000
    set ntutorials 0
    foreach tutorial $tutorials(list) {
	set atutorials [gen_tutorial $atutorials $tutorial]

	incr ntutorials    
	if {$ntutorials > $maxntutorials} {
	    break
	}
    }

    return $atutorials
}

proc tutoimagefilepath {filename} {
    set imagefilename $filename
    set found 0
    foreach dir {C:/archive/dots2art/images/bigs/archive C:/archive/dots2art/images/source C:/DEV/PVG/examples C:/archive/dots2art/images/tuto} {
	if {[file exists "${dir}/$imagefilename"]} {
	    set imagefilepath "${dir}/$imagefilename"
	    set found 1
	    break
	}
    }

    if {!$found} {
	puts "ERROR: imagefilename $imagefilename not found"
	return ""
    } 
    return $imagefilepath
}

#
# tuto2html
#
proc tuto2html {line} {
    set result [list]

    if {[string match IMAGE:* $line]} {
	set imagefilename [string trim [lindex $line end]]
	set imagefilepath [tutoimagefilepath $imagefilename]
	if {![sempty $imagefilepath]} {
	    return [img [genimageurl $imagefilepath]]
	}
	return ""
    } elseif {[string match IMAGES:* $line]} {
	set imgtags [list]
	foreach imagefilename [lrange $line 1 end] {
	    set imagefilepath [tutoimagefilepath $imagefilename]
	    if {![sempty $imagefilepath]} {
		lappend imgtags [img [genimageurl $imagefilepath]]
	    }
	}
	return [join $imgtags "\n"]
    } elseif {[string match IMAGEFROMSCRIPT:* $line]} {
	puts "line IMAGEFROMSCRIPT $line"
	set scriptfilepath [string map [list \[ "" \] "" \\ /] [string trim [lindex [split $line " "] end]]]
	set scriptfilename [lback [split $scriptfilepath /]]
	set imagefilename  [string map [list .py .png] $scriptfilename]
	set imagefilepath [tutoimagefilepath $imagefilename]
	if {![sempty $imagefilepath]} {
	    return [img [genimageurl $imagefilepath]]
	}
	return ""
    } elseif {[string match RESULT:* $line]} {
	return ""
    } else {
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
}

#
# gen_tutorial
#
proc gen_tutorial {atutorials tutorial} {
    array set tutorials $atutorials

    set HEADER [gen_header]
    set FOOTER [gen_footer]

    foreach {template worktemplate} [templates_load project] break

    # array set projects $aprojects
    set title $tutorial

    # puts "image $tutorial title $title"
    # check and copy image header if not existing 
    #set filename $tutorials($tutorial,imageheader)
    #if {[file exists ${rootpath}/$filename]} {
    #file copy -force ${rootpath}/$filename [gensite_outputdir]/images/$filename]
    #}
    
    
    set CONTENT [list]
    lappend CONTENT [h1 $tutorial]
    # lappend CONTENT [div one-third-column [img [thumbnail_url [genimageurl $tutorials($tutorial,imageheader)]]]]
    # lappend CONTENT [p [string trim $tutorials($tutorial,description) "\{\}"]]
    # eval lappend CONTENT $tutorials($tutorial,code)

    foreach line $tutorials($tutorial,lines) {
	puts "tuto line $line"
	lappend CONTENT [p [tuto2html $line]]
    }
    # eval lappend CONTENT $tutorials($tutorial,lines)
    foreach section $tutorials($tutorial,sections) {
	lappend CONTENT [h2 $section]
	foreach line $tutorials($tutorial,$section,lines) {
	    puts "section line $line"
	    lappend CONTENT [p [tuto2html $line]]
	    # eval lappend CONTENT $tutorials($tutorial,$section,lines)
	}
    }
    
    
    set CONTENT [join $CONTENT \n]
    
    set tutorialurl      [tutorialurl $tutorial]
    set tutorialfilepath [tutorialhtmlfilepath $tutorial]

    fput $tutorialfilepath [string map [list %TITLE% $title %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    set tutorials($tutorial,url) $tutorialurl

    return [array get tutorials]
}

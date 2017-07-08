
#
# generate page for a work
#
proc gen_work {cwork} {
    global works
    puts "gen_work $cwork"
    
    set template [template_load work]

    set title unknown
    if {[info exists works($cwork,title)]} {
	set title $works($cwork,title)
    }
    set ID        $cwork
    set imagepath $works($cwork,picture)
    
    # puts "image $cwork title $title"
    set workfilepath [workhtmlfilepath $ID]
    set workurl      [workurl $ID]

    set CONTENT [list]
    set imagepath [string map [list file:// ""] $imagepath]
    lappend CONTENT [h1 $title]
    lappend CONTENT [img [genimageurl $imagepath] $title]
    set CONTENT [join $CONTENT \n]
    # fput $workfilepath [string map [list %TITLE% $title %CONTENT% $CONTENT] $template]
    set HEADER [gen_header]
    set FOOTER [gen_footer]

    set CONTENT [join $CONTENT \n]
    fput $workfilepath [string map [list %HEADER% $HEADER %FOOTER% $FOOTER %TITLE% $title %CONTENT% $CONTENT] $template]

    set works($cwork,url) $workurl
    # return [list $cwork $title $workurl]
}

#
# generate page for the worklist
#
proc gen_works {maxnworks} {
    global works
    
    # first generate all the work pages
    # array set works $aworks
    # set maxnworks 100
    set nworks 0
    foreach work $works(list) {
	gen_work $work

	incr nworks
	if {$nworks > $maxnworks} {
	    break
	}
    }
}

#
# generate page for the worklist
# works pages must have already been generated
#
proc gen_worklist {maxnworks} {
    global works
    
    # then generate list
    set template [template_load worklist]

    set CONTENT [list]
    foreach work $works(list) {
	set title $works($work,title)
	set url   $works($work,url)
	lappend CONTENT [section [a $workurl $title]]
    }
    
    set CONTENT [join $CONTENT \n]

    set workfilepath [gensite_outputdir]/worklist.html
    set workurl      [relpath [gensite_outputdir]/ $workfilepath]
    fput $workfilepath [string map [list %TITLE% WORKLIST %CONTENT% $CONTENT] $template]
    return $workurl
}

#
# generate thumbnail for work
#
proc gen_work_thumbnail {worktemplate work} {
    global works

    #set imageurl [genimageurl $image]
    #set title    $work
    #set link     [workurl $work]
    #lappend CONTENT [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl] $worktemplate]

    set imageurl [thumbnail_url [genimageurl $works($work,picture)]]
    if {[info exists works($work,title)]} {
	set title    $works($work,title)
    } else {
	set title $work
    }
    set link     [workurl $work]
    # puts "gen_work_thumbnail work $work image $imageurl"

    if {![info exists works($work,url)]} {
	gen_work $work
    }
    set ALT [htmlaltstring $title]
    
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl %ALT% $ALT] $worktemplate]
}

#
# generate work full
#
proc gen_work_full {worktemplate work} {
    global works

    #set imageurl [genimageurl $image]
    #set title    $work
    #set link     [workurl $work]
    #lappend CONTENT [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl] $worktemplate]

    set imageurl [genimageurl $works($work,picture)]
    if {[info exists works($work,title)]} {
	set title    $works($work,title)
    } else {
	set title $work
    }
    set link     [workurl $work]
    # puts "gen_work_thumbnail work $work image $imageurl"

    if {![info exists works($work,url)]} {
	gen_work $work
    }
    set ALT [htmlaltstring $title]
    
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl %ALT% $ALT] $worktemplate]
}


#
# work timeline
#
proc gen_work_timeline {timeline} {
    set template [template_load worktimeline]

    set CONTENT [list]
    foreach item $timeline {
	foreach {timestamp workdata} $item break
	foreach {work image} $workdata break
	set workurl [workurl $work]
	lappend CONTENT [section "[clock format $timestamp -format {%D}] [a $workurl $work]"]
    }
    set CONTENT [join $CONTENT \n]

    set filepath [gensite_outputdir]/worktimeline.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    
    fput $filepath [string map [list %CONTENT% $CONTENT] $template]
    return $url
}

#
# work timeline per day
#
proc gen_work_day_timeline {timeline} {
    set template [template_load worktimeline]

    # generate day list
    array set days [list]
    set days(list) [list]
    set lasttime  [lfront [lfront $timeline]]
    set firsttime [lfront [lback  $timeline]]
    set currenttime $lasttime
    set currentday [clock format $lasttime -format {%D}]
    set firstday   [clock format $firsttime -format {%D}]
    set mustbreak 0
    while {!$mustbreak} {
	if {[s= $currentday $firstday]} {
	    set mustbreak 1
	}
	lappend days(list) $currentday
	set days($currentday,works) [list]
	set currenttime [clock add $currenttime -1 day]
	set currentday  [clock format $currenttime -format {%D}]
	puts "currentday $currentday"
    }

    # filled with works
    array set images [list]
    foreach item $timeline {
	foreach {timestamp workdata} $item break
	foreach {work image} $workdata break
	set images($work) $image
	set day [clock format $timestamp -format {%D}]
	lappend days($day,works) $work
    }
    
    # generate content
    set CONTENT [list]
    foreach day $days(list) {
	if {[llength $days($day,works)]} {
	    lappend CONTENT "<h1 style=\"background-color:#ffffaa\">$day</h1>"
	    set worklist [list]
	    foreach work $days($day,works) {
		set workurl   [workurl $work]
		lappend worklist "<a href=\"$workurl\"><img width=\"200\" height=\"200\" src=\"[genimageurl $images($work)]\"/></a>"
	    }
	    set worklist [join $worklist " . "]
	    lappend CONTENT "<section>$worklist</section>"
	} else {
	    lappend CONTENT "<section style=\"background-color:#aaaaff\">.</section>"
	}
    }
    set CONTENT [join $CONTENT \n]

    set filepath [gensite_outputdir]/worktimeline.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    
    fput $filepath [string map [list %CONTENT% $CONTENT] $template]
    return $url
}


#
# gen portfolio
#
proc gen_portfolio {timeline} {
    global works
    
    foreach {template worktemplate} [templates_load portfolio] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    set pageindex 0

    set pages [ldivide $timeline 9]
    
    foreach 9works $pages {	
	set CONTENT [list]
	foreach item $9works {
	    foreach {timestamp workdata} $item break
	    foreach {work image} $workdata break

	    lappend CONTENT [gen_work_thumbnail $worktemplate $work]
	    
	    # puts "work $work image $image"
	    
	    # set imageurl [genimageurl $image]
	    # set title    $work
	    # set link     [workurl $work]
	    # lappend CONTENT [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl] $worktemplate]
	}	
	set CONTENT [join $CONTENT \n]

	if {$pageindex == 0} {
	    set filepath [gensite_outputdir]/blog.html
	} else {
	    set filepath [gensite_outputdir]/blog-$pageindex.html
	}
	set url      [relpath [gensite_outputdir]/ $filepath]
	if {$pageindex < [llength $pages] - 1} {
	    set NEXT     [a blog-[+ $pageindex 1].html Next]
	} else {
	    set NEXT ""
	}
	fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER %NEXT% $NEXT] $template]
	incr pageindex
    }
    return $url
}

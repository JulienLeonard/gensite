
#
# generate page for a project
#
proc gen_project {project} {
    global projects
    
    puts "gen_project $project ..."
    # set template [template_load project]
    foreach {template worktemplate} [templates_load project] break

    # array set projects $aprojects
    set title $project

    # puts "image $project title $title"
    
    set projecturl      [projecturl $project]
    set projectfilepath [projecthtmlfilepath $project]
    
    set CONTENT [list]
    lappend CONTENT [h1 $project]
    lappend CONTENT [p [string trim $projects($project,description) "\{\}"]]

    foreach work $projects($project,works) {
     	# puts "project $project work $work"
     	lappend CONTENT [gen_work_thumbnail $worktemplate $work] 
    }	

    set HEADER [gen_header]
    set FOOTER [gen_footer]

    set CONTENT [join $CONTENT \n]
    fput $projectfilepath [string map [list %HEADER% $HEADER %FOOTER% $FOOTER %TITLE% $title %CONTENT% $CONTENT] $template]

    set projects($project,url) $projecturl
    # return [list $project $title $projecturl]
    # return [array get projects]
}

#
# generate page for each projects
#
proc gen_projects {maxnprojects} {
    global projects
    # array set projects $aprojects
    
    # first generate all the project pages
    # set maxnprojects 1000
    set nprojects 0
    foreach project $projects(list) {
	gen_project $project

	incr nprojects    
	if {$nprojects > $maxnprojects} {
	    break
	}
    }
}

#
# generate page for the projectlist
#
proc gen_projectlist {} {

    # first generate all the project pages
    global projects
    set maxnprojects 1000
    set nprojects 0
    foreach project $projects(list) {
	eval lappend projecturls [gen_project $aprojects $project]
	incr nprojects
	    
	if {$nprojects > $maxnprojects} {
	    break
	}
    }

    # then generate list
    set template [template_load projectlist]

    set CONTENT [list]
    lappend CONTENT [h1 Projects]
    foreach {project title projecturl} $projecturls {
	lappend CONTENT [section [a $projecturl $title]]
    }    
    set CONTENT [join $CONTENT \n]

    set projecturl [relpath [gensite_outputdir]/ [gensite_outputdir]/projectlist.html]
    set projectfilepath [gensite_outputdir]/projectlist.html
    
    fput $projectfilepath [string map [list %TITLE% PROJECTLIST %CONTENT% $CONTENT] $template]
    return $projecturl
}

#
# gen project thumbnail
#
proc gen_project_thumbnail {projecttemplate project} {
    global projects
    global works
    
    set workheader $projects($project,workheader)
    
    # puts "project $project workheader $workheader"
    
    # foreach {timestamp workdata} $item break
    # foreach {work image} $workdata break
    if {![sempty $workheader]} {
	set imageurl [thumbnail_url [genimageurl $works($workheader,picture)]]
    } else {
	set imageurl ""
    }
    set title    $project
    set link     [projecturl $project]
    set ALT      [htmlaltstring $project]
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl %ALT% $ALT] $projecttemplate]
}

#
# gen_projects
#
proc gen_projects_page {} {
    global projects
    global works   

    # foreach work $works(list) {
    #  	puts "work $work"
    # }
    
    foreach {template projecttemplate} [templates_load projects] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    set pageindex 0
    set pages [ldivide $projects(list) 9]
    
    foreach 9projects $pages {
	set CONTENT [list]
	lappend CONTENT [h1 Series]

	foreach project $9projects {
	    lappend CONTENT [gen_project_thumbnail $projecttemplate $project]
	}	
    
	set CONTENT [join $CONTENT \n]

	if {$pageindex == 0} {
	    set filepath [gensite_outputdir]/projects.html
	} else {
	    set filepath [gensite_outputdir]/projects-$pageindex.html
	}
	set url      [relpath [gensite_outputdir]/ $filepath]
	if {$pageindex < [llength $pages] - 1} {
	    set NEXT     [a projects-[+ $pageindex 1].html Next]
	} else {
	    set NEXT ""
	}
	fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER %NEXT% $NEXT] $template]
	incr pageindex
    }
    return $url
}

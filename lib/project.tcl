
#
# generate page for a project
#
proc gen_project {aprojects aworks project} {
    puts "gen_project $project ..."
    array set projects $aprojects
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
     	puts "project $project work $work"
     	lappend CONTENT [gen_work_thumbnail $aworks $worktemplate $work] 
    }	

    set HEADER [gen_header]
    set FOOTER [gen_footer]

    set CONTENT [join $CONTENT \n]
    fput $projectfilepath [string map [list %HEADER% $HEADER %FOOTER% $FOOTER %TITLE% $title %CONTENT% $CONTENT] $template]

    set projects($project,url) $projecturl
    # return [list $project $title $projecturl]
    return [array get projects]
}

#
# generate page for each projects
#
proc gen_projects {aprojects aworks maxnprojects} {
    # array set projects $aprojects
    
    # first generate all the project pages
    array set projects $aprojects
    # set maxnprojects 1000
    set nprojects 0
    foreach project $projects(list) {
	set aprojects [gen_project $aprojects $aworks $project]

	incr nprojects    
	if {$nprojects > $maxnprojects} {
	    break
	}
    }

    return $aprojects
}

#
# generate page for the projectlist
#
proc gen_projectlist {aprojects} {

    # first generate all the project pages
    array set projects $aprojects
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
proc gen_project_thumbnail {aprojects aworks projecttemplate project} {
    array set projects $aprojects
    array set works    $aworks
    
    set workheader $projects($project,workheader)
    
    puts "project $project workheader $workheader"
    
    # foreach {timestamp workdata} $item break
    # foreach {work image} $workdata break
    if {![sempty $workheader]} {
	set imageurl [thumbnail_url [genimageurl $works($workheader,picture)]]
    } else {
	set imageurl ""
    }
    set title    $project
    set link     [projecturl $project]
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl] $projecttemplate]
}

#
# gen_projects
#
proc gen_projects_page {aprojects aworks} {

    array set projects $aprojects
    array set works    $aworks

    # foreach work $works(list) {
    #  	puts "work $work"
    # }
    
    foreach {template projecttemplate} [templates_load index] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    
    set CONTENT [list]
    lappend CONTENT [h1 Projects]

    foreach project $projects(list) {
	lappend CONTENT [gen_project_thumbnail $aprojects $aworks $projecttemplate $project]
    }	
    
    set CONTENT [join $CONTENT \n]
    
    set filepath [gensite_outputdir]/projects.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    return $url
}

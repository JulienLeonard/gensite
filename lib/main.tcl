source utils.tcl
source datautils.tcl
source siteutils.tcl
source htmlutils.tcl

source work.tcl
source project.tcl
source dynamic.tcl
source tutorial.tcl
source page.tcl

source thumbnail.tcl

#
# gen_menu
#
proc gen_menu {} {
    foreach {menutemplate} [templates_load menu] break
    
    set MENUS [list]
    foreach {link text} {projects.html series dynamics.html dynamics tutorials.html tutorials About.html about Shop.html shop} {
	lappend MENUS [string map [list %LINK% $link %TEXT% $text] $menutemplate]
    }
    set MENUS [join $MENUS \n]
    return $MENUS
}

#
# gen_header
#
proc gen_header {} {
    set MENUS [gen_menu]
    
    foreach {headertemplate} [templates_load header] break

    return [string map [list %MENUS% $MENUS] $headertemplate]
}

#
# gen_footer
#
proc gen_footer {} {
    foreach {footertemplate} [templates_load footer] break

    return [string map [list] $footertemplate]
}


#
# gen_index 
#
proc gen_index {} {
    global projects
    global works   
    global dynamics
    global tutorials

    # foreach work $works(list) {
    #  	puts "work $work"
    # }
    
    foreach {template projecttemplate} [templates_load index] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    
    set CONTENT [list]

    lappend CONTENT [h1 "Generative art by Julien Leonard"]

    lappend CONTENT [h2 [a blog.html Latest]]
    foreach work [lrange $works(list) 0 2] {
	lappend CONTENT [gen_work_thumbnail $projecttemplate $work]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ blog.html] More]]

    lappend CONTENT [h2 [a projects.html Series]]
    foreach project [lrange $projects(list) 0 2] {
	lappend CONTENT [gen_project_thumbnail $projecttemplate $project]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ projects.html] More]]


    lappend CONTENT [h2 [a dynamics.html Dynamics]]
    foreach dynamic [lrange $dynamics(list) 0 2] {
	lappend CONTENT [gen_dynamic_thumbnail $projecttemplate $dynamic]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ dynamics.html] More]]

    lappend CONTENT [h2 [a tutorials.html Tutorials]]
    foreach tutorial [lrange $tutorials(list) 0 2] {
	lappend CONTENT [gen_tutorial_thumbnail $projecttemplate $tutorial]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ tutorials.html] More]]

    
    set CONTENT [join $CONTENT \n]
    
    set filepath [gensite_outputdir]/index.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    return $url
}

#

#
# main generator
#
proc main {} {
    global tutorials
    global projects
    global works
    global dynamics
    global pages
    
    set worklisturl    ""
    set projectlisturl ""
    set timelineurl    ""
    set portfoliourl   ""

    puts "START generation ... "

    load_tutorials_data
    gen_tutorials 100
    gen_tutorials_page
    
    load_dynamics_data
    gen_dynamics 100
    gen_dynamics_page
    
    load_pages_data
    gen_pages
    
    load_works_data
    load_projects_data

    # array set projects $aprojects
    #puts "projects list $projects(list)"
    #puts "sublist  [ldivide $projects(list) 9]"
    
    gen_works 1000
    gen_projects 100
    
    set timeline       [timeline_works 1000]
    # set timelineurl    [gen_work_day_timeline $timeline]     

    gen_projects_page

    gen_portfolio $timeline

    gen_index

    checkthumbnails
    
    puts "generation DONE at [gensite_outputdir]"
}

main

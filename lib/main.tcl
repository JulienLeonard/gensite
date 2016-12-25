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
    foreach {link text} {index.html home projects.html projects dynamics.html dynamics tutorials.html tutorials blog.html blog About.html about Shop.html shop} {
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
proc gen_index {aprojects aworks adynamics atutorials} {

    array set projects  $aprojects
    array set works     $aworks
    array set dynamics  $adynamics
    array set tutorials $atutorials

    # foreach work $works(list) {
    #  	puts "work $work"
    # }
    
    foreach {template projecttemplate} [templates_load index] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    
    set CONTENT [list]


    lappend CONTENT [h1 Latest]
    foreach work [lrange $works(list) 0 2] {
	lappend CONTENT [gen_work_thumbnail $aworks $projecttemplate $work]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ blog.html] More]]

    lappend CONTENT [h1 Projects]
    foreach project [lrange $projects(list) 0 2] {
	lappend CONTENT [gen_project_thumbnail $aprojects $aworks $projecttemplate $project]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ projects.html] More]]


    lappend CONTENT [h1 Dynamics]
    foreach dynamic [lrange $dynamics(list) 0 2] {
	lappend CONTENT [gen_dynamic_thumbnail $adynamics $projecttemplate $dynamic]
    }	
    # lappend CONTENT [h2 [a [relpath [gensite_outputdir]/ dynamics.html] More]]

    lappend CONTENT [h1 Tutorials]
    foreach tutorial [lrange $tutorials(list) 0 2] {
	lappend CONTENT [gen_tutorial_thumbnail $atutorials $projecttemplate $tutorial]
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
    set worklisturl    ""
    set projectlisturl ""
    set timelineurl    ""
    set portfoliourl   ""

    puts "START generation ... "

    set atutorials [tutorials_data]
    set atutorials [gen_tutorials $atutorials 100]
    set atutorials [gen_tutorials_page $atutorials]
    
    set adynamics [dynamics_data]

    set adynamics [gen_dynamics $adynamics 100]
    set adynamics [gen_dynamics_page $adynamics]
    
    set apages [pages_data]
    set apages [gen_pages $apages]
    
    set aworks         [works_data]
    set aprojects      [projects_data $aworks]
    
    set aworks         [gen_works $aworks 10]
    set aprojects      [gen_projects $aprojects $aworks 100]
    
    set timeline       [timeline_works $aworks 10]
    # set timelineurl    [gen_work_day_timeline $timeline]     

    gen_projects_page $aprojects $aworks

    gen_portfolio $aworks $timeline

    gen_index $aprojects $aworks $adynamics $atutorials

    checkthumbnails
    
    puts "generation DONE at [gensite_outputdir]"
}

main

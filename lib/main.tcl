source distsource.tcl
distsource ../../utils utils.tcl
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
proc gen_menu {{selected ""}} {
    foreach {menutemplate} [templates_load menu] break
    
    set MENUS [list]
    # foreach {link text} {projects.html series dynamics.html dynamics tutorials.html tutorials About.html about Shop.html shop} {}
    foreach {link text} {portfolio.html see tutorials.html learn dynamics.html watch About.html ask Shop.html shop} {
	set color #FFFFFF
	set textcolor #000000
	if {[s= $selected $text]} {
	    set color #000000
	    set textcolor #FFFFFF
	}
	
	lappend MENUS [string map [list %LINK% $link %TEXT% $text %COLOR% $color %TEXTCOLOR% $textcolor] $menutemplate]
    }
    set MENUS [join $MENUS \n]
    return $MENUS
}

#
# gen_header
#
proc gen_header {{selected ""}} {
    set MENUS [gen_menu $selected]
    
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
#
#
proc gen_portfolio {} {

    foreach {template full_worktemplate thumbnail_worktemplate full_imagetemplate} [templates_load index] break

    set HEADER [gen_header see]
    set FOOTER [gen_footer]
    
    set CONTENT [list]

    lappend CONTENT [gen_image_full $full_imagetemplate Orion]
    
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate "Coeur De Boeuf_1499165390" ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Angel_1499165201 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Tisseuse_1499164943 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Graphite_1499083983 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Nazgul_1499084177 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Autel_1499083698 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Succulent_1498981244 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Hole_1498981057 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate "Black Snow_1498980766"]

    lappend CONTENT [gen_image_full $full_imagetemplate Orion]
    
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Capture_1498308972 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Helioscope_1498476971 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Net_1498948841 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate "Ying Yang Spiral_1497763156" ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Giggles_1497764173 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate "Coeur De Boeuf_1499165390" ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Hole_1498981057 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Succulent_1498981244 ]
    lappend CONTENT [gen_work_thumbnail $thumbnail_worktemplate Synapse_1498469398]
    
    lappend CONTENT [gen_image_full $full_imagetemplate 2000th]

    set CONTENT [join $CONTENT \n]
    
    set filepath [gensite_outputdir]/portfolio.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    return $url
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
    
    foreach {template full_worktemplate thumbnail_worktemplate full_imagetemplate} [templates_load index] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    
    set CONTENT [list]

    # foreach project [lrange $projects(list) 0 8] {
    # 	lappend CONTENT [gen_project_thumbnail $worktemplate $project]
    # }	


    # lappend CONTENT [h2 [a blog.html Latest]]
    # foreach work [lrange $works(list) 0 2] {
    # 	lappend CONTENT [gen_work_thumbnail $worktemplate $work]
    # }	


    # lappend CONTENT [h2 [a dynamics.html Dynamics]]
    # foreach dynamic [lrange $dynamics(list) 0 2] {
    # 	lappend CONTENT [gen_dynamic_thumbnail $worktemplate $dynamic]
    # }	

    # lappend CONTENT [h2 [a tutorials.html Tutorials]]
    # foreach tutorial [lrange $tutorials(list) 0 2] {
    # 	lappend CONTENT [gen_tutorial_thumbnail $worktemplate $tutorial]
    # }	

    lappend CONTENT [gen_image_full $full_imagetemplate Nidation]

    lappend CONTENT {<div class="sixteen columns introtext">}
    lappend CONTENT {<p>Welcome to the generative art of Julien Leonard, a french-born Singapore-resident dot artist.</p>}
    lappend CONTENT {</div>}
    
    lappend CONTENT [gen_image_full $full_imagetemplate 2000th]

    lappend CONTENT {<div class="sixteen columns introtext">}
    lappend CONTENT {<p>Each artwork is made of hundred thousands of dots generated by a custom algorithm,designed and implemented by the artist, growing from a unique seed.</p>}
    lappend CONTENT {</div>}

    lappend CONTENT [gen_image_full $full_imagetemplate Orion]

    lappend CONTENT {<div class="sixteen columns introtext">}
    lappend CONTENT {<p>The intricacy of the patterns reminds one of the luxuriance of equatorial jungles, the complexity of microscopic organisms, or the elaborated designs of South east Asia batiks.</p>}
    lappend CONTENT {</div>}

    lappend CONTENT [gen_image_full $full_imagetemplate Helioscope]
    
    lappend CONTENT {<div class="sixteen columns introtext">}
    lappend CONTENT {<p>Only black dots, no intersection, no isolation, from 2 to 1 billion, one at a time</p>}
    lappend CONTENT {</div>}
        
    lappend CONTENT [gen_image_full $full_imagetemplate Splicing]
    
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
    
    # gen_works 1000
    # gen_projects 100
    
    set timeline       [timeline_works 1000]
    # set timelineurl    [gen_work_day_timeline $timeline]     

    # gen_projects_page

    # gen_portfolio $timeline

    gen_portfolio
    
    gen_index

    checkthumbnails

    # copy css
    foreach filepath [glob -dir ../css *.css] {
	file copy -force $filepath [gensite_outputdir]/css
    }

    # copy javascript
    foreach filepath [glob -dir ../javascript *.js] {
	file copy -force $filepath [gensite_outputdir]/javascript
    }

    puts "generation DONE at [gensite_outputdir]"
}

main

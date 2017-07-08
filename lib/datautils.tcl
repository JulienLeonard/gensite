source distsource.tcl
distsource ../../utils utils.tcl
distsource ../../utils mydb.tcl
set myDB [MYDB]

proc gensite_index_filepath     {} {return [MYDBPROP "DOTS2ART-INDEX-ORG"]}
proc gensite_works_filepath     {} {return [MYDBPROP "DOTS2ART-WORKS-ORG"]}
proc gensite_projects_filepath  {} {return [MYDBPROP "DOTS2ART-PROJECTS-ORG"]}
proc gensite_dynamics_filepath  {} {return [MYDBPROP "DOTS2ART-DYNAMICS-ORG"]}
proc gensite_tutorials_filepath {} {return [MYDBPROP "DOTS2ART-TUTORIALS-ORG"]}


#
# parse page data
#
proc load_pages_data {} {
    global pages

    distsource ../../org2obj org2obj.tcl

    array set orgpages [org2obj [gensite_index_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $orgpages(levels) {
	puts "page title $orgpages($level,title)"
	set pageID $orgpages($level,title)
	lappend result(list) $pageID
	set result($pageID,sections) [list]

	# get template
	if {[info exists orgpages($level,param,template) ]} {
	    set result($pageID,template) $orgpages($level,param,template)
	}
	set result($pageID,lines) $orgpages($level,lines)
	
	foreach section $orgpages($level,children) {
	    set sectionID $orgpages($section,title)
	    lappend result($pageID,sections) $sectionID
	    set result($pageID,$sectionID,lines) $orgpages($section,lines)
	}
    }

    array set pages [array get result]
}


#
# parse work org file then transform the data for efficiency and praticability
#
proc load_works_data {} {
    global works
    
    distsource ../../org2obj org2obj.tcl

    array set orgworks [org2obj [gensite_works_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $orgworks(levels) {
	foreach work $orgworks($level,children) {
	    set ID $orgworks($work,title)
	    lappend result(list) $ID
	    foreach param $orgworks($work,params) {
		set result($ID,$param) $orgworks($work,param,$param)
	    }
	    foreach sublevel $orgworks($work,children) {
		foreach param $orgworks($sublevel,params) {
		    set result($ID,$param) $orgworks($sublevel,param,$param)
		}
	    }
	}
    }
    
    array set works [array get result]
}

#
# parse dynamics data
#
proc load_dynamics_data {} {
    global dynamics
    distsource ../../org2obj org2obj.tcl

    array set orgdynamics [org2obj [gensite_dynamics_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $orgdynamics(levels) {
	foreach dynamic $orgdynamics($level,children) {
	    set ID $orgdynamics($dynamic,title)

	    set result($ID,imageheader) $orgdynamics($dynamic,param,imageheader)
	    foreach dir {C:/archive/dots2art/images/bigs/archive C:/archive/dots2art/images/source} {
		if {[file exists "${dir}/$orgdynamics($dynamic,param,imageheader)"]} {
		    set result($ID,imageheader)  "${dir}/$orgdynamics($dynamic,param,imageheader)"
		    break
		}
	    }
	    set result($ID,description)   $orgdynamics($dynamic,param,description)
	    set result($ID,jsdir)         $orgdynamics($dynamic,param,jsdir)
	    set result($ID,js)            [string trim $orgdynamics($dynamic,param,js)]
	    set result($ID,d3)            [string trim $orgdynamics($dynamic,param,d3)]
	    set result($ID,libsinside)    [string trim $orgdynamics($dynamic,param,libsinside)]
	    set result($ID,dropboxurldir) "https://dl.dropboxusercontent.com/u/78965321/site/$result($ID,jsdir)"

	    if {![string match *TODO* $result($ID,imageheader)]} {
		lappend result(list) $ID
	    }

	    puts "dynamic $dynamic imageheader $result($ID,imageheader) description $result($ID,description)"
	}
    }

    array set dynamics [array get result]
}

#
# parse project org file then transform the data for efficiency and praticability
#
proc load_projects_data {} {
    global works
    global projects
    
    distsource ../../org2obj org2obj.tcl

    array set orgprojects [org2obj [gensite_projects_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $orgprojects(levels) {
	foreach project $orgprojects($level,children) {
	    set ID $orgprojects($project,title)
	    lappend result(list) $ID

	    set result($ID,workheader) ""
	    set result($ID,description) $orgprojects($project,lines)
	    set result($ID,works) [list]
	    
	    foreach child $orgprojects($project,children) {
		set work [org2obj_extracttext $orgprojects($child,title)]

		puts "project $project child $child"
		# check that work exists, and get real work ID if title
		if {![lcontain $works(list) $work]} {
		    set found 0
		    foreach cwork $works(list) {
			if {[info exists works($cwork,title)]} {
			if {[s= $works($cwork,title) $work]} {
			    set work $cwork
			    set found 1
			    break
			}
			}
		    }
		    if {!$found} {
			puts "project $project child $child work $work not found !"
			set work ""
		    }
		}

		if {![sempty $work]} {
		    puts "project $project child $child work $work"
		    lappend result($ID,works) $work
		}
	    }

	    if {[info exists orgprojects($project,param,workheader)]} {
		# set workheader [string map [list "file:dots2art-works.org::*" "" "%20" " "] [lfront [split $orgprojects($project,param,workheader) "\]"]]]
		# set result($ID,workheader) $workheader

		set work [org2obj_extracttext $orgprojects($project,param,workheader)]

		puts "project $project workheader $work"
		# check that work exists, and get real work ID if title
		if {![lcontain $works(list) $work]} {
		    set found 0
		    foreach cwork $works(list) {
			if {[info exists works($cwork,title)]} {
			if {[s= $works($cwork,title) $work]} {
			    set work $cwork
			    set found 1
			    break
			}
			}
		    }
		    if {!$found} {
			puts "project $project workheader $work not found !"
			set work ""
		    }
		}

		if {![sempty $work]} {
		    puts "project $project workheader $work"
		    set result($ID,workheader) $work
		}
	    }
	}
    }

    array set projects [array get result]
}

#
# generate a timeline for works
# return [[title url]]
#
proc timeline_works {{nworks 100000}} {
    global works

    set timeline [list]
    set index 0
    foreach work $works(list) {
	lappend timeline [list $works($work,timestamp) [list $work $works($work,picture)]]
	incr index
	if {$index > $nworks} {
	    break
	}
    }

    set timeline [lsort -decreasing -index 0 -integer $timeline]

    return $timeline
}

#
# split array to be more efficient
#
proc splitworkdata {aworks} {
    array set works $aworks

    array set result [list]
    set result(list) $works(list)
    
    foreach work $works(list) {
	set result($work) [list]
    }

    foreach {key value} $aworks {
	if {![s= $key list]} {
	    set cwork [lfront [split $key ,]]
	    lappend result($cwork) $key $value
	}
    }

    set return [list]
    foreach work $result(list) {
	# puts "work $work result($work) $result($work)"
	lappend return $work $result($work)
    }
    return $return
}

#
# tutorials
#
#
# parse tutorials data
#
proc load_tutorials_data {} {
    global tutorials
    
    distsource ../../org2obj org2obj.tcl

    array set orgtutorials [org2obj [gensite_tutorials_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $orgtutorials(levels) {
	foreach tutorial $orgtutorials($level,children) {
	    set ID $orgtutorials($tutorial,title)
	    lappend result(list) $ID
	    
	    set result($ID,imageheader) $orgtutorials($tutorial,param,imageheader)
	    foreach dir {C:/archive/dots2art/images/bigs/archive C:/archive/dots2art/images/source c:/Dropbox/dev/PVG/examples} {
		if {[file exists "${dir}/$orgtutorials($tutorial,param,imageheader)"]} {
		    set result($ID,imageheader)  "${dir}/$orgtutorials($tutorial,param,imageheader)"
		    break
		}
	    }

	    set result($ID,lines) $orgtutorials($tutorial,lines)
	    set result($ID,sections) [list]
	    
	    foreach section $orgtutorials($tutorial,children) {
		set sectionID $orgtutorials($section,title)
		lappend result($ID,sections) $sectionID
		set result($ID,$sectionID,lines) $orgtutorials($section,lines)
	    }

	    puts "tutorial $tutorial imageheader $result($ID,imageheader) sections $result($ID,sections)"
	}
    }

    array set tutorials [array get result]
}

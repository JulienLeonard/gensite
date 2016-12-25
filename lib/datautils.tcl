source utils.tcl

set currentdir [pwd]
cd "C:/PROJECTS/MYDB"
source mydb.tcl
cd $currentdir
set myDB [MYDB]

proc gensite_index_filepath     {} {global myDB; return [orgdb_property $myDB "DOTS2ART-INDEX-ORG"]}
proc gensite_works_filepath     {} {global myDB; return [orgdb_property $myDB "DOTS2ART-WORKS-ORG"]}
proc gensite_projects_filepath  {} {global myDB; return [orgdb_property $myDB "DOTS2ART-PROJECTS-ORG"]}
proc gensite_dynamics_filepath  {} {global myDB; return [orgdb_property $myDB "DOTS2ART-DYNAMICS-ORG"]}
proc gensite_tutorials_filepath {} {global myDB; return [orgdb_property $myDB "DOTS2ART-TUTORIALS-ORG"]}


#
# parse page data
#
proc pages_data {} {
    set currentdir [pwd]
    cd "c:/DEV/org2obj/"
    source org2obj.tcl
    cd $currentdir

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

    return [array get result]
}


#
# parse work org file then transform the data for efficiency and praticability
#
proc works_data {} {
    set currentdir [pwd]
    cd "c:/DEV/org2obj/"
    source org2obj.tcl
    cd $currentdir

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
    
    return [array get result]
}

#
# parse dynamics data
#
proc dynamics_data {} {
    set currentdir [pwd]
    cd "c:/DEV/org2obj/"
    source org2obj.tcl
    cd $currentdir

    array set dynamics [org2obj [gensite_dynamics_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $dynamics(levels) {
	foreach dynamic $dynamics($level,children) {
	    set ID $dynamics($dynamic,title)

	    set result($ID,imageheader) $dynamics($dynamic,param,imageheader)
	    foreach dir {C:/archive/dots2art/images/bigs/archive C:/archive/dots2art/images/source} {
		if {[file exists "${dir}/$dynamics($dynamic,param,imageheader)"]} {
		    set result($ID,imageheader)  "${dir}/$dynamics($dynamic,param,imageheader)"
		    break
		}
	    }
	    set result($ID,description) "TODO"
	    set result($ID,code)        "TODO"


	    foreach child $dynamics($dynamic,children) {
		if {[s= $dynamics($child,title) Description]} {
		    set result($ID,description) $dynamics($child,lines)
		} elseif {[s= $dynamics($child,title) Code]} {
		    set result($ID,code) [string map [list "https://dl.dropboxusercontent.com/u/78965321/site/" ""] $dynamics($child,lines)]
		}
	    }

	    if {![string match *TODO* $result($ID,imageheader)]} {
		lappend result(list) $ID
	    }

	    puts "dynamic $dynamic imageheader $result($ID,imageheader) description $result($ID,description) code $result($ID,code)"
	}
    }

    return [array get result]
}

#
# parse project org file then transform the data for efficiency and praticability
#
proc projects_data {aworks} {
    set currentdir [pwd]
    cd "c:/DEV/org2obj/"
    source org2obj.tcl
    cd $currentdir

    array set works $aworks
    
    array set projects [org2obj [gensite_projects_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $projects(levels) {
	foreach project $projects($level,children) {
	    set ID $projects($project,title)
	    lappend result(list) $ID

	    set result($ID,workheader) ""
	    set result($ID,description) $projects($project,lines)
	    set result($ID,works) [list]
	    
	    foreach child $projects($project,children) {
		set work [org2obj_extracttext $projects($child,title)]

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

	    if {[info exists projects($project,param,workheader)]} {
		# set workheader [string map [list "file:dots2art-works.org::*" "" "%20" " "] [lfront [split $projects($project,param,workheader) "\]"]]]
		# set result($ID,workheader) $workheader

		set work [org2obj_extracttext $projects($project,param,workheader)]

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
    return [array get result]
}

#
# generate a timeline for works
# return [[title url]]
#
proc timeline_works {aworks {nworks 100000}} {
    array set works $aworks

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
proc tutorials_data {} {
    set currentdir [pwd]
    cd "c:/DEV/org2obj/"
    source org2obj.tcl
    cd $currentdir

    array set tutorials [org2obj [gensite_tutorials_filepath]]

    array set result [list]
    set result(list) [list]

    foreach level $tutorials(levels) {
	foreach tutorial $tutorials($level,children) {
	    set ID $tutorials($tutorial,title)
	    lappend result(list) $ID
	    
	    set result($ID,imageheader) $tutorials($tutorial,param,imageheader)
	    foreach dir {C:/archive/dots2art/images/bigs/archive C:/archive/dots2art/images/source C:/DEV/PVG/examples} {
		if {[file exists "${dir}/$tutorials($tutorial,param,imageheader)"]} {
		    set result($ID,imageheader)  "${dir}/$tutorials($tutorial,param,imageheader)"
		    break
		}
	    }

	    set result($ID,lines) $tutorials($tutorial,lines)
	    set result($ID,sections) [list]
	    
	    foreach section $tutorials($tutorial,children) {
		set sectionID $tutorials($section,title)
		lappend result($ID,sections) $sectionID
		set result($ID,$sectionID,lines) $tutorials($section,lines)
	    }

	    puts "tutorial $tutorial imageheader $result($ID,imageheader) sections $result($ID,sections)"
	}
    }

    return [array get result]
}




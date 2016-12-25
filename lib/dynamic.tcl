
#
# gen dynamic thumbnail
#
proc gen_dynamic_thumbnail {adynamics dynamictemplate dynamic} {
    array set dynamics $adynamics

    set imageurl [thumbnail_url [genimageurl $dynamics($dynamic,imageheader)]]
    set title    $dynamic
    set link     [dynamicurl $dynamic]
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl] $dynamictemplate]
}


#
# gen_dynamics_page
#
proc gen_dynamics_page {adynamics} {

    array set dynamics $adynamics
    
    foreach {template dynamictemplate} [templates_load index] break

    set HEADER [gen_header]
    set FOOTER [gen_footer]
    
    set CONTENT [list]
    lappend CONTENT [h1 Dynamics]
    foreach dynamic $dynamics(list) {
	lappend CONTENT [gen_dynamic_thumbnail $adynamics $dynamictemplate $dynamic]
    }	
    
    set CONTENT [join $CONTENT \n]
    
    set filepath [gensite_outputdir]/dynamics.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    return [array get dynamics]
}


#
# generate page for each dynamics
#
proc gen_dynamics {adynamics maxndynamics} {
    # array set dynamics $adynamics
    
    # first generate all the dynamic pages
    array set dynamics $adynamics
    # set maxndynamics 1000
    set ndynamics 0
    foreach dynamic $dynamics(list) {
	set adynamics [gen_dynamic $adynamics $dynamic]

	incr ndynamics    
	if {$ndynamics > $maxndynamics} {
	    break
	}
    }

    return $adynamics
}


#
# gen_dynamic
#
proc gen_dynamic {adynamics dynamic} {
    array set dynamics $adynamics

    set HEADER [gen_header]
    set FOOTER [gen_footer]

    foreach {template worktemplate} [templates_load project] break

    # array set projects $aprojects
    set title $dynamic

    # puts "image $dynamic title $title"
    # check and copy image header if not existing 
    #set filename $dynamics($dynamic,imageheader)
    #if {[file exists ${rootpath}/$filename]} {
    #file copy -force ${rootpath}/$filename [gensite_outputdir]/images/$filename]
    #}
    
    
    set CONTENT [list]
    lappend CONTENT [h2 $dynamic]
    # lappend CONTENT [div one-third-column [img [thumbnail_url [genimageurl $dynamics($dynamic,imageheader)]]]]
    lappend CONTENT [p [string trim $dynamics($dynamic,description) "\{\}"]]
    eval lappend CONTENT $dynamics($dynamic,code)
    set CONTENT [join $CONTENT \n]
    
    set dynamicurl      [dynamicurl $dynamic]
    set dynamicfilepath [dynamichtmlfilepath $dynamic]

    fput $dynamicfilepath [string map [list %TITLE% $title %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    set dynamics($dynamic,url) $dynamicurl

    return [array get dynamics]
}

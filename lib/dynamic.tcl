
#
# gen dynamic thumbnail
#
proc gen_dynamic_thumbnail {dynamictemplate dynamic} {
    global dynamics

    set imageurl [thumbnail_url [genimageurl $dynamics($dynamic,imageheader)]]
    set title    $dynamic
    set link     [dynamicurl $dynamic]
    set ALT      [htmlaltstring $dynamic]
    return [string map [list %LINK% $link %TITLE% $title %IMAGEURL% $imageurl %IMAGEURL1024% $imageurl %IMAGEURL150% $imageurl %IMAGEURL550% $imageurl %ALT% $ALT] $dynamictemplate]
}


#
# gen_dynamics_page
#
proc gen_dynamics_page {} {

    global dynamics
    
    foreach {template full_worktemplate thumbnail_worktemplate} [templates_load index] break

    set HEADER [gen_header watch]
    set FOOTER [gen_footer]
    
    set CONTENT [list]
    # lappend CONTENT [h1 Dynamics]
    foreach dynamic $dynamics(list) {
	lappend CONTENT [gen_dynamic_thumbnail $thumbnail_worktemplate $dynamic]
    }	
    
    set CONTENT [join $CONTENT \n]
    
    set filepath [gensite_outputdir]/dynamics.html
    set url      [relpath [gensite_outputdir]/ $filepath]
    fput $filepath [string map [list %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
}


#
# generate page for each dynamics
#
proc gen_dynamics {maxndynamics} {
    # array set dynamics $adynamics
    
    # first generate all the dynamic pages
    global dynamics
    # set maxndynamics 1000
    set ndynamics 0
    foreach dynamic $dynamics(list) {
	set adynamics [gen_dynamic $dynamic]

	incr ndynamics    
	if {$ndynamics > $maxndynamics} {
	    break
	}
    }
}


proc dynamic_template_webgl_code {scriptdir scriptid} {
    return [string map [list %SCRIPTID% $scriptid %SCRIPTDIR% $scriptdir] {<div id="%SCRIPTID%" style="width: 100%; height:auto;max-width:100%;"/>
    <input id="startAnim" type="button" value="Start Anim" />
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/others/webgl-utils.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/others/sylvester.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/myquadtree.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/utils.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/color.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/geoutils.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/bside.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/mywebgl.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/bpatternbao.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/%SCRIPTID%.js"></script>
    <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg//animviewercachecolor.js"></script>}]
}

proc dynamic_template_d3_code {scriptdir scriptid} {
    return [string map [list %SCRIPTID% $scriptid %SCRIPTDIR% $scriptdir] {<div id="%SCRIPTID%" style="width:100%;height:auto;max-width:100%;"/>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/d3.v3/d3.v3.min.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/myd3.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/others/sylvester.js"></script>
	<!-- <script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/others/QuadTree.js"></script> -->
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs//jsvg/myquadtree.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/utils.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/geoutils.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg//bpatternbao.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/%SCRIPTID%.js"></script>}]
}

proc dynamic_template_d3_code_quadtree {scriptdir scriptid} {
    return [string map [list %SCRIPTID% $scriptid %SCRIPTDIR% $scriptdir] {<div id="%SCRIPTID%" style="width:100%;height:auto;max-width:100%;"/>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/d3.v3/d3.v3.min.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/myd3.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/others/sylvester.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/others/QuadTree.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/utils.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg/geoutils.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg//bpattern.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/libs/jsvg//bpatternbao.js"></script>
	<script type="text/javascript" src="javascript/%SCRIPTDIR%/%SCRIPTID%.js"></script>}]
}


#
# gen_dynamic
#
proc gen_dynamic {dynamic} {
    global dynamics

    puts "generate page for dynamic $dynamic ..."
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

    #
    # copy js code from archive to output/javascript
    #
    
    set sourcedir [gensite_anim_sourcedir]/$dynamics($dynamic,jsdir)
    set destdir   [gensite_anim_outputdir]/$dynamics($dynamic,jsdir)

    if {[file exists $destdir]} {
	file delete -force $destdir
    }
    file copy -force $sourcedir $destdir
    
    
    set CONTENT [list]
    lappend CONTENT [h2 $dynamic]
    # lappend CONTENT [div one-third-column [img [thumbnail_url [genimageurl $dynamics($dynamic,imageheader)]]]]
    lappend CONTENT [p [string trim $dynamics($dynamic,description) "\{\}"]]
    # eval lappend CONTENT $dynamics($dynamic,code)

    if {[s= $dynamics($dynamic,d3) yes]} {
	lappend CONTENT [dynamic_template_d3_code $dynamics($dynamic,jsdir) $dynamics($dynamic,js)]
    } elseif {[s= $dynamics($dynamic,d3) quadtree]} {
	lappend CONTENT [dynamic_template_d3_code_quadtree $dynamics($dynamic,jsdir) $dynamics($dynamic,js)]
    } else {
	lappend CONTENT [dynamic_template_webgl_code $dynamics($dynamic,jsdir) $dynamics($dynamic,js)]
    }
    
    set CONTENT [join $CONTENT \n]
    
    set dynamicurl      [dynamicurl $dynamic]
    set dynamicfilepath [dynamichtmlfilepath $dynamic]

    fput $dynamicfilepath [string map [list %TITLE% $title %HEADER% $HEADER %CONTENT% $CONTENT %FOOTER% $FOOTER] $template]
    set dynamics($dynamic,url) $dynamicurl

    puts "generate page for dynamic $dynamic DONE"

    return [array get dynamics]
}

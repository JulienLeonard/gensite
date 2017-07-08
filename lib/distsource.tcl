#
# reference file for distant source management
# to be copied in each project to be able to load packages from Dropbox
#
proc distsource {sourcedir filename args} {
    upvar 1 currentdir currentdir
    set currentdir [pwd]
    set script "cd $sourcedir ; source $filename ; "
    foreach arg $args {
	append script " source $arg ; "
    }
    append script " cd $currentdir "
    uplevel 1 $script
}

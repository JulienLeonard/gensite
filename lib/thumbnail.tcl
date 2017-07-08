#
# thumbnail_url
#
proc thumbnail_url {imageurl} {
    return [string map [list "images/" "thumbnails/"] $imageurl]
}

#
# create thumbnails from picture
#
proc createthumbnails {picturefilepath} {
    set picture_filename [lback [split $picturefilepath /]]
    
    exec rconvert.exe $picturefilepath -thumbnail 300x300^ -gravity center -extent 300x300  [gensite_outputdir]/thumbnails/$picture_filename
    # exec rconvert.exe $picturefilepath -thumbnail 100x100^ -gravity center -extent 100x100  [dots2art_public_image_dir]/thumbnails_smalls/$picture_filename
}


#
# check if all the images under dropbox/pictures have thumbnails
#
proc checkthumbnails {} {
    set picturedir   [gensite_outputdir]/images
    set thumbnaildir [gensite_outputdir]/thumbnails
    
    foreach filepath [glob -dir $picturedir *.*] {
	set filename [lback [split $filepath /]]

	set thumbnailfilepath $thumbnaildir/$filename

	puts "filepath $filepath exists thumbnail [file exists $thumbnailfilepath] $thumbnailfilepath"

	# createthumbnails $filepath
	
	if {![file exists $thumbnailfilepath]} {
	    puts "thumbnail $filename missing, create it"
	    if {[catch {createthumbnails $filepath}]} {
		puts "Error creating thumbnail for $filepath"
	    }
	}
    }
}

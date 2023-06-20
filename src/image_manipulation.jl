"""
    framefromimagename(imagename::AbstractString)

Get the relevant frame number from the name of an image. 
**Does not necessarily** match the real frame number in the data.

*Example*
```jldoctest
julia> framefromimagename("5 24p9 1 2022-04-04-16-30-31-16-a-985.tif")
985

julia> framefromimagename("05_23_8_2 kept stack0001.tif")
1
```
"""
function framefromimagename(imagename::AbstractString)
    re = r"[0-9]+\."  # regular expression, gets digits before the .tif extension
	digit_indexes = findfirst(re, imagename)  # gets location of framenum in tifname
	digits_plus_tif = imagename[digit_indexes]
	framenum_with_leading_zeros = rstrip(digits_plus_tif, '.')  # strips off .tif
	
	stripped_framenum = lstrip(framenum_with_leading_zeros, '0')

	if stripped_framenum == ""
		return 0
	end

	return parse(Int, stripped_framenum)
end


"""
	imagenamedigitlength(tifname::AbstractString)

Get the length of the digits quantifying the frame in the image name. Used to catch leading zeros.

# Example
```jldoctest
julia> imagenamedigitlength("05_23_8_2 kept stack0001.tif")
4
```
"""
function imagenamedigitlength(tifname::AbstractString)
	re = r"[0-9]+\."  # regular expression, gets digits before the .tif extension
	digit_indexes = findfirst(re, tifname)  # gets location of framenum in tifname
	digits_plus_tif = tifname[digit_indexes]
	framenum_with_leading_zeros = rstrip(digits_plus_tif, '.')  # strips off .tif

	return length(framenum_with_leading_zeros)
	
end


"""
    fileextension(imagename::AbstractString)

Get the file extension from the image name.

# Example
```jldoctest
julia> fileextension("a0001.tif")
"tif"
```
"""
function fileextension(tifname::AbstractString)
	re = r"\.[a-z]+"
	indexes = findfirst(re, tifname)
	extension_plus_period = tifname[indexes]

	return lstrip(extension_plus_period, '.')
end

"""
	prefixfromimagename(imagename::AbstractString)

Return the prefix from the name of an image. This is everything besides the `<framenumbers>.tif`.

*Example*
```jldoctest
julia> prefixfromimagename("5 24p9 1 2022-04-04-16-30-31-16-a-985.tif")
"5 24p9 1 2022-04-04-16-30-31-16-a-"

julia> prefixfromimagename("05_23_8_2 kept stack0001.tif")
"05_23_8_2 kept stack"
```
"""
function prefixfromimagename(imagename::AbstractString)
	re = r"[0-9]+\."  # regular expression, gets digits before the .tif extension
	digit_indexes = findfirst(re, imagename)  # gets location of framenum in tifname
	imagename_withoutnumber = imagename[1:digit_indexes[1]-1]
end

"""
	loadframe(vidname::AbstractString, framenumber::Integer)

Return an image corresponding to the `framenumber` frame in the video `vidname`. Must be present in the `original_video` folder.

It looks at the way the tifs are automatically named and matches the pattern.
**Does not necessarily** match the real frame number in the data, especially if there is no particle in the first frame.
"""
function loadframe(vidname::AbstractString, framenumber::Integer)
    if !isdir("original_video/$vidname")
        error("Video $vidname not found in original_video folder.")
    end

	# Get info on how tifs are named in the tif stack, pad with zeros if needed.
	sampleimagename = readdir("original_video/$vidname")[1]
	imagenameprefix = prefixfromimagename(sampleimagename)
	digit_length = imagenamedigitlength(sampleimagename)
	file_extension = fileextension(sampleimagename)
	framenumberfinal = lpad(framenumber, digit_length, "0")
	
	frame = CairoMakie.load("original_video/$vidname/$imagenameprefix$framenumberfinal.$file_extension")
end
#!/bin/bash

encodeVideo () 
{
    # $1 is input file
    # $2 is output file, should end with .m4v
    # $3 is the width of the output
    # https://trac.handbrake.fr/wiki/CLIGuide
    width=$3  #height will be scaled to preserve aspect ratio
    audioBitrate=128 #AAC kbps
    constantQualityRF=22 #https://trac.handbrake.fr/wiki/ConstantQuality  22 looks good for iPhone
    start="started at `date`"
    # advanced options from HandBrake preset
    x264Advanced="level=4.0:ref=9:bframes=8:b-adapt=2:direct=auto:analyse=all:8x8dct=0:me=umh:merange=24:subme=10:trellis=2:vbv-bufsize=25000:vbv-maxrate=20000:rc-lookahead=60"
    # rotate, 1 flips on x, 2 flips on y, 3 flips on both (equivalent of 180 degree rotation)
    HandBrakeCLI -i "$1" -o "$2" -e x264 -O -B $audioBitrate -q $constantQualityRF -w $width -x $x264Advanced
    echo $start
    echo "finished at " `date`
}

isLandscape()
{
    #returns true if video is landscape, false if it is portrait
    width=`mdls -name kMDItemPixelWidth "$1" | grep -o '\d\{3,\}'`
    height=`mdls -name kMDItemPixelHeight "$1" | grep -o '\d\{3,\}'`
    #echo "$width x $height"
    #if test $width -gt $height
    if [ $width -gt $height ]
    then
        echo "true"
    fi
}


sourceDir="/Users/PAT5422/Desktop/hb cli source vids"
targetDir="/Users/PAT5422/Desktop/hb cli completed vids"
IFS=\n
#for f in `ls -1 "$sourceDir"`
#for f in $sourceDir
#do
ls $sourceDir | while read -r f; do



    #example filename
    #12,25,14 4'25'35 PM IMG_4419.m4v
    regex='^[^ ]+ [^ ]+ [^ ]+'
    datetime=`echo $f | grep -Eo $regex | tr "," "/" | tr "'" ":"`
    newFileName=`echo $f | sed -E "s/$regex //"`

    echo "looking at file $f with datetime $datetime"

    #rename the file to drop the ugly timestamp from the filename
    #mv "$sourceDir/$f" "$sourceDir/$newFileName"


    #detect orientation and encode with proper width
    #if [ "`isLandscape "$sourceDir/$f"`" = "true" ]; then
    #    encodeVideo "$sourceDir/$newFileName" "$targetDir/$newFileName" 1280
    #else
    #    encodeVideo "$sourceDir/$newFileName" "$targetDir/$newFileName" 720
    #fi

    #change the created date on the newly encoded file to match the original
    #SetFile -d "$datetime" "$targetDir/$newFileName"

done
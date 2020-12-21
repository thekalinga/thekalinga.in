#!/usr/bin/env bash
# For some reason reason svgo is not considering the disabled plugin options when I use the below shell. So using bash instead
# #!/bin/sh

inkscape=$(which inkscape)
svgo=$(which svgo)

rawSvgDirectory="svg"
optimizedSvgDirectory="svg-optimized"
intermediateSvgDirectory=/tmp/svg-text-to-path

if [ -x "$inkscape" ]; then
  if [ -x "$svgo" ]; then
    echo "### Removing all older optimized svgs ###";

    rm "$optimizedSvgDirectory"/*.svg 2> /dev/null;
    rmdir "$optimizedSvgDirectory" 2> /dev/null;
    mkdir "$optimizedSvgDirectory";
    echo "### Cleared all older optimized svgs ###";

    echo "### Removing intermediate svg files from last run ###";
    rm "$intermediateSvgDirectory"/*.svg 2> /dev/null;
    rmdir "$intermediateSvgDirectory" 2> /dev/null;
    mkdir "$intermediateSvgDirectory";
    echo "### Removed all intermediate svg files ###";

    currentIndex=1;
    svgFileCount=`ls -l "$rawSvgDirectory"/*.svg | grep -v ^l | wc -l`;

    echo "### Replacing text from original svgs with path ###";
    for f in "$rawSvgDirectory"/*.svg;
    do
      echo "Converting (${currentIndex}/${svgFileCount}): ${f} -> $intermediateSvgDirectory/`basename $f .svg`.svg";
      inkscape --export-text-to-path --export-plain-svg="$intermediateSvgDirectory/`basename $f .svg`.svg" "$f" --without-gui;
      currentIndex=$((currentIndex+1));
    done
    echo "### Replaced text from original svgs with path ###";

    echo "### Optimizing svgs ###";
    svgo --multipass --disable={cleanupIDs,removeNonInheritableGroupAttrs} -f "$intermediateSvgDirectory" -o "$optimizedSvgDirectory";
    echo "### Optimization complete ###";

    echo "### Cleaning up intermediate svg files ###";
    rm "$intermediateSvgDirectory"/*.svg 2> /dev/null;
    rmdir "$intermediateSvgDirectory" 2> /dev/null;
    echo "### Clean up complete ###";

    echo "### Conversion complete ###";
  else
    echo "svgo executable could not be found in PATH. Please add it to PATH variable and retry";
  fi
else
  echo "inkscape executable could not be found in PATH. Please add it to PATH variable and retry";
fi

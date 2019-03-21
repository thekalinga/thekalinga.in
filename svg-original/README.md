Place all original svgs here

If svg is common for across all posts, place it under root, else create a post specific folder

### Convert text -> path & Optimize

#### Prerequisites

Make sure you installed svgo
Install yarn
Install svgo by running yarn global add svgo from terminal

####

Run the following command

```sh
SVG_FILE_NAME=name; rm /tmp/$SVG_FILE_NAME 2> /dev/null || true && inkscape --export-text-to-path --export-plain-svg=/tmp/$SVG_FILE_NAME $SVG_FILE_NAME --without-gui && svgo --multipass --disable={cleanupIDs,removeNonInheritableGroupAttrs} -i /tmp/$SVG_FILE_NAME -o "${SVG_FILE_NAME%%.*}-optimized.${SVG_FILE_NAME##*.}"
```

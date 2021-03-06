#!/bin/bash

# defines
MOVIE_URI='http://www.imdb.com/find?s=all&q=MOVIE&x=0&y=0'
MOVIE_BROWSER='firefox'
MOVIE_SEPCHAR='+'

# Open MOVIE_BROWSER with MOVIE_URI
##########################################################################
#                     Nautilus "IMDB" Script                             #
##########################################################################
#                                                                        #
# Created by Michal Horejsek.com (pxjava)                                #
# Email: horejsekmichal@gmail.com                                        #
# Version: 1.1 / 26.7.2009 15:20:54                                      #
#                                                                        #
##########################################################################

MOVIE=${NAUTILUS_SCRIPT_SELECTED_FILE_PATHS} # get selected file paths

MOVIE=${MOVIE##*/} # remove path (/home/user/../)
MOVIE=${MOVIE%.*} # remove type (.avi, .mkv)

MOVIE=${MOVIE// /.} # replace space (" ") to dot (".")

MOVIE=`echo $MOVIE | tr '[:upper:]' '[:lower:]'` # to lowercase
MOVIE=`echo $MOVIE | tr '\.\-\_' $MOVIE_SEPCHAR` # replace .-_ to separate character
MOVIE=`expr "$MOVIE" : '\([^\[\(]*\)'` # remove brackets
if [ "`expr "$MOVIE" : '\(.*\)[0-9][0-9][0-9][0-9]'`" != "" ]; then
  MOVIE=`expr "$MOVIE" : '\(.*\)[0-9][0-9][0-9][0-9]'` # remove year
fi

MOVIE_URI=${MOVIE_URI/MOVIE/$MOVIE} # create URI

`$MOVIE_BROWSER $MOVIE_URI` # execute command

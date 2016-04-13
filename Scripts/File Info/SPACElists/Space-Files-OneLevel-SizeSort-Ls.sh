#!/bin/sh
##
## Nautilus
## SCRIPT: 00_spac_files_onelevel_sizesort_ls.sh
##
## PURPOSE: This utility will list the files in the current directory
##          sorted by size, all in the same easily-comparable units (MB),
##          with rigid (highly readable) columnar formatting.
##          The directories in this directory are also listed.
##          Uses 'ls' with 'sed', 'grep', 'sort', and 'awk'.
##
## HOW TO USE: Right-click on the name of any file (or directory) in a
##             Nautilus directory list.
##             Under 'Scripts', choose this script to run (name above).
##
## Created: 2010apr07
## Changed: 

## FOR TESTING:
#  set -v
#  set -x

############################################################
## Prep a temporary filename, to hold the list of filenames
## and size info.
############################################################

  OUTFILE="00_space_files_onelevel_sizesort_temp.lis"
  DIRNAME="`pwd`"
  if test ! -w "$DIRNAME"
  then
     OUTFILE="/tmp/$OUTFILE"
  fi

##############################################################
## We could put the report in the /tmp directory, rather than
## junking up the current directory with this report.
#
#  OUTFILE="/tmp/00_space_files_onelevel_sizesort_temp.lis"
#
## BUT it may be useful to have the last report available in
## the directory to which it applies.
#############################################################

  if test -f "$OUTFILE"
  then
     rm -f "$OUTFILE"
  fi

  ##########################################################################
  ## PUT THE REPORT INFO (from ls -la) INTO AN IN-MEMORY VARIABLE, $OUT.
  ##########################################################################
  ## ISSUE THE 'ls -la' COMMAND -- LOCALLY OR REMOTELY.
  ##########################################################################
  ## SAMPLE OUTPUT FROM 'ls -la', on Linux (Ubuntu 9.10):
  ## $ ls -la
  ## total 752
  ## drwxr-xr-x 64 user1 user1   4096 2009-12-03 23:16 .
  ## drwxr-xr-x  4 root  root    4096 2009-11-01 16:33 ..
  ## drwx------  2 user1 user1   4096 2009-11-09 15:06 .AbiSuite
  ## drwx------  3 user1 user1   4096 2009-11-02 05:24 .adobe
  ## drwxr-xr-x  3 user1 user1   4096 2009-11-11 00:55 apps
  ## -rw-r--r--  1 user1 user1    118 2009-11-09 08:43 .asunder
  ## drwxr-xr-x  4 user1 user1   4096 2009-11-09 09:28 .audacity-data
  ## -rwxr-xr-x  1 user1 user1   2369 2009-11-22 02:07 .bash_aliases
  ##########################################################################
  ##   The first line ('total ###') will be used to convert the number ###
  ##   from 512-byte blocks to Megabtyes and display in the heading of the
  ##   report.
  ##   The remaining lines will be sorted and reformated for the report body.
  ##########################################################################

     ## FOR TESTING:
     #  set -x

     OUT=`ls -la $DIRNAME`

     ## FOR TESTING:
     #   set -

  ##########################################################################
  ## CALCULATE TOTAL SIZE OF THE DIRECTORY FROM
  ## the first line ('total ###').
  ##########################################################################
  ##     Convert the number ### from 512-byte blocks to
  ##     Megabtyes and display in the heading of the report.
  ##     (1048576 = 1024 * 1024)
  ##########################################################################

  BLOCKS=`echo "$OUT" | head -1 | cut -d" " -f2`
  TOTMEG=`echo "scale=3; $BLOCKS * 512 / 1048576" | bc`

  ########################################################################
  ## SET REPORT HEADING for size of files and other file info.
  ########################################################################

HOST_ID="`hostname`"

  echo "\
..................... `date '+%Y %b %d  %a  %T%p'` ............................

DISK USAGE OF FILES  (and directory 'indexes')

IN DIRECTORY:   $DIRNAME

ON HOST:        ${HOST_ID}

                at *ONE* level under this directory, NOT all levels.

                SORTED BY *SIZE* --- BIGGEST FILES AT THE TOP.

                                    DIRECTORIES ARE BELOW THE FILES (and links).

                This report was generated by running the
                'ls -la' command on $HOST_ID .

                TOTAL SPACE used by files at this directory level is
                $BLOCKS 512-byte blocks --- about $TOTMEG Megabytes.

SIZE-SORT
*************
Disk usage      File-type &                      Last-Modified     Filename or link
(MegaBytes)     Permissions  Owner     Group     Date-time         (with embedded blanks, if any)
-------------   -----------  --------  --------  ----------------  ------------------------------
GigMeg.KilByt
  |  |   |  |" > "$OUTFILE"


  ##########################################################################
  ## GENERATE REPORT BODY --- from contents saved in $OUT.
  ##########################################################################
  ## NOTE on 'ls -l' format, on Unix:
  ##
  ## In 'ls -l' output, if the file is not more than a year old,
  ## $1=perms $3=userid $5=bytes $6=mmm, $7=dd $8=hrs:min $NF=filename
  ## Example:
  ##
  ##
  ## For a file more than a year old, $8=yyyy, where yyyy denotes year.
  ## Example:
  ## -rw-r--r--   1 root  root    2297 Aug 21  2007 asound.names
  ##########################################################################
  ## NOTE on 'ls -l' format, on Linux (Ubuntu 9.10):
  ##  
  ## $1=perms $3=userid $5=bytes $6=yyyy-mm-dd, $7=hrs:min $8=filename
  ## Example:
  ## -rwxr-xr-x  1 user1  user1  2369 2009-11-22 02:07 .bash_aliases
  ##########################################################################
  ## NOTE on filenames with embedded spaces and 'awk':
  ##
  ## To handle filenames with embedded spaces, we use 'substr($0,COLfilnam)'
  ## in awk, instead of '$8' --- where 
  ## we set COLfilnam with the expression 'COLfilnam = index($0,$8)'.
  ##
  ## The  'substr($0,COLfilnam)' gets the substring of the record, $0,
  ## starting at beginning of filename and going to the end of the record.
  ##
  #########################################################################

   ## FOR TESTING:
   #   set -x

   #########################################################
   ## AN ALTERNATIVE FORM OF THE 'sort' COMMAND.
   ## (Sometimes works when the '-k' format is hard to formulate properly.)
   ##
   #   echo "$OUT" | tail +2 | sort +4 -5 -nr | \
   #########################################################

   ## FOR TESTING:
   #  echo "$OUT" | tail +2 | sort -k5nr
   #  echo "$OUT" | tail +2 | sort +4 -5nr


   #########################################################
   ## THIS FORM MIXES directories with regular-files and links.
   #
   #     echo "$OUT" | tail +2 | sort -k5nr | \
   #
   #     echo "$OUT" | tail +2 | sort +4 -5nr | \
   #     awk '{ COLmonth = index($0,$6) ; \
   #printf ("%13.6f   %-10s   %-8s  %-8s  %-10s %5s  %s\n", $5/1000000, $1, $3, $4, $6, $7, substr($0,COLfilnam) )}' \
   #     >> "$OUTFILE"
   #########################################################

   ############################################
   ## Add NON-directories --- i.e.
   ## FILES (and LINKS, etc.) --- to the report.
   ############################################

   # echo "$OUT" | tail +2 | grep -v '^d' | sort -k5nr | \

   # echo "$OUT" | tail +2 | grep -v '^d' | sort +4 -5nr | \

   ###########################################################################
   ## Note: 'tail +2' does not work as designed on some Linuxes (Ubuntu 9.10).
   ##       We use "sed '1d'" instead.
   ###########################################################################
     echo "$OUT" | sed '1d' | grep -v '^d' | sort +4 -5nr | \
     awk '{ COLfilnam = index($0,$8) ; \
printf ("%13.6f   %-10s   %-8s  %-8s  %-10s %5s  %s\n", $5/1000000, $1, $3, $4, $6, $7, substr($0,COLfilnam) )}' \
     >> "$OUTFILE"

   ############################################
   ## Add a separator line --- between
   ## FILES and DIRECTORIES.
   ############################################

   echo "
Directories:" >> "$OUTFILE"


   #########################################
   ## Add DIRECTORIES to the report.
   #########################################

   #  echo "$OUT" | tail +2 | grep  '^d' | sort -k5nr | \

   #  echo "$OUT" | tail +2 | grep  '^d' | sort +4 -5nr | \

   echo "$OUT" | sed '1d' | grep  '^d' | sort +4 -5nr | \
   awk '{ COLfilnam = index($0,$8) ; \
printf ("%13.6f   %-10s   %-8s  %-8s  %-10s %5s  %s\n", $5/1000000, $1, $3, $4, $6, $7, substr($0,COLfilnam) )}' \
     >> "$OUTFILE"

   ############################################################################
   ## OLD VERSION using $9, Unix-style. Did not handle embedded blanks well (nor links).
   ############################################################################
   # awk '{printf ("%13.6f   %-10s   %-8s  %-8s  %-3s %2s %5s  %s\n", $5/1000000, $1, $3, $4, $6, $7, $8, $9 )}' \
   ############################################################################

   ## FOR TESTING:
   #   set -



  ########################################################################
  ## Add TRAILER to report.
  ########################################################################

# BASENAME=`basename $0`

  echo "\
  |  |   |  |
GigMeg.KilByt
-------------   -----------  --------  --------  ----------------  ------------------------------
Disk usage      File-type &  Owner     Group     Last-Modified     Filename or link 
(MegaBytes)     Permissions                      Date-time         (with embedded blanks, if any)
*************
SIZE-SORT

..................... `date '+%Y %b %d  %a  %T%p'` ............................

  The output above was generated by the script

$0

  which ran the 'ls -la' command on host $HOST_ID .

-----------------
PROCESSING METHOD:

  The script uses a 'pipe' of several commands ('ls', 'sort', 'awk') like:

         ls -la <dirname> | sort +4 -5nr | awk '{... ; printf ( ... )}'

  on the specified host.

------------
FEATURE NOTE:

  This utility provides SIZE-sorting and FORMATTING-FOR-READABILITY
  (esp. readability of file-sizes) that is not available by using
  only the 'ls' command.

---------------------
DIRECTORIES-SIZE NOTE:

  A line that starts with 'd' in the permissions string
  shows the size of the 'INDEX' (i.e. table of contents) of a DIRECTORY ---
  NOT the size of ALL the FILES and SUBDIRECTORIES UNDER that directory.

..................... `date '+%Y %b %d  %a  %T%p'`.............................
" >> "$OUTFILE"



##################################################
## Show the list of filenames with space info.
##################################################

. $HOME/.gnome2/nautilus-scripts/.set_VIEWERvars.shi

$TXTVIEWER "$OUTFILE" &
   
   

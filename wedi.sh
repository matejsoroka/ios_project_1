#!/bin/sh
#/*
# *	@name: Project 1 for IOS
# *	@author: Matej Soroka <xsorok02>
# */

if [ $# -gt 0 ] # if we have some argiment
then
    if [ "$#" = 1 ]; then # if we have one argument
      vim "$1" || echo "Editor cannot be opened. Return code 1" ; exit 1
    fi
    if [ "$#" -lt 3 ]; then # if we have less than 3 arguments
      if [ "$1" = "-m" ] # if first argument is switch for most frequent file
      then
        echo "Opening most frequently opened file in folder $2"
      elif [ "$1" = "-l" ] # if first argument is switch for listing files in directory
      then
        echo "Printing list of files which were opened in folder $2"
        exec ls "$2"
      else
        echo "Wrong input"
      fi
    fi
else
    echo "Choosing file to edit"
fi

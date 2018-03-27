#!/bin/sh

export LC_ALL=POSIX

if [ -z "$WEDI_RC" ]; then
    echo "Destination to file doesn't exist"
    exit 1
fi

# $1 -o|-p open or print file
# $2 absolute destination to file
handleDestination()
{

    FILES="$2"
    dest="$3"
    for destination in $FILES
    do
        if [ "$(dirname $destination)" = "$dest" ] && [ -f "$destination" ]; then
            if [ "$1" = "-p" ]; then
                basename "$destination"
            elif [ "$1" = "-o" ]; then
                openEditor $destination
                exit 0
            fi
        fi
    done

}

# $1 absolute destination to file
openEditor()
{
    if [ "$EDITOR" ]; then          # variable EDITOR is set
        "$EDITOR" "$1"              # opens file set by argument with editor from EDITOR variable
    else
        if [ "$VISUAL" ]; then      # variable VISUAL is set
            "VISUAL" "$1"           # opens file set by argument with editor from VISUAL variable
        else                        # if neither EDITOR or VISUAL isn't set, choose vi editor
            vi "$1"                 # opens file set by argument with vi editors
        fi
    fi
    echo "$1|$(date +%Y-%m-%d)" >> $WEDI_RC # write
}

# $1 absolute destination to directory
getFilesInDirectory()
{
    FILES=$(awk -F\| '{print $1}' "$WEDI_RC" | sort | uniq) # get all unique lines
    handleDestination "-p" "$FILES" "$1"
}

# $1 -b|-a before and after switch
# $2 date in YYYY-MM-DD format
# $3 absolute destination to directory
getFilesInDirectoryByDate()
{

    date="$2"

    if [ "$1" = "-b" ]; then
        FILES=$(awk -F\| -v argument="$date" 'argument > $2 {print $1}' "$WEDI_RC" | sort | uniq)
    else
        FILES=$(awk -F\| -v argument="$date" 'argument <= $2 {print $1}' "$WEDI_RC" | sort | uniq)
    fi

    handleDestination "-p" "$FILES" "$3"

}

# $1 absolute destination to directory
runLastFileInFolder()
{
    FILES=$(awk -F\| '{print $1}' "$WEDI_RC" | sort | uniq) # get all unique lines
    handleDestination "-o" "$FILES" "$1"
}

# $1 absolute destination to directory
getMostEditedFile()
{
    FILES=$(<$WEDI_RC cut -d'|' -f1 | sort -n | uniq -c | sort -r | awk '{$1=$1};1' | cut -d ' ' -f 2)
    handleDestination "-o" "$FILES" "$1"
}

if [ "$#" = "1" ]; then

    if [ -f "$1" ]; then                # if argument is file

        openEditor "$(realpath $1)"

    else

        if [ -d "$1" ]; then        # if argument is folder
            runLastFileInFolder "$(realpath ./$1)"
        fi

        if [ "$1" = "-l" ]; then
            getFilesInDirectory "$(realpath .)"
        fi

        if [ "$1" = "-m" ]; then
            getMostEditedFile "$(realpath .)"
        fi

    fi

else
    if [ "$#" = "0" ]; then # run without argument
        runLastFileInFolder "$(realpath .)"
    fi
fi

if [ "$#" = "2" ]; then

    if [ "$1" = "-l" ] && [ -d $(realpath ./$2) ]; then # TODO: error if not directory
        getFilesInDirectory $(realpath ./"$2")
    fi

    if [ "$1" = "-a" ] || [ "$1" = "-b" ]; then
        getFilesInDirectoryByDate $1 $2 "$(realpath .)"
    fi

    if [ "$1" = "-m" ]; then
        getMostEditedFile $(realpath ./"$2")
    fi

fi

if [ "$#" = "3" ]; then
    if [ "$1" = "-a" ] || [ "$1" = "-b" ]; then
        getFilesInDirectoryByDate $1 $2 "$(realpath ./"$3")"
    fi
fi

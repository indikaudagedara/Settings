
# poor man's project management (for C/C++ use with vim)
# don't run this but source as it sets env variables
# eg. alias p='. project.sh'
# also is useful to have this shell alias to open files in the same vim instance
#
# v() {
#       if [[ "$_PROJECT" != "" ]]; then
#               vim --servername $_PROJECT --remote-tab-silent $@
#               return
#       fi
#
#       vim $@
# }

_help() {
        echo "Usage: p option [arg]"
        echo "Options:"
        echo "  i [project] - init project and build file/tags dbs"
        echo "  s project   - set project env variables"
        echo "  d [project] - delete project"
        echo "  cd [number] - change directory"
        echo "  a directory - add directory"
        echo "  l           - list project"
        echo "  e           - edit project"
        echo "  la          - list all projects"
        echo "  h           - show this help"
}

if [[ $# -lt 1 ]]; then
        _help
        return
fi

DIR=~/projects

_exec() {
        cmd=$1
        echo "$cmd"
        eval $cmd
}

init_proj() {
        proj=$1

        echo "--> init project '$proj'"

        pf=$DIR/${proj}.project

        # cscope files
        csf=$DIR/${proj}.files

        # cscope cross reference
        csrf=$DIR/${proj}.out

        ctf=$DIR/${proj}.tags

        touch $pf
        touch $csf
        touch $csrf
        touch $ctf

        for dir in `cat $pf`; do
                _exec "find $dir/. -type f | egrep -i \"\.(c|h|cpp)$\" >> $csf"
        done

        sort -u -o $csf $csf

        lns=`wc -l $csf | cut -f 1 -d ' '`

        if [[ "$lns" != "0" ]]; then


                # build cscope cross ref
                _exec "cscope -b -i $csf -f $csrf"
                _exec "ctags -L $csf -f $ctf"
        fi
}


set_proj() {

        proj=$1

        pf=$DIR/${proj}.project

        if [[ ! -e $pf ]]; then
                echo "--> no project '$proj'. unsetting"
                export _PROJECT=""
                export FILES_DB=""
                export CSCOPE_DB=""
                export TAGS_DB=""
                return 0
        fi

        echo "--> set project '$proj'"

        # cscope files
        csf=$DIR/${proj}.files

        # cscope cross reference
        csrf=$DIR/${proj}.out

        ctf=$DIR/${proj}.tags

        lns=`wc -l $csf | cut -f 1 -d ' '`
        if [[ "$lns" != "0" ]]; then
                export FILES_DB=$csf
        else
                export FILES_DB=""
        fi
        printf "files= %8d    FILES_DB=%s\n" $lns $FILES_DB

        lns=`wc -l $csrf | cut -f 1 -d ' '`
        if [[ "$lns" != "0" ]]; then
                export CSCOPE_DB=$csrf
        else
                export CSCOPE_DB=""
        fi
        printf "cscope=%8d    CSCOPE_DB=%s\n" $lns $CSCOPE_DB

        lns=`wc -l $ctf | cut -f 1 -d ' '`
        if [[ "$lns" != "0" ]]; then
                export TAGS_DB=$ctf
        else
                export TAGS_DB=""
        fi
        printf "ctags= %8d    TAGS_DB=%s\n" $lns $TAGS_DB

        cat -n $pf

        export _PROJECT=$proj

        return 1
}

del_proj() {
        proj=$1

        echo "--> del project '$proj'"

        pf=$DIR/${proj}.project

        # cscope files
        csf=$DIR/${proj}.files

        # cscope cross reference
        csrf=$DIR/${proj}.out

        ctf=$DIR/${proj}.tags

        rm -f $pf $csf $csrf $ctf
}

check_proj() {

        if [[ "$_PROJECT" == "" ]]; then
                echo "--> no project set"
                return 0
        fi

        echo "--> current '$_PROJECT'"
        return 1
}

case $1 in
        i)
                proj=""
                if [[ $# -ne 2 ]]; then
                        proj=$_PROJECT
                else
                        proj=$2
                fi

                if [[ "$proj" == "" ]]; then
                        echo "--> set project or pass a new one"
                        return
                fi
                init_proj $proj
                set_proj $proj
                return
        ;;

        s)
                set_proj $2
                return
        ;;

        d)
                proj=""
                if [[ $# -ne 2 ]]; then
                        proj=$_PROJECT
                else
                        proj=$2
                fi

                if [[ "$proj" == "" ]]; then
                        echo "--> set project or pass existing one"
                        return
                fi

                del_proj $proj
                return

        ;;


        a)

                if [[ $# -ne 2 ]]; then
                        echo "--> pass a directory"
                        return
                fi

                check_proj; [[ $? != 1 ]] && return

                proj=$_PROJECT
                pf=$DIR/${proj}.project
                echo "$PWD/$2" >> $pf

                sort -u -o $pf $pf
                init_proj $proj
                return

        ;;

        l)
                check_proj; [[ $? != 1 ]] && return

                proj=$_PROJECT
                pf=$DIR/${proj}.project
                cat -n $pf
                return

        ;;

        e)
                check_proj; [[ $? != 1 ]] && return

                proj=$_PROJECT
                pf=$DIR/${proj}.project
                vim $pf
                return
        ;;

        la)
                if [[ "$_PROJECT" != "" ]]; then
                        echo "--> $_PROJECT"
                fi

                for i in `ls $DIR/*.project`; do
                        basename $i | sed 's/\.project//'
                done
                return
        ;;

        cd)

                check_proj; [[ $? != 1 ]] && return

                proj=$_PROJECT
                pf=$DIR/${proj}.project

                num=1
                if [[ $# -eq 2 ]]; then
                        num=$2
                fi

                dir=$(sed -n "$num p" $pf)

                if [[ "$dir" != "" ]]; then
                        _exec "cd $dir"
                fi
        ;;

        h)
                _help
                return
        ;;

        *)
                echo "--> unexpected option"
                return
        ;;
esac

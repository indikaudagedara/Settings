
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

if [[ $# -lt 1 ]]; then
        echo "$0 option [arg]"
        echo "  i(init) [project]"
        echo "  s(set) project"
        echo "  d(delete) [project]"
        echo "  a(add) directory"
        echo "  l(list project)"
        echo "  e(edit project)"
        echo "  la(list all projects)"
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

        DIR=~/projects
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
        echo "files=$lns"
        if [[ "$lns" != "0" ]]; then
                export FILES_DB=$csf
        else
                export FILES_DB=""
        fi


        lns=`wc -l $csrf | cut -f 1 -d ' '`
        echo "csope=$lns"
        if [[ "$lns" != "0" ]]; then
                export CSCOPE_DB=$csrf
        else
                export CSCOPE_DB=""
        fi

        lns=`wc -l $ctf | cut -f 1 -d ' '`
        echo "ctags=$lns"
        if [[ "$lns" != "0" ]]; then
                export TAGS_DB=$ctf
        else
                export TAGS_DB=""
        fi

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

        echo "--> $_PROJECT"
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
                cat $pf
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

        *)
                echo "--> unexpected option"
                return
        ;;
esac

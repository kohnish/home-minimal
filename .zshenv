[ -f ~/.zsh_paths ] && source ~/.zsh_paths
[ -f ~/.zshenv_local ] && source ~/.zshenv_local

cindex() {
    echo 'cscoping'
    git ls-files >! cscope.files
    cscope -b -R 
    echo 'ctagging'
    ctags -L cscope.files -f tags -R
}

gsync() {
    if [[ -z $(git status -s) || ! -z $1 ]]; then
        git checkout master &&
        local upstream=`git rev-parse --abbrev-ref master@{upstream}` &&
        git fetch --all &&
        git reset --hard ${upstream} &&
        git submodule update -f &&
        git clean -df -f
    fi
}

purge-vim-swap() {
    /bin/rm -rf $HOME/.vim/.swap/.*
    /bin/rm -rf $HOME/.vim/.swap/*
    touch $HOME/.vim/.swap/.gitkeep
}

makenotes() {
    vim $HOME/docs/notes.md
}

fcd() {
    if [[ -f $1 ]]; then
        cd `dirname $1`
    else
        cd $1
    fi
}

cdmkdir() {
    mkdir -p $1
    cd $1
}

m() {
    if command -v nproc > /dev/null; then
        num_cores=`nproc`
    else
        num_cores=`sysctl hw.ncpu |awk '{print $2}'`
    fi
    # num_cores=$(($num_cores - 2))
    if [[ -d build ]]; then
        if [[ -f build/build.ninja ]]; then
            time sh -c "cd build && ninja -j$num_cores $@"
        else
            time sh -c "cd build && make -j$num_cores $@"
        fi
        return
    fi
    if [[ -f build.ninja ]]; then
        time ninja -j$num_cores $@
    else
        time make -j$num_cores $@
    fi
}

#! /bin/bash

cd ~/.vim/vimrc.d/neobundle.d
let idx=0
for f in *
do
    CONFIG_FILE[$idx]=$f
    let idx++
done

cd ..
select x in ${CONFIG_FILE[@]}
do
    ln -s -f "./neobundle.d/$x" "./neobundle_config"
    ls -l neobundle_config
    break
done

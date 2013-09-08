#! /bin/bash

cd ~/.vim/vimrc.d/neobundle_config.d
let idx=0
for f in *
do
    CONFIG_FILE[$idx]=$f
    let idx++
done

cd ..
select x in ${CONFIG_FILE[@]}
do
    ln -s -f "./neobundle_config.d/$x" "./neobundle_config"
    ls -l neobundle_config
    break
done
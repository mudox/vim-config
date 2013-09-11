#! /bin/bash

cd ~/.vim/vimrc.d/configs.d
let idx=0
for f in *
do
    CONFIG_FILE[$idx]=$f
    let idx++
done

cd ..
select x in ${CONFIG_FILE[@]}
do
    if [ -n "$x" ]
    then
        ln -s -f "./configs.d/$x" "./cur_config"
        ls -l cur_config
    fi
    break
done

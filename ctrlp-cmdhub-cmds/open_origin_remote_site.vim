!open $(git remote -v | awk '{print $2}' | head -n1 | sed -e 's+git@github.com:+http://github.com/+')

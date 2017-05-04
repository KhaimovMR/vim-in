#!/bin/bash
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'

print_usage(){
    echo "Usage: under your user run './seed-vim-in.sh <user-to-seed>' where <user-to-seed> is the name of user, under which you want to be able to use your own vim configuration."
}

initial_setup() {
    mkdir -p $HOME/.vim-in

    if [[ ! -f $HOME/.vim-in/vim ]]
    then
        echo "#!/bin/bash" > $HOME/.vim-in/vim
        echo "export HOME=$HOME" >> $HOME/.vim-in/vim
        echo "export MYVIMRC=$HOME/.vimrc" >> $HOME/.vim-in/vim
        echo "vim -i $HOME/.vim-in/\$USER.viminfo --cmd 'set runtimepath^=$HOME/.vim' --cmd 'set runtimepath+=$HOME/.vim/after' --cmd 'set runtimepath+=$HOME/.vim/bundle/Vundle.vim' \$@" >> $HOME/.vim-in/vim
        echo -e "${GREEN}Successfuly created ${BLUE}$HOME/.vim-in/vim${GREEN} script to run your vim configuration${NC}"
        echo -e "Edit ${BLUE}$HOME/.vim-in/vim${NC} if you're using other than Vundle package manager."
        echo ''
    fi

    chmod 755 $HOME/.vimrc
    chmod 755 $HOME/.vim -R
    chmod 755 $HOME/.vim-in/vim
    chmod 777 $HOME/.vim-in
}

if [[ $1 == "" ]]
then
    print_usage
    exit 0
fi

id_msg=$(id -u $1 2>&1)
id_exit_code=$?

if [[ $id_exit_code != 0 ]]
then
    [[ $id_exit_code != 0 ]] && echo -e "${RED}$id_msg${NC}" && echo ''
    print_usage
    exit 1
else
    initial_setup
    command sudo su $1 -c "echo '' >> ~/.bashrc && echo '# vim-in init {' >> ~/.bashrc && echo '[[ \"\$SUDO_USER\" != \"\" ]] && [[ -f \`eval echo ~\$SUDO_USER\`/.vim-in/vim ]] && alias vim=\`eval echo ~\$SUDO_USER\`/.vim-in/vim' >> ~/.bashrc && echo '# vim-in init }' >> ~/.bashrc "

    [[ $? == 0 ]] && echo -e "${GREEN}vim-in successfuly seeded for user:${NC} $1"
fi

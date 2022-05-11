#!/bin/bash
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
SCRIPT_DIR=$(dirname $0)

print_usage(){
    echo "Usage: under your user run './seed-vim-in.sh <user-to-seed>' where <user-to-seed> is the name of user, under which you want to be able to use your own vim configuration."
}

initial_setup() {
    mkdir -p $HOME/.vim-in
    NVIM_CONFIG_PATH_PART='/.config/nvim/init.vim'
    MYVIMRC_PATH=$HOME$NVIM_CONFIG_PATH_PART

    if [[ ! -f $HOME/.vim-in/vim ]]
    then
        echo "#!/bin/bash" > $HOME/.vim-in/vim
        echo "export HOME=$HOME" >> $HOME/.vim-in/vim
        echo "export MYVIMRC=$MYVIMRC_PATH" >> $HOME/.vim-in/vim
        echo "vim -i $HOME/.vim-in/\$USER.viminfo --cmd 'set runtimepath^=$HOME/.vim' --cmd 'set runtimepath+=$HOME/.vim/after' --cmd 'set runtimepath+=$HOME/.local/share/nvim/site/autoload/plug.vim' \$@" >> $HOME/.vim-in/vim
        echo -e "${GREEN}Successfuly created ${BLUE}$HOME/.vim-in/vim${GREEN} script to run your vim configuration${NC}"
        echo -e "Edit ${BLUE}$HOME/.vim-in/vim${NC} if you're using other than Plug package manager."
        echo ''
    fi

    sudo chmod 755 $MYVIMRC_PATH
    sudo chmod 755 $HOME/.vim -R
    sudo chmod 755 $HOME/.vim-in/vim
    sudo chmod 777 $HOME/.vim-in
}

if [[ $1 == "" ]]
then
    print_usage
    exit 0
fi

if [[ $1 == "-i" ]]
then
    initial_setup
    exit 0
fi

id_msg=$(id -u $1 2>&1)
id_exit_code=$?

if [[ $id_exit_code != 0 ]]; then
    [[ $id_exit_code != 0 ]] && echo -e "${RED}$id_msg${NC}" && echo ''
    print_usage
    exit 1
else
    initial_setup
    command sudo su $1 -c "cat $SCRIPT_DIR/vim-in-source >> ~/.bashrc"

    [[ $? == 0 ]] && echo -e "${GREEN}vim-in successfuly seeded for user:${NC} $1"
fi

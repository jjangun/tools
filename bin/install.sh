#!/bin/sh
MType=`uname`

echo "Install packages"
if [ "$MType" = 'Linux' ]
then
    sudo apt install zsh autojump silversearcher-ag tig tree git vim build-essential cmake python3-dev clang wget curl exuberant-ctags automake1.11 libncurses5-dev libncurses5
fi

echo "Install oh-my-zsh"
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

echo "Change default shell to zsh"
chsh -s `which zsh`

echo "Change zsh theme"
wget http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme -P ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/

sed -i -- 's/robbyrussell/bullet-train/g' $HOME/.zshrc

echo "Enable syntax correct"
echo "setopt correct" >> $HOME/.zshrc

echo "Install zsh plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sed -i -- 's/(git)/(git autojump zsh-syntax-highlighting zsh-autosuggestions)/g' $HOME/.zshrc

echo "Append config .vimrc"
echo "source $HOME/.tools/env/.vimrc" >> $HOME/.vimrc

echo "Append config tools.sh"
echo "source $HOME/.tools/bin/tools.sh" >> $HOME/.zshrc

echo "Downloading... Vundle"
git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim

echo "Install Vundle Plugins"
vim -c :PluginInstall -c :qa

if [ "$MType" = 'Linux' ]
then
    echo "Install YouCompleteMe"
    $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer

    echo "Install fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install

    echo "Install gnu global"
    global_version="global-6.6.3"
    global_archive=$global_version".tar.gz"
    global_down_url="http://ftp.gnu.org/gnu/global/"$global_archive

    wget $global_down_url -P $HOME
    tar xvzf $global_archive -C $HOME

    cd $HOME/$global_version
    ./configure --prefix=$HOME/.global
    make
    make install

    cp $HOME/.global/share/gtags/gtags.conf $HOME/.globalrc

    echo "Remove install files"
    rm -rf $HOME/$global_archive
    rm -rf $HOME/$global_version
    echo "global install done"

    echo "Install fixpath"
    git clone https://github.com/xaljox/fixpath.git $HOME/.tools/fixpath
    cd $HOME/.tools/fixpath
    ./configure --prefix=$HOME/.tools
    make
    make install

    echo "Remove fixpath directory"
    rm -rf $HOME/.tools/fixpath

    echo "Install terminal color"
    bash -c "$(wget -qO- https://git.io/vQgMr)"
fi

echo "Completed!"

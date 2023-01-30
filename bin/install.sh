#!/bin/sh
OSType=`uname`
SUDO=

echo "Install packages"
if [ "$OSType" = 'Linux' ]; then
    echo "Check root user"
    if [ "$(id -u)" != "0" ]; then
        SUDO="sudo"
    fi

    echo "Install build packages"
    $SUDO apt install -y \
        build-essential python-is-python3 python3-dev clang automake1.11 \
        libncurses5-dev libncurses5

    echo "Install packages"
    $SUDO apt install -y \
        git tig \
        wget curl  \
        zsh \
        autojump silversearcher-ag tree \
        vim cmake exuberant-ctags
elif [ "$OSType" = 'Darwin' ]; then
    echo "Install xcode"
    xcode-select --install

    echo "Install Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    echo "Install packages"
    brew install \
        git tig \
        wget curl \
        zsh zsh-completions \
        autojump the_silver_searcher tree \
        vim cmake ctags

    echo "Install iterm2"
    brew install iterm2
fi

echo "Install oh-my-zsh with auto exiting"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')"

echo "Change zsh theme"
wget http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme -P ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/

sed -i -- 's/robbyrussell/bullet-train/g' $HOME/.zshrc

echo "Enable syntax correct"
echo "setopt correct" >> $HOME/.zshrc

echo "Disable no_match" # for apt * wildcard
echo "unsetopt no_match" >> $HOME/.zshrc

echo "Install zsh plugins"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

sed -i -- 's/(git)/(git autojump zsh-syntax-highlighting zsh-autosuggestions)/g' $HOME/.zshrc

echo "Change default shell to zsh"
chsh -s `which zsh`

echo "Downloading... vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Append config .vimrc"
echo "source $HOME/.tools/env/.vimrc" >> $HOME/.vimrc

echo "Append config tools.sh"
echo "source $HOME/.tools/bin/tools.sh" >> $HOME/.zshrc

echo "Install Vundle Plugins"
vim -c :PlugInstall -c :qa

if [ "$OSType" = 'Linux' ]; then
    echo "Install YouCompleteMe"
    $HOME/.vim/plugged/YouCompleteMe/install.py --clang-completer

    echo "Install gnu global"
    global_version="global-6.6.9"
    global_archive=$global_version".tar.gz"
    global_down_url="http://ftp.gnu.org/gnu/global/"$global_archive

    wget $global_down_url -P $HOME
    tar xvzf $HOME/$global_archive -C $HOME

    cd $HOME/$global_version
    ./configure --prefix=$HOME/.local
    make
    make install

    cp $HOME/.local/share/gtags/gtags.conf $HOME/.globalrc

    echo "Remove install files"
    rm -rf $HOME/$global_archive
    rm -rf $HOME/$global_version
    echo "global install done"

    echo "Install fixpath"
    git clone https://github.com/xaljox/fixpath.git $HOME/.tools/fixpath
    cd $HOME/.tools/fixpath
    ./configure --prefix=$HOME/.local
    autoreconf -f -i
    make
    make install

    echo "Remove fixpath directory"
    rm -rf $HOME/.tools/fixpath

    echo "Install fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install

    echo "Install terminal color"
    bash -c "$(wget -qO- https://git.io/vQgMr)"
elif [ "$OSType" = 'Darwin' ]; then
    echo "Install YouCompleteMe"
    $HOME/.vim/plugged/YouCompleteMe/install.py --clang-completer

    echo "Install fzf"
    brew install fzf
    `brew --prefix`/opt/fzf/install

    echo "Install terminal color"
    bash -c  "$(curl -sLo- https://git.io/vQgMr)"
fi

echo "Completed!"

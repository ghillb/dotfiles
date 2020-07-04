deploy_df()
{
    cd
    echo ". '~/dotfiles/assets/startup.sh'" >> ~/.profile
    echo -e "# my dotfile additions\n. '~/dotfiles/bashrc'" >> ~/.bashrc
#    sed -i 's/#force_color/force_color/g' ~/.bashrc
    ln -s ~/dotfiles/spectrwm.conf .spectrwm.conf
    ln -s ~/dotfiles/tmux.conf .tmux.conf
    mkdir -p ~/.config/nvim ~/.vim/undodir ; ln -s ~/.vimrc ~/.config/nvim/init.vim; ln -s ~/dotfiles/vimrc .vimrc
    mkdir -p ~/.config/termite; cd ~/.config/termite/; ln -s ~/dotfiles/termite.conf config
    mkdir -p ~/.config/alacritty; cd ~/.config/alacritty; ln -s ~/dotfiles/alacritty.yml alacritty.yml
    mkdir -p ~/.local/share/fonts; cd ~/.local/share/fonts; ln -s ~/dotfiles/assets/Cascadia.ttf Cascadia.ttf
    
	echo "Installing Vim-Plug ..."
	sleep 2
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' 
    
    echo "Starting Gogh to pick a color theme ..."
    sleep 2
    bash -c  "$(wget -qO- https://git.io/vQgMr)" 
}

deploy_df

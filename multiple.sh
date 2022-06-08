#!/bin/zsh

alacritty --hold -e ./start.sh -g germany1 -- &
alacritty --hold -e ./start.sh -g germany2 -- &
alacritty --hold -e ./start.sh -r westeurope -g europe1 -- &
alacritty --hold -e ./start.sh -r westeurope -g europe2 -- &
alacritty --hold -e ./start.sh -r switzerlandnorth -g swiss1 -- &
alacritty --hold -e ./start.sh -r switzerlandnorth -g swiss2 -- &

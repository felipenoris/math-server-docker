#!/bin/bash
#
# Add these instructions to your ~/.bashrc file to get automatic color for `ls` command.
#

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'

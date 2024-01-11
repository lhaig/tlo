#!/usr/bin/env bash

########################
# include the magic
########################
. ../demo-magic/demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20
export NOMAD_ADDR=http://nmd-svr1:4646 
#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# text color
# DEMO_CMD_COLOR=$BLACK

# hide the evidence
clear


# put your demo awesomeness here
#print and execute: check connection to nomad cluster
pe "nomad server members"

#print and execute: check connection to nomad cluster
pe "nomad node status"

#print and execute: check connection to nomad cluster
pe "nomad job status"

# print and execute: check connection to light
pe "./shellymgr"

# print and execute: turn on light
pe "./shellymgr -turn=on"

# print and execute: turn off light
pe "./shellymgr -turn=off"

# print and execute: turn light on using nomad job
pe "nomad job run -var="turn=on" jobs/light.nomad.hcl"

# print and execute: change light to color mode using nomad job
pe "nomad job run -var="mode=color" jobs/light.nomad.hcl"

# print and execute: change light to color mode using nomad job
pe "nomad job run -var="color=R" jobs/light.nomad.hcl"

# print and execute: change light to color mode using nomad job
pe "nomad job run -var="color=Y" jobs/light.nomad.hcl"

# print and execute: change light to color mode using nomad job
pe "nomad job run -var="color=G" jobs/light.nomad.hcl"

# print and execute: change light to color mode using nomad job
pe "nomad job run -var="mode=white" jobs/light.nomad.hcl"

# print and execute: turn light on using nomad job
pe "nomad job run -var="turn=off" jobs/light.nomad.hcl"

# ctl + c support: ctl + c to stop long-running process and continue demo
#pe "ping www.google.com"

# print and execute: echo 'hello world' > file.txt
#pe "echo 'hello world' > file.txt"

# wait max 3 seconds until user presses
#PROMPT_TIMEOUT=3
#wait

# print and execute immediately: ls -l
#pei "ls -l"
# print and execute immediately: cat file.txt
#pei "cat file.txt"

# and reset it to manual mode to wait until user presses enter
#PROMPT_TIMEOUT=0

# print only
#p "cat \"something you want to pretend to run\""

# run command behind
#cd .. && rm -rf stuff

# enters interactive mode and allows newly typed command to be executed
cmd

# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""

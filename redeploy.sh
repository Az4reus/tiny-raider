#!/usr/bin/env bash
cd /home/az/tiny-raider/
pkill ruby
git pull
nohup rake > tr.out 2> tr.err < /dev/null & 

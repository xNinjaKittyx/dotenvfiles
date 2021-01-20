#!/bin/bash

killall conky

conky -q -c ~/.conky/conky1/conkyrc1 &
conky -q -c ~/.conky/conky2/conkyrc2 & exit

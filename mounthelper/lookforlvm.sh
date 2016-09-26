#!/bin/bash

echo -e "Activate and show LVM disks\n"

vgscan
vgchange -ay
lvdisplay
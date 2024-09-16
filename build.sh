#!/bin/sh

mkdir -p "build/obj"

rgbgfx -o ./inc/img/chars.2bpp ./inc/img/chars.png

function build_rom () {
    rgbasm -o "./build/obj/$1.o" "./src/$1.asm"
    rgblink -o "./build/$1.gb" "./build/obj/$1.o"
    rgbfix -v -p 0xFF "./build/$1.gb"
}

build_rom "obj_xb"
build_rom "obj_xb_x_flip"
build_rom "obj_xb_y_flip"
build_rom "obj_xb_xy_flip"

build_rom "obj16_xb"
build_rom "obj16_xb_x_flip"
build_rom "obj16_xb_y_flip"
build_rom "obj16_xb_xy_flip"

build_rom "obj_yb"
build_rom "obj_yb_x_flip"
build_rom "obj_yb_y_flip"
build_rom "obj_yb_xy_flip"

build_rom "obj_xyb"
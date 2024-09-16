INCLUDE "inc/hardware.inc"
INCLUDE "inc/text-macros.inc"
INCLUDE "inc/subroutines.asm"

SECTION "VBlankInt", ROM0[$40]
	jp vblank_interrupt

SECTION "Header", ROM0[$100]

	jp entry_point

	ds $150 - @, 0 ; Make room for the header

entry_point:
	ld sp, $dfff

	; Turn PPU and APU off
	call wait_vblank
	ld a, 0
	ld [rNR52], a
	ld [rLCDC], a

	; Initialize VRAM and OAM
	call init_vram_oam

	; Write ROM title
	ld bc, background_test_name
	ld d, background_test_name.end - background_test_name
	ld hl, $9903
load_rom_title:
	ld a, [bc]
	ld [hli], a
	inc bc
	dec d
	jp nz, load_rom_title

	; Write OAM data
	ld bc, oam_data_corners
	ld de, oam_data_corners.end - oam_data_corners
	ld hl, $c100
load_oam:
	ld a, [bc]
	ld [hli], a
	inc bc
	dec de
	ld a, e
	or a, d
	jp nz, load_oam

	; Turn PPU on
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON |LCDCF_BG8000
	ld [rLCDC], a
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a
	ld a, %11011000
	ld [rOBP1], a
	ld a, 4
	ld [rSCX], a
	ld a, 0
	ld [rIF], a
	ld a, 1
	ld [rIE], a
	ei

main_loop:
	halt
	nop
	jr main_loop

wait_vblank:
	push af
wait_vblank_internal:
	ld a, [rLY]
	cp 144
	jr c, wait_vblank_internal
	pop af
	ret

INCLUDE "inc/bg.asm"
INCLUDE "inc/oam.asm"
char_tiles::
	INCBIN "inc/img/chars.2bpp"
.end:

background_test_name::
    db "obj_xyb"
.end
SECTION "Subroutines", ROM0[$1000]
init_vram_oam:
    push af
    push bc
    push de
    push hl

    ; Load tiles in VRAM
	ld bc, char_tiles
	ld de, char_tiles.end - char_tiles
	ld hl, $8010
load_tiles:
	ld a, [bc]
	ld [hli], a
	inc bc
	dec de
	ld a, e
	or a, d
	jp nz, load_tiles

	; Clear tilemap
	ld bc, $800
	ld hl, $9800
clear_tilemap:
	ld a, 0
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jp nz, clear_tilemap

	; Load Author Name
	ld bc, background_name
	ld d, background_name.end - background_name
	ld hl, $9943
load_name:
	ld a, [bc]
	ld [hli], a
	inc bc
	dec d
	jp nz, load_name

	; Clear OAM
	ld b, $a0
	ld hl, $c100
clear_oam:
	ld a, 0
	ld [hli], a
	dec b
	jp nz, clear_oam

	; Load OAM DMA Code
	ld de, OAMDMACode
	ld b, OAMDMACode.end - OAMDMACode
	ld hl, $ff80
load_oam_dma_hram:
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jp nz, load_oam_dma_hram

    pop hl
    pop de
    pop bc
    pop af
    ret


vblank_interrupt:
	di
	call $ff80
skip_movement:
	reti

OAMDMACode::
	ld a, $c1
	ldh [rDMA], a
	ld a, 40
.wait_dma
	dec a
	jr nz, .wait_dma
	ret
.end:
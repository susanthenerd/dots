{
  config,
  lib,
  pkgs,
  ...
}:
{
  hardware.uinput.enable = true; # Needed for Kanata to work!
  services.kanata = {
    enable = true;
    keyboards.internal = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      extraDefCfg = "process-unmapped-keys yes\n        concurrent-tap-hold yes";
      config = ''
        (defsrc
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          caps a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt rctl left up   down rght
        )

        ;; ============ HOME ROW MOD ALIASES ============
        ;; Base layer HRM - tap for letter, hold for modifier layer
        (defalias
          ;; Left hand: a=meta, s=alt, d=ctrl, f=shift
          hrm-a (tap-hold 200 200 a (layer-toggle lm))
          hrm-s (tap-hold 200 200 s (layer-toggle la))
          hrm-d (tap-hold 200 200 d (layer-toggle lc))
          hrm-f (tap-hold 200 200 f (layer-toggle ls))
          ;; Right hand: j=shift, k=ctrl, l=alt, ;=meta
          hrm-j (tap-hold 200 200 j (layer-toggle rs))
          hrm-k (tap-hold 200 200 k (layer-toggle rc))
          hrm-l (tap-hold 200 200 l (layer-toggle ra))
          hrm-; (tap-hold 200 200 ; (layer-toggle rm))
        )

        ;; ============ LEFT HAND COMBO ALIASES ============
        ;; When on lm (meta) layer, these activate combo layers
        (defalias
          lm-s (tap-hold 200 200 s (layer-toggle lm-la))  ;; meta + alt
          lm-d (tap-hold 200 200 d (layer-toggle lm-lc))  ;; meta + ctrl
          lm-f (tap-hold 200 200 f (layer-toggle lm-ls))  ;; meta + shift
        )
        ;; When on la (alt) layer
        (defalias
          la-a (tap-hold 200 200 a (layer-toggle lm-la))  ;; alt + meta
          la-d (tap-hold 200 200 d (layer-toggle la-lc))  ;; alt + ctrl
          la-f (tap-hold 200 200 f (layer-toggle la-ls))  ;; alt + shift
        )
        ;; When on lc (ctrl) layer
        (defalias
          lc-a (tap-hold 200 200 a (layer-toggle lm-lc))  ;; ctrl + meta
          lc-s (tap-hold 200 200 s (layer-toggle la-lc))  ;; ctrl + alt
          lc-f (tap-hold 200 200 f (layer-toggle lc-ls))  ;; ctrl + shift
        )
        ;; When on ls (shift) layer
        (defalias
          ls-a (tap-hold 200 200 a (layer-toggle lm-ls))  ;; shift + meta
          ls-s (tap-hold 200 200 s (layer-toggle la-ls))  ;; shift + alt
          ls-d (tap-hold 200 200 d (layer-toggle lc-ls))  ;; shift + ctrl
        )

        ;; ============ RIGHT HAND COMBO ALIASES ============
        ;; When on rs (shift) layer
        (defalias
          rs-k (tap-hold 200 200 k (layer-toggle rs-rc))  ;; shift + ctrl
          rs-l (tap-hold 200 200 l (layer-toggle rs-ra))  ;; shift + alt
          rs-; (tap-hold 200 200 ; (layer-toggle rs-rm))  ;; shift + meta
        )
        ;; When on rc (ctrl) layer
        (defalias
          rc-j (tap-hold 200 200 j (layer-toggle rs-rc))  ;; ctrl + shift
          rc-l (tap-hold 200 200 l (layer-toggle rc-ra))  ;; ctrl + alt
          rc-; (tap-hold 200 200 ; (layer-toggle rc-rm))  ;; ctrl + meta
        )
        ;; When on ra (alt) layer
        (defalias
          ra-j (tap-hold 200 200 j (layer-toggle rs-ra))  ;; alt + shift
          ra-k (tap-hold 200 200 k (layer-toggle rc-ra))  ;; alt + ctrl
          ra-; (tap-hold 200 200 ; (layer-toggle ra-rm))  ;; alt + meta
        )
        ;; When on rm (meta) layer
        (defalias
          rm-j (tap-hold 200 200 j (layer-toggle rs-rm))  ;; meta + shift
          rm-k (tap-hold 200 200 k (layer-toggle rc-rm))  ;; meta + ctrl
          rm-l (tap-hold 200 200 l (layer-toggle ra-rm))  ;; meta + alt
        )

        ;; ============ THREE-MOD COMBO ALIASES (LEFT) ============
        ;; meta+alt layer -> add ctrl or shift
        (defalias
          lm-la-d (tap-hold 200 200 d (layer-toggle lm-la-lc))
          lm-la-f (tap-hold 200 200 f (layer-toggle lm-la-ls))
        )
        ;; meta+ctrl layer -> add alt or shift
        (defalias
          lm-lc-s (tap-hold 200 200 s (layer-toggle lm-la-lc))
          lm-lc-f (tap-hold 200 200 f (layer-toggle lm-lc-ls))
        )
        ;; meta+shift layer -> add alt or ctrl
        (defalias
          lm-ls-s (tap-hold 200 200 s (layer-toggle lm-la-ls))
          lm-ls-d (tap-hold 200 200 d (layer-toggle lm-lc-ls))
        )
        ;; alt+ctrl layer -> add meta or shift
        (defalias
          la-lc-a (tap-hold 200 200 a (layer-toggle lm-la-lc))
          la-lc-f (tap-hold 200 200 f (layer-toggle la-lc-ls))
        )
        ;; alt+shift layer -> add meta or ctrl
        (defalias
          la-ls-a (tap-hold 200 200 a (layer-toggle lm-la-ls))
          la-ls-d (tap-hold 200 200 d (layer-toggle la-lc-ls))
        )
        ;; ctrl+shift layer -> add meta or alt
        (defalias
          lc-ls-a (tap-hold 200 200 a (layer-toggle lm-lc-ls))
          lc-ls-s (tap-hold 200 200 s (layer-toggle la-lc-ls))
        )

        ;; ============ THREE-MOD COMBO ALIASES (RIGHT) ============
        ;; shift+ctrl layer -> add alt or meta
        (defalias
          rs-rc-l (tap-hold 200 200 l (layer-toggle rs-rc-ra))
          rs-rc-; (tap-hold 200 200 ; (layer-toggle rs-rc-rm))
        )
        ;; shift+alt layer -> add ctrl or meta
        (defalias
          rs-ra-k (tap-hold 200 200 k (layer-toggle rs-rc-ra))
          rs-ra-; (tap-hold 200 200 ; (layer-toggle rs-ra-rm))
        )
        ;; shift+meta layer -> add ctrl or alt
        (defalias
          rs-rm-k (tap-hold 200 200 k (layer-toggle rs-rc-rm))
          rs-rm-l (tap-hold 200 200 l (layer-toggle rs-ra-rm))
        )
        ;; ctrl+alt layer -> add shift or meta
        (defalias
          rc-ra-j (tap-hold 200 200 j (layer-toggle rs-rc-ra))
          rc-ra-; (tap-hold 200 200 ; (layer-toggle rc-ra-rm))
        )
        ;; ctrl+meta layer -> add shift or alt
        (defalias
          rc-rm-j (tap-hold 200 200 j (layer-toggle rs-rc-rm))
          rc-rm-l (tap-hold 200 200 l (layer-toggle rc-ra-rm))
        )
        ;; alt+meta layer -> add shift or ctrl
        (defalias
          ra-rm-j (tap-hold 200 200 j (layer-toggle rs-ra-rm))
          ra-rm-k (tap-hold 200 200 k (layer-toggle rc-ra-rm))
        )

        ;; ============ FOUR-MOD COMBO ALIASES ============
        (defalias
          ;; Left hand three-mod layers -> four-mod
          lm-la-lc-f (tap-hold 200 200 f (layer-toggle lm-la-lc-ls))
          lm-la-ls-d (tap-hold 200 200 d (layer-toggle lm-la-lc-ls))
          lm-lc-ls-s (tap-hold 200 200 s (layer-toggle lm-la-lc-ls))
          la-lc-ls-a (tap-hold 200 200 a (layer-toggle lm-la-lc-ls))
          ;; Right hand three-mod layers -> four-mod
          rs-rc-ra-; (tap-hold 200 200 ; (layer-toggle rs-rc-ra-rm))
          rs-rc-rm-l (tap-hold 200 200 l (layer-toggle rs-rc-ra-rm))
          rs-ra-rm-k (tap-hold 200 200 k (layer-toggle rs-rc-ra-rm))
          rc-ra-rm-j (tap-hold 200 200 j (layer-toggle rs-rc-ra-rm))
        )

        ;; ============ LAYER SWITCH ALIASES ============
        (defalias
          gam (layer-switch gaming)
          def (layer-switch default)
          ;; Toggle between default and gaming - checks current layer
          toggle-gam (switch
            ((layer gaming)) (layer-switch default) break
            () (layer-switch gaming) break
          )
        )

        ;; Chord: hold lalt + ralt together for 200ms to toggle between default/gaming
        (defchordsv2
          (lalt ralt) (tap-hold 0 200 XX @toggle-gam) 200 all-released ()
        )
        ;; Lower layer alias (instant hold on lalt)
        (defalias
          lower (layer-while-held lower)
        )

        ;; ============ DEFAULT LAYER ============
        ;; Physical modifiers disabled (XX), use home row mods instead
        ;; lalt = lower layer (arrows), chord lalt+ralt = toggle gaming
        (deflayer default
          =    1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          esc  @hrm-a @hrm-s @hrm-d @hrm-f g h @hrm-j @hrm-k @hrm-l @hrm-; ' ret
          grv  z    x    c    v    b    n    m    ,    .    /    XX
          XX   XX   @lower           spc            ralt [    ]    XX   XX   XX
        )

        ;; ============ GAMING LAYER ============
        ;; No HRM, regular modifiers work, chord lalt+ralt to switch back
        (deflayer gaming
          grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
          tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
          esc  a    s    d    f    g    h    j    k    l    ;    '    ret
          lsft z    x    c    v    b    n    m    ,    .    /    rsft
          lctl lmet lalt           spc            ralt rctl left up down rght
        )

        ;; ============ LOWER LAYER ============
        ;; Hold lalt: left hand modifiers (a=win, s=alt, d=ctrl, f=shift), right hand hjkl = arrows
        (deflayer lower
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _    _    _
          _    lmet lalt lctl lsft _    left down up   rght _    _    _
          _    _    _    _    _    _    _    _    _    _    _    _
          _    _    _              _              _    _    _    _    _    _
        )

        ;; ============ SINGLE MODIFIER LAYERS (LEFT HAND) ============
        ;; lm = left meta (hold A)
        (deflayer lm
          M-=  _    _    _    _    _    M-6  M-7  M-8  M-9  M-0  M--  M-=  M-bspc
          _    _    _    _    _    _    M-y  M-u  M-i  M-o  M-p  M-\  M-]  M-\
          _    a    @lm-s @lm-d @lm-f _ M-h  M-j  M-k  M-l  M-;  M-'  M-ret
          M-grv _    _    _    _    _    M-n  M-m  M-,  M-.  M-/  _
          _    _    _              M-spc  M-[  M-]  M-left M-up M-down M-rght
        )
        ;; la = left alt (hold S)
        (deflayer la
          A-=  _    _    _    _    _    A-6  A-7  A-8  A-9  A-0  A--  A-=  A-bspc
          _    _    _    _    _    _    A-y  A-u  A-i  A-o  A-p  A-\  A-]  A-\
          _    @la-a s    @la-d @la-f _ A-h  A-j  A-k  A-l  A-;  A-'  A-ret
          A-grv _    _    _    _    _    A-n  A-m  A-,  A-.  A-/  _
          _    _    _              A-spc  A-[  A-]  A-left A-up A-down A-rght
        )
        ;; lc = left ctrl (hold D)
        (deflayer lc
          C-=  _    _    _    _    _    C-6  C-7  C-8  C-9  C-0  C--  C-=  C-bspc
          _    _    _    _    _    _    C-y  C-u  C-i  C-o  C-p  C-\  C-]  C-\
          _    @lc-a @lc-s d    @lc-f _ C-h  C-j  C-k  C-l  C-;  C-'  C-ret
          C-grv _    _    _    _    _    C-n  C-m  C-,  C-.  C-/  _
          _    _    _              C-spc  C-[  C-]  C-left C-up C-down C-rght
        )
        ;; ls = left shift (hold F)
        (deflayer ls
          S-=  _    _    _    _    _    S-6  S-7  S-8  S-9  S-0  S--  S-=  S-bspc
          _    _    _    _    _    _    S-y  S-u  S-i  S-o  S-p  S-\  S-]  S-\
          _    @ls-a @ls-s @ls-d f    _ S-h  S-j  S-k  S-l  S-;  S-'  S-ret
          S-grv _    _    _    _    _    S-n  S-m  S-,  S-.  S-/  _
          _    _    _              S-spc  S-[  S-]  S-left S-up S-down S-rght
        )

        ;; ============ SINGLE MODIFIER LAYERS (RIGHT HAND) ============
        ;; rs = right shift (hold J)
        (deflayer rs
          S-= S-1  S-2  S-3  S-4  S-5  _    _    _    _    _    _    _    _
          S-tab S-q  S-w  S-e  S-r  S-t  _    _    _    _    _    _    _    _
          _    S-a  S-s  S-d  S-f  S-g  _    j    @rs-k @rs-l @rs-; _    _
          S-grv S-z  S-x  S-c  S-v  S-b  _    _    _    _    _    _
          _    _    _              S-spc  S-[  S-]  S-left S-up S-down S-rght
        )
        ;; rc = right ctrl (hold K)
        (deflayer rc
          C-= C-1  C-2  C-3  C-4  C-5  _    _    _    _    _    _    _    _
          C-tab C-q  C-w  C-e  C-r  C-t  _    _    _    _    _    _    _    _
          _    C-a  C-s  C-d  C-f  C-g  _    @rc-j k    @rc-l @rc-; _    _
          C-grv C-z  C-x  C-c  C-v  C-b  _    _    _    _    _    _
          _    _    _              C-spc  C-[  C-]  C-left C-up C-down C-rght
        )
        ;; ra = right alt (hold L)
        (deflayer ra
          A-= A-1  A-2  A-3  A-4  A-5  _    _    _    _    _    _    _    _
          A-tab A-q  A-w  A-e  A-r  A-t  _    _    _    _    _    _    _    _
          _    A-a  A-s  A-d  A-f  A-g  _    @ra-j @ra-k l    @ra-; _    _
          A-grv A-z  A-x  A-c  A-v  A-b  _    _    _    _    _    _
          _    _    _              A-spc  A-[  A-]  A-left A-up A-down A-rght
        )
        ;; rm = right meta (hold ;)
        (deflayer rm
          M-= M-1  M-2  M-3  M-4  M-5  _    _    _    _    _    _    _    _
          M-tab M-q  M-w  M-e  M-r  M-t  _    _    _    _    _    _    _    _
          _    M-a  M-s  M-d  M-f  M-g  _    @rm-j @rm-k @rm-l ;    _    _
          M-grv M-z  M-x  M-c  M-v  M-b  _    _    _    _    _    _
          _    _    _              M-spc  M-[  M-]  M-left M-up M-down M-rght
        )

        ;; ============ TWO-MODIFIER LAYERS (LEFT HAND) ============
        ;; lm-la = meta + alt
        (deflayer lm-la
          M-A-= _    _    _    _    _    M-A-6  M-A-7  M-A-8  M-A-9  M-A-0  M-A--  M-A-=  M-A-bspc
          _    _    _    _    _    _    M-A-y  M-A-u  M-A-i  M-A-o  M-A-p  M-A-\  M-A-]  M-A-\
          _    a    s    @lm-la-d @lm-la-f _ M-A-h M-A-j M-A-k M-A-l M-A-; M-A-' M-A-ret
          M-A-grv _    _    _    _    _    M-A-n  M-A-m  M-A-,  M-A-.  M-A-/  _
          _    _    _              M-A-spc  M-A-[  M-A-]  M-A-left M-A-up M-A-down M-A-rght
        )
        ;; lm-lc = meta + ctrl
        (deflayer lm-lc
          M-C-= _    _    _    _    _    M-C-6  M-C-7  M-C-8  M-C-9  M-C-0  M-C--  M-C-=  M-C-bspc
          _    _    _    _    _    _    M-C-y  M-C-u  M-C-i  M-C-o  M-C-p  M-C-\  M-C-]  M-C-\
          _    a    @lm-lc-s d    @lm-lc-f _ M-C-h M-C-j M-C-k M-C-l M-C-; M-C-' M-C-ret
          M-C-grv _    _    _    _    _    M-C-n  M-C-m  M-C-,  M-C-.  M-C-/  _
          _    _    _              M-C-spc  M-C-[  M-C-]  M-C-left M-C-up M-C-down M-C-rght
        )
        ;; lm-ls = meta + shift
        (deflayer lm-ls
          M-S-= _    _    _    _    _    M-S-6  M-S-7  M-S-8  M-S-9  M-S-0  M-S--  M-S-=  M-S-bspc
          _    _    _    _    _    _    M-S-y  M-S-u  M-S-i  M-S-o  M-S-p  M-S-\  M-S-]  M-S-\
          _    a    @lm-ls-s @lm-ls-d f _ M-S-h M-S-j M-S-k M-S-l M-S-; M-S-' M-S-ret
          M-S-grv _    _    _    _    _    M-S-n  M-S-m  M-S-,  M-S-.  M-S-/  _
          _    _    _              M-S-spc  M-S-[  M-S-]  M-S-left M-S-up M-S-down M-S-rght
        )
        ;; la-lc = alt + ctrl
        (deflayer la-lc
          A-C-= _    _    _    _    _    A-C-6  A-C-7  A-C-8  A-C-9  A-C-0  A-C--  A-C-=  A-C-bspc
          _    _    _    _    _    _    A-C-y  A-C-u  A-C-i  A-C-o  A-C-p  A-C-\  A-C-]  A-C-\
          _    @la-lc-a s    d    @la-lc-f _ A-C-h A-C-j A-C-k A-C-l A-C-; A-C-' A-C-ret
          A-C-grv _    _    _    _    _    A-C-n  A-C-m  A-C-,  A-C-.  A-C-/  _
          _    _    _              A-C-spc  A-C-[  A-C-]  A-C-left A-C-up A-C-down A-C-rght
        )
        ;; la-ls = alt + shift
        (deflayer la-ls
          A-S-= _    _    _    _    _    A-S-6  A-S-7  A-S-8  A-S-9  A-S-0  A-S--  A-S-=  A-S-bspc
          _    _    _    _    _    _    A-S-y  A-S-u  A-S-i  A-S-o  A-S-p  A-S-\  A-S-]  A-S-\
          _    @la-ls-a s    @la-ls-d f _ A-S-h A-S-j A-S-k A-S-l A-S-; A-S-' A-S-ret
          A-S-grv _    _    _    _    _    A-S-n  A-S-m  A-S-,  A-S-.  A-S-/  _
          _    _    _              A-S-spc  A-S-[  A-S-]  A-S-left A-S-up A-S-down A-S-rght
        )
        ;; lc-ls = ctrl + shift
        (deflayer lc-ls
          C-S-= _    _    _    _    _    C-S-6  C-S-7  C-S-8  C-S-9  C-S-0  C-S--  C-S-=  C-S-bspc
          _    _    _    _    _    _    C-S-y  C-S-u  C-S-i  C-S-o  C-S-p  C-S-\  C-S-]  C-S-\
          _    @lc-ls-a @lc-ls-s d    f _ C-S-h C-S-j C-S-k C-S-l C-S-; C-S-' C-S-ret
          C-S-grv _    _    _    _    _    C-S-n  C-S-m  C-S-,  C-S-.  C-S-/  _
          _    _    _              C-S-spc  C-S-[  C-S-]  C-S-left C-S-up C-S-down C-S-rght
        )

        ;; ============ TWO-MODIFIER LAYERS (RIGHT HAND) ============
        ;; rs-rc = shift + ctrl
        (deflayer rs-rc
          C-S-= C-S-1  C-S-2  C-S-3  C-S-4  C-S-5  _    _    _    _    _    _    _    _
          C-S-tab C-S-q  C-S-w  C-S-e  C-S-r  C-S-t  _    _    _    _    _    _    _    _
          _    C-S-a  C-S-s  C-S-d  C-S-f  C-S-g  _    j    k    @rs-rc-l @rs-rc-; _    _
          C-S-grv C-S-z  C-S-x  C-S-c  C-S-v  C-S-b  _    _    _    _    _    _
          _    _    _              C-S-spc  C-S-[  C-S-]  C-S-left C-S-up C-S-down C-S-rght
        )
        ;; rs-ra = shift + alt
        (deflayer rs-ra
          A-S-= A-S-1  A-S-2  A-S-3  A-S-4  A-S-5  _    _    _    _    _    _    _    _
          A-S-tab A-S-q  A-S-w  A-S-e  A-S-r  A-S-t  _    _    _    _    _    _    _    _
          _    A-S-a  A-S-s  A-S-d  A-S-f  A-S-g  _    j    @rs-ra-k l    @rs-ra-; _    _
          A-S-grv A-S-z  A-S-x  A-S-c  A-S-v  A-S-b  _    _    _    _    _    _
          _    _    _              A-S-spc  A-S-[  A-S-]  A-S-left A-S-up A-S-down A-S-rght
        )
        ;; rs-rm = shift + meta
        (deflayer rs-rm
          M-S-= M-S-1  M-S-2  M-S-3  M-S-4  M-S-5  _    _    _    _    _    _    _    _
          M-S-tab M-S-q  M-S-w  M-S-e  M-S-r  M-S-t  _    _    _    _    _    _    _    _
          _    M-S-a  M-S-s  M-S-d  M-S-f  M-S-g  _    j    @rs-rm-k @rs-rm-l ;    _    _
          M-S-grv M-S-z  M-S-x  M-S-c  M-S-v  M-S-b  _    _    _    _    _    _
          _    _    _              M-S-spc  M-S-[  M-S-]  M-S-left M-S-up M-S-down M-S-rght
        )
        ;; rc-ra = ctrl + alt
        (deflayer rc-ra
          A-C-= A-C-1  A-C-2  A-C-3  A-C-4  A-C-5  _    _    _    _    _    _    _    _
          A-C-tab A-C-q  A-C-w  A-C-e  A-C-r  A-C-t  _    _    _    _    _    _    _    _
          _    A-C-a  A-C-s  A-C-d  A-C-f  A-C-g  _    @rc-ra-j k    l    @rc-ra-; _    _
          A-C-grv A-C-z  A-C-x  A-C-c  A-C-v  A-C-b  _    _    _    _    _    _
          _    _    _              A-C-spc  A-C-[  A-C-]  A-C-left A-C-up A-C-down A-C-rght
        )
        ;; rc-rm = ctrl + meta
        (deflayer rc-rm
          M-C-= M-C-1  M-C-2  M-C-3  M-C-4  M-C-5  _    _    _    _    _    _    _    _
          M-C-tab M-C-q  M-C-w  M-C-e  M-C-r  M-C-t  _    _    _    _    _    _    _    _
          _    M-C-a  M-C-s  M-C-d  M-C-f  M-C-g  _    @rc-rm-j k    @rc-rm-l ;    _    _
          M-C-grv M-C-z  M-C-x  M-C-c  M-C-v  M-C-b  _    _    _    _    _    _
          _    _    _              M-C-spc  M-C-[  M-C-]  M-C-left M-C-up M-C-down M-C-rght
        )
        ;; ra-rm = alt + meta
        (deflayer ra-rm
          M-A-= M-A-1  M-A-2  M-A-3  M-A-4  M-A-5  _    _    _    _    _    _    _    _
          M-A-tab M-A-q  M-A-w  M-A-e  M-A-r  M-A-t  _    _    _    _    _    _    _    _
          _    M-A-a  M-A-s  M-A-d  M-A-f  M-A-g  _    @ra-rm-j @ra-rm-k l    ;    _    _
          M-A-grv M-A-z  M-A-x  M-A-c  M-A-v  M-A-b  _    _    _    _    _    _
          _    _    _              M-A-spc  M-A-[  M-A-]  M-A-left M-A-up M-A-down M-A-rght
        )

        ;; ============ THREE-MODIFIER LAYERS (LEFT HAND) ============
        ;; lm-la-lc = meta + alt + ctrl
        (deflayer lm-la-lc
          M-A-C-= _    _    _    _    _    M-A-C-6  M-A-C-7  M-A-C-8  M-A-C-9  M-A-C-0  M-A-C--  M-A-C-=  M-A-C-bspc
          _    _    _    _    _    _    M-A-C-y  M-A-C-u  M-A-C-i  M-A-C-o  M-A-C-p  M-A-C-\  M-A-C-]  M-A-C-\
          _    a    s    d    @lm-la-lc-f _ M-A-C-h M-A-C-j M-A-C-k M-A-C-l M-A-C-; M-A-C-' M-A-C-ret
          M-A-C-grv _    _    _    _    _    M-A-C-n  M-A-C-m  M-A-C-,  M-A-C-.  M-A-C-/  _
          _    _    _              M-A-C-spc  M-A-C-[  M-A-C-]  M-A-C-left M-A-C-up M-A-C-down M-A-C-rght
        )
        ;; lm-la-ls = meta + alt + shift
        (deflayer lm-la-ls
          M-A-S-= _    _    _    _    _    M-A-S-6  M-A-S-7  M-A-S-8  M-A-S-9  M-A-S-0  M-A-S--  M-A-S-=  M-A-S-bspc
          _    _    _    _    _    _    M-A-S-y  M-A-S-u  M-A-S-i  M-A-S-o  M-A-S-p  M-A-S-\  M-A-S-]  M-A-S-\
          _    a    s    @lm-la-ls-d f _ M-A-S-h M-A-S-j M-A-S-k M-A-S-l M-A-S-; M-A-S-' M-A-S-ret
          M-A-S-grv _    _    _    _    _    M-A-S-n  M-A-S-m  M-A-S-,  M-A-S-.  M-A-S-/  _
          _    _    _              M-A-S-spc  M-A-S-[  M-A-S-]  M-A-S-left M-A-S-up M-A-S-down M-A-S-rght
        )
        ;; lm-lc-ls = meta + ctrl + shift
        (deflayer lm-lc-ls
          M-C-S-= _    _    _    _    _    M-C-S-6  M-C-S-7  M-C-S-8  M-C-S-9  M-C-S-0  M-C-S--  M-C-S-=  M-C-S-bspc
          _    _    _    _    _    _    M-C-S-y  M-C-S-u  M-C-S-i  M-C-S-o  M-C-S-p  M-C-S-\  M-C-S-]  M-C-S-\
          _    a    @lm-lc-ls-s d    f _ M-C-S-h M-C-S-j M-C-S-k M-C-S-l M-C-S-; M-C-S-' M-C-S-ret
          M-C-S-grv _    _    _    _    _    M-C-S-n  M-C-S-m  M-C-S-,  M-C-S-.  M-C-S-/  _
          _    _    _              M-C-S-spc  M-C-S-[  M-C-S-]  M-C-S-left M-C-S-up M-C-S-down M-C-S-rght
        )
        ;; la-lc-ls = alt + ctrl + shift
        (deflayer la-lc-ls
          A-C-S-= _    _    _    _    _    A-C-S-6  A-C-S-7  A-C-S-8  A-C-S-9  A-C-S-0  A-C-S--  A-C-S-=  A-C-S-bspc
          _    _    _    _    _    _    A-C-S-y  A-C-S-u  A-C-S-i  A-C-S-o  A-C-S-p  A-C-S-\  A-C-S-]  A-C-S-\
          _    @la-lc-ls-a s    d    f _ A-C-S-h A-C-S-j A-C-S-k A-C-S-l A-C-S-; A-C-S-' A-C-S-ret
          A-C-S-grv _    _    _    _    _    A-C-S-n  A-C-S-m  A-C-S-,  A-C-S-.  A-C-S-/  _
          _    _    _              A-C-S-spc  A-C-S-[  A-C-S-]  A-C-S-left A-C-S-up A-C-S-down A-C-S-rght
        )

        ;; ============ THREE-MODIFIER LAYERS (RIGHT HAND) ============
        ;; rs-rc-ra = shift + ctrl + alt
        (deflayer rs-rc-ra
          A-C-S-= A-C-S-1  A-C-S-2  A-C-S-3  A-C-S-4  A-C-S-5  _    _    _    _    _    _    _    _
          A-C-S-tab A-C-S-q  A-C-S-w  A-C-S-e  A-C-S-r  A-C-S-t  _    _    _    _    _    _    _    _
          _    A-C-S-a  A-C-S-s  A-C-S-d  A-C-S-f  A-C-S-g  _    j    k    l    @rs-rc-ra-; _    _
          A-C-S-grv A-C-S-z  A-C-S-x  A-C-S-c  A-C-S-v  A-C-S-b  _    _    _    _    _    _
          _    _    _              A-C-S-spc  A-C-S-[  A-C-S-]  A-C-S-left A-C-S-up A-C-S-down A-C-S-rght
        )
        ;; rs-rc-rm = shift + ctrl + meta
        (deflayer rs-rc-rm
          M-C-S-= M-C-S-1  M-C-S-2  M-C-S-3  M-C-S-4  M-C-S-5  _    _    _    _    _    _    _    _
          M-C-S-tab M-C-S-q  M-C-S-w  M-C-S-e  M-C-S-r  M-C-S-t  _    _    _    _    _    _    _    _
          _    M-C-S-a  M-C-S-s  M-C-S-d  M-C-S-f  M-C-S-g  _    j    k    @rs-rc-rm-l ;    _    _
          M-C-S-grv M-C-S-z  M-C-S-x  M-C-S-c  M-C-S-v  M-C-S-b  _    _    _    _    _    _
          _    _    _              M-C-S-spc  M-C-S-[  M-C-S-]  M-C-S-left M-C-S-up M-C-S-down M-C-S-rght
        )
        ;; rs-ra-rm = shift + alt + meta
        (deflayer rs-ra-rm
          M-A-S-= M-A-S-1  M-A-S-2  M-A-S-3  M-A-S-4  M-A-S-5  _    _    _    _    _    _    _    _
          M-A-S-tab M-A-S-q  M-A-S-w  M-A-S-e  M-A-S-r  M-A-S-t  _    _    _    _    _    _    _    _
          _    M-A-S-a  M-A-S-s  M-A-S-d  M-A-S-f  M-A-S-g  _    j    @rs-ra-rm-k l    ;    _    _
          M-A-S-grv M-A-S-z  M-A-S-x  M-A-S-c  M-A-S-v  M-A-S-b  _    _    _    _    _    _
          _    _    _              M-A-S-spc  M-A-S-[  M-A-S-]  M-A-S-left M-A-S-up M-A-S-down M-A-S-rght
        )
        ;; rc-ra-rm = ctrl + alt + meta
        (deflayer rc-ra-rm
          M-A-C-= M-A-C-1  M-A-C-2  M-A-C-3  M-A-C-4  M-A-C-5  _    _    _    _    _    _    _    _
          M-A-C-tab M-A-C-q  M-A-C-w  M-A-C-e  M-A-C-r  M-A-C-t  _    _    _    _    _    _    _    _
          _    M-A-C-a  M-A-C-s  M-A-C-d  M-A-C-f  M-A-C-g  _    @rc-ra-rm-j k    l    ;    _    _
          M-A-C-grv M-A-C-z  M-A-C-x  M-A-C-c  M-A-C-v  M-A-C-b  _    _    _    _    _    _
          _    _    _              M-A-C-spc  M-A-C-[  M-A-C-]  M-A-C-left M-A-C-up M-A-C-down M-A-C-rght
        )

        ;; ============ FOUR-MODIFIER LAYERS ============
        ;; lm-la-lc-ls = meta + alt + ctrl + shift (left hand)
        (deflayer lm-la-lc-ls
          M-A-C-S-= _    _    _    _    _    M-A-C-S-6  M-A-C-S-7  M-A-C-S-8  M-A-C-S-9  M-A-C-S-0  M-A-C-S--  M-A-C-S-=  M-A-C-S-bspc
          _    _    _    _    _    _    M-A-C-S-y  M-A-C-S-u  M-A-C-S-i  M-A-C-S-o  M-A-C-S-p  M-A-C-S-\  M-A-C-S-]  M-A-C-S-\
          _    a    s    d    f    _    M-A-C-S-h  M-A-C-S-j  M-A-C-S-k  M-A-C-S-l  M-A-C-S-;  M-A-C-S-'  M-A-C-S-ret
          M-A-C-S-grv _    _    _    _    _    M-A-C-S-n  M-A-C-S-m  M-A-C-S-,  M-A-C-S-.  M-A-C-S-/  _
          _    _    _              M-A-C-S-spc  M-A-C-S-[  M-A-C-S-]  M-A-C-S-left M-A-C-S-up M-A-C-S-down M-A-C-S-rght
        )
        ;; rs-rc-ra-rm = shift + ctrl + alt + meta (right hand)
        (deflayer rs-rc-ra-rm
          M-A-C-S-= M-A-C-S-1  M-A-C-S-2  M-A-C-S-3  M-A-C-S-4  M-A-C-S-5  _    _    _    _    _    _    _    _
          M-A-C-S-tab M-A-C-S-q  M-A-C-S-w  M-A-C-S-e  M-A-C-S-r  M-A-C-S-t  _    _    _    _    _    _    _    _
          _    M-A-C-S-a  M-A-C-S-s  M-A-C-S-d  M-A-C-S-f  M-A-C-S-g  _    j    k    l    ;    _    _
          M-A-C-S-grv M-A-C-S-z  M-A-C-S-x  M-A-C-S-c  M-A-C-S-v  M-A-C-S-b  _    _    _    _    _    _
          _    _    _              M-A-C-S-spc  M-A-C-S-[  M-A-C-S-]  M-A-C-S-left M-A-C-S-up M-A-C-S-down M-A-C-S-rght
        )
      '';
    };
  };
}

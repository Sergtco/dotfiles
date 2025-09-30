{...}: {
  services.kanata = {
    enable = true;
    keyboards = {
      internal = {
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt menu rctl
          )

          (defvar
            tap-time 200
            hold-time 150
          )

          (deflayermap (base)
            tab  esc
            lalt tab
            spc  (tap-hold $tap-time $hold-time spc (layer-while-held nav))
            ralt (tap-hold $tap-time $hold-time ralt   (layer-while-held layers))
            a    (tap-hold $tap-time $hold-time a   lmet)
            s    (tap-hold $tap-time $hold-time s   lalt)
            d    (tap-hold $tap-time $hold-time d   lctl)
            f    (tap-hold $tap-time $hold-time f   lsft)
            j    (tap-hold $tap-time $hold-time j   rsft)
            k    (tap-hold $tap-time $hold-time k   rctl)
            l    (tap-hold $tap-time $hold-time l   ralt)
            ;    (tap-hold $tap-time $hold-time ;   rmet)
          )

          (deflayermap (nav)
            e up
            s left
            d down
            f right
            i ◀◀
            o ▶⏸
            p ▶▶
          )

          (deflayermap (layers)
            1 (layer-switch base)
            2 (layer-switch clean)
          )

          (deflayermap (clean)
            ralt (tap-hold $tap-time $hold-time ralt   (layer-while-held layers))
          )
        '';
      };
    };
  };
}

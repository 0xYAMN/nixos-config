{ ... }: {
  # Apple-style keyboards: F-keys act as F1-F12 by default (fnmode=2),
  # media keys need Fn.
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
}

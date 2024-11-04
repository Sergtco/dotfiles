{
  lib,
  fetchFromGitHub,
  rustPlatform,
  udev,
  dbus,
  pulseaudio,
  pkg-config,
  xorg,
}:
rustPlatform.buildRustPackage rec {
  pname = "qmk-hid-host";
  version = "latest";

  src = fetchFromGitHub {
    owner = "ergohaven";
    repo = "qmk-hid-host";
    rev = "latest";
    hash = "sha256-wJ7IhEqUjSYmnMzrhhUAYAo1RJ0X5Hn+3+nqVf9Fz/Y=";
  };
  cargoHash = "sha256-ZAowpEhzvvBh7m3sLvJG3dHEleUFh9ixpJN45J0Pejw=";

  buildInputs = [
    udev
    xorg.libX11
    dbus
    pulseaudio
  ];
  nativeBuildInputs = [ pkg-config ];

  installPhase = ''
    mkdir -p $out/bin
    cp qmk-hid-host $out/bin
  ''
  meta = {
    description = "Host component for communicating with QMK keyboards using Raw HID feature.";
    homepage = "https://github.com/ergohaven/qmk-hid-host";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ];
  };
}

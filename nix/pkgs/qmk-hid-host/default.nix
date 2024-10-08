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
  version = "aca5255203aba3f7e30638d415499fc201209b9e";

  src = fetchFromGitHub {
    owner = "ergohaven";
    repo = pname;
    rev = version;
    hash = "sha256-wJ7IhEqUjSYmnMzrhhUAYAo1RJ0X5Hn+3+nqVf9Fz/Y=";
  };
  cargoHash = "sha256-/ksF5NjTEO240C0P2rcoMZ6oO9O4y+X+aN0LGUsMzuU=";

  buildInputs = [
    udev
    xorg.libX11
    dbus
    pulseaudio
  ];
  nativeBuildInputs = [pkg-config];

  meta = {
    description = "Host component for communicating with QMK keyboards using Raw HID feature.";
    homepage = "https://github.com/ergohaven/qmk-hid-host";
    license = lib.licenses.unlicense;
  };
}

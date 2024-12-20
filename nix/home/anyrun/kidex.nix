{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "kidex";
  version = "d1aad240eb0bac7f017183fc80b0dc41f49a98d3";

  src = fetchFromGitHub {
    owner = "Kirottu";
    repo = pname;
    rev = version;
    hash = "sha256-LgY4hYJOzGSNZxOK1O4L6A+4/qgv4dhouKo0nLKK25A=";
  };
  cargoHash = "sha256-EMQy+C3gcIyxfaQHfjM+9RE2ZB+ZEeA4ddBGoD9Zm1c=";

  meta = {
    description = "A simple file indexing service for looking up file locations";
    homepage = "https://github.com/Kirottu/kidex";
    license = lib.licenses.gpl3Only;
  };
}

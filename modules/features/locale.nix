_: {
  # English UI, Russian formatting/collation, us+ru keyboard.
  flake.nixosModules.locale =
    { lib, ... }:
    {
      time.timeZone = lib.mkDefault "Europe/Moscow";

      services.xserver.xkb.layout = "us, ru";

      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LANGUAGE = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        LC_CTYPE = "ru_RU.UTF-8";
        LC_COLLATE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
        LC_MESSAGES = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_ADDRESS = "ru_RU.UTF-8";
      };
    };
}

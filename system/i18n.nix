{
  base,
  lib,
  ...
}: {
  time.timeZone = base.timeZone;

  # i'd rather set the locale stuff per user and just have global
  # defaultLocale of "en_GB.UTF-8", but apparently that's not
  # possible
  i18n = {
    defaultLocale = base.locale.default;
    extraLocaleSettings = let
      optSet = name:
        if base.locale ? name
        then {${"LC_" + lib.strings.toUpper name} = base.locale.${name};}
        else {};
    in
      optSet "address"
      // optSet "collate"
      // optSet "ctype"
      // optSet "identification"
      // optSet "monetary"
      // optSet "messages"
      // optSet "measurement"
      // optSet "name"
      // optSet "numeric"
      // optSet "paper"
      // optSet "telephone"
      // optSet "time"
      // optSet "all";
  };
}

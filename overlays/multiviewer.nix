final: prev:

{
  multiviewer-for-f1 = prev.multiviewer-for-f1.overrideAttrs (oldAttrs: {
    version = "2.3.0";

    src = prev.fetchurl {
      url = "https://releases.multiviewer.app/download/305607196/multiviewer_2.3.0_amd64.deb";
      sha256 = "sha256-Uc4db2o4XBV9eRNugxS6pA9Z5YhjY5QnEkwOICXmUwc=";
    };
  });
}

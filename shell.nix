
let
  pkgs = import <nixpkgs> { };

  # When the Gemfile deps are changed, to generate gemset.nix:
  # nix-shell -p bundler -p bundix --run 'bundler update; bundler lock; bundler package --no-install --path vendor; bundix; rm -rf vendor'
  jekyll_env = pkgs.bundlerEnv rec {
    name = "jekyll_env";
    ruby = pkgs.ruby;
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
  };
in
  pkgs.stdenv.mkDerivation rec {
    name = "jekyll_env";
    buildInputs = [ jekyll_env pkgs.glibcLocales];

    shellHook = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      export LOCALE_ARCHIVE_2_11="${pkgs.glibcLocales}/lib/locale/locale-archive"
      export LOCALE_ARCHIVE_2_27="${pkgs.glibcLocales}/lib/locale/locale-archive"
      export LOCALE_ARCHIVE="/usr/bin/locale"
      echo ""
      echo "jekyll serve --watch"
    '';
  }

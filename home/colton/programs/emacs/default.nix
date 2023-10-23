{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  tree-sitter-modules =
    let
      # TODO:
      # - bash
      # - cmake
      # - dart
      # - elixir
      # - erlang
      # - graphql
      # - haskell
      # - http
      # - julia
      # - kotlin
      # - lua
      # - nickel
      # - nix
      # - nu
      # - ocaml
      # - ocaml-interface
      # - perl
      # - php
      # - prisma
      # - pug
      # - scss
      # - toml
      # - vue
      # - zig
      grammars = lib.genAttrs
        [
          "c"
          "c-sharp"
          "cpp"
          "css"
          "dockerfile"
          "elisp"
          "go"
          "gomod"
          # "hjson"
          "html"
          "java"
          "javascript"
          # "jsdoc"
          "json"
          # "json5"
          "python"
          "ruby"
          "rust"
          "svelte"
          "tsx"
          "typescript"
          "yaml"
        ]
        (g: builtins.getAttr "tree-sitter-${g}" pkgs.tree-sitter-grammars);
    in pkgs.runCommandCC
      "tree-sitter-modules"
      {}
      ''
        mkdir $out

        ${
          lib.concatMapStringsSep
            "\n"
            (g:
              let
                parser-path = (builtins.getAttr g grammars) + "/parser";
                ext = if pkgs.stdenv.isDarwin then "dylib" else "so";
              in "cp \"${parser-path}\" $out/libtree-sitter-${g}.${ext}")
            (builtins.attrNames grammars)
        }
      '';
in

{
  nixpkgs.overlays = [
    inputs.emacs-overlay.overlays.emacs
    inputs.emacs-overlay.overlays.package
  ];

  home.file."bin/emacs" =
    lib.mkIf
      pkgs.stdenv.isDarwin {
        text = "${config.programs.emacs.finalPackage}/Applications/Emacs.app/Contents/MacOS/Emacs";
        executable = true;
      };

  programs.emacs = {
    enable = true;

    package = pkgs.emacs29.overrideAttrs (old: {
      patches =
        (old.patches or [ ])
        ++ [
          # Fix OS window role (needed for window managers like yabai)
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
            hash = "sha256-+z/KfsBm1lvZTZNiMbxzXQGRTjkCFO4QPlEK35upjsE=";
          })
          # Use poll instead of select to get file descriptors
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/poll.patch";
            hash = "sha256-jN9MlD8/ZrnLuP2/HUXXEVVd6A+aRZNYFdZF8ReJGfY=";
          })
          # Enable rounded window with no decoration
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-29/round-undecorated-frame.patch";
            hash = "sha256-uYIxNTyfbprx5mCqMNFVrBcLeo+8e21qmBE3lpcnd+4=";
          })
          # Make Emacs aware of OS-level light/dark mode
          (pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/system-appearance.patch";
            hash = "sha256-oM6fXdXCWVcBnNrzXmF0ZMdp8j0pzkLE66WteeCutv8=";
          })
        ];
    });

    extraPackages = epkgs: with epkgs; [
      company
      direnv
      dockerfile-mode
      evil
      flycheck
      graphql-mode
      helm
      helm-lsp
      helm-xref
      hl-todo
      lsp-mode
      lsp-treemacs
      lsp-ui
      nix-mode
      paredit
      svelte-mode
      timu-caribbean-theme
      treemacs
      treemacs-evil
      which-key
    ];
  };

  home.file.".emacs.d" = {
    recursive = true;
    source = pkgs.symlinkJoin {
      name = ".emacs.d";
      paths = [
        # ./.

        (pkgs.writeTextDir "nix-generated.el"
          (let
            nodepkgs = pkgs.nodePackages_latest;
            typescript-language-server = pkgs.symlinkJoin {
              name = "typescript-language-server";
              paths = [
                nodepkgs.typescript-language-server
              ];
              buildInputs = [
                pkgs.makeWrapper
              ];
              postInstall = ''n
                wrapProgram $out/bin/typescript-language-server
              '';
            };
           in ''
            ;; additional paths
            (setq nixpkgs/direnv "${pkgs.direnv}/bin/direnv")
            (setq nixpkgs/tree-sitter-dir "${tree-sitter-modules}")
            (setq nixpkgs/typescript "${nodepkgs.typescript}")

            ; TODO:
            ; - dockerfile - not on nixpkgs
            ; - graphql
            ; - hjson? - does vscode-json-language-server support it?
            ; - nu - i'm pretty sure this can come from env though
            ; - ocaml
            ; - perl?
            ; - php
            ; - prisma?
            ; - pug
            ; - python
            ; - ruby
            ; - scala
            ; - scheme?
            ; - svelte
            ; - toml
            ; - vue
            ; - zig

            ;; lsp
            (setq nixpkgs/bash-language-server "${nodepkgs.bash-language-server}/bin/bash-language-server")
            (setq nixpkgs/clangd "${pkgs.llvmPackages_10.clang-unwrapped}/bin/clangd")
            (setq nixpkgs/gopls "${pkgs.gopls}/bin/gopls")
            (setq nixpkgs/nixd "${pkgs.nixd}/bin/nixd")
            (setq nixpkgs/rust-analyzer "${pkgs.fenix.latest.withComponents [ "rust-src" "rust-std" "rust-analyzer" ]}/bin/rust-analyzer")
            (setq nixpkgs/svelte-language-server "${nodepkgs.svelte-language-server}/bin/svelteserver")
            (setq nixpkgs/typescript-language-server "${typescript-language-server}/bin/typescript-language-server")
            (setq nixpkgs/vscode-css-language-server "${nodepkgs.vscode-langservers-extracted}/bin/vscode-css-language-server")
            (setq nixpkgs/vscode-eslint-language-server "${nodepkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server")
            (setq nixpkgs/vscode-html-language-server "${nodepkgs.vscode-langservers-extracted}/bin/vscode-html-language-server")
            (setq nixpkgs/vscode-json-language-server "${nodepkgs.vscode-langservers-extracted}/bin/vscode-json-language-server")
            (setq nixpkgs/vscode-markdown-language-server "${nodepkgs.vscode-langservers-extracted}/bin/vscode-markdown-language-server")
          ''))
      ];
    };
  };
}

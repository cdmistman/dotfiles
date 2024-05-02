{
  config,
  inputs,
  lib,
  pkgs,
  system,
  ...
}: let
  inherit (lib) fileset;

  sources = import ./nix/sources.nix {
    inherit pkgs system;
  };

  plugin-sources = [
    "Comment.nvim"
    "LuaSnip"
    "aerial.nvim"
    "bufferline.nvim"
    "cmp-buffer"
    "cmp-nvim-lsp"
    "cmp-nvim-lsp-document-symbol"
    "cmp-nvim-lsp-signature-help"
    "cmp_luasnip"
    "copilot-cmp"
    "copilot.lua"
    "direnv.vim"
    # "flash.nvim"
    # "hydra.nvim"
    "lspkind.nvim"
    "neo-tree.nvim"
    "neoscroll.nvim"
    "noice.nvim"
    "nui.nvim"
    "nvim-cmp"
    "nvim-lspconfig"
    "nvim-notify"
    "nvim-treesitter-context"
    "nvim-web-devicons"
    "peek.nvim"
    "persistence.nvim"
    "plenary.nvim"
    "rustaceanvim"
    "startup.nvim"
    # "substitute.nvim"
    "telescope.nvim"
    "todo-comments.nvim"
    "which-key.nvim"
    # "yanky.nvim"
  ];

  # overrides for out-of-date tree-sitter plugins from nixpkgs
  # since nixpkgs doesn't keep grammars constantly up-to-date but nvim-treesitter does
  # i don't feel like fixing *all* of the grammars and this is close enough for now
  # i'm being careful to only override grammars i need for work or i imagine i *might*
  # use soon.
  # i'm also being careful to ensure that the sources for these grammars matches what's
  # used in nvim-treesitter
  ts-source-overrides = [
    "bash"
    "c-sharp"
    "cuda"
    "dockerfile"
    "erlang"
    "fennel"
    "fish"
    "go"
    "go-mod"
    "heex"
    "http"
    "java"
    "javascript"
    "json5"
    "julia"
    "kotlin"
    "nickel"
    "perl"
    "php"
    "proto"
    "ruby"
    "rust"
    "solidity"
    "svelte"
    "templ"
    "vue"
  ];

  language-to-nixpkgs = {
    "go-mod" = "gomod";
  };

  override-ts-grammar = name: src:
    pkgs.tree-sitter-grammars.${name}.overrideAttrs {
      inherit src;
      version = builtins.substring 0 6 src.rev;
    };

  overridden-ts-grammars =
    lib.pipe ts-source-overrides [
      (builtins.map (l: {
        name = "tree-sitter-${language-to-nixpkgs.${l} or l}";
        value = sources."tree-sitter-${l}";
      }))
      lib.listToAttrs
      (builtins.mapAttrs override-ts-grammar)
    ]
    // {
      # broken
      tree-sitter-ql-dbscheme = null;

      # tree-sitter-sql repo is suuuuuper whack
      # tree-sitter-sql = pkgs.

      # typescript is special
      tree-sitter-tsx = pkgs.tree-sitter-grammars."tree-sitter-tsx".overrideAttrs {
        src = sources.tree-sitter-typescript;
      };

      tree-sitter-typescript = pkgs.tree-sitter-grammars."tree-sitter-typescript".overrideAttrs {
        src = sources.tree-sitter-typescript;
      };
    };

  overridden-tree-sitter-grammars = pkgs.tree-sitter.builtGrammars // overridden-ts-grammars;

  mk-treesitter-parser = parser: let
    name = lib.pipe parser [
      lib.getName
      (lib.removeSuffix "-grammar")
      (lib.removePrefix "tree-sitter-")
    ];

    lang-name = builtins.replaceStrings ["-"] ["_"] name;
  in "cp ${parser}/parser $out/parser/${lang-name}.so";

  tree-sitter-grammars = lib.pipe overridden-tree-sitter-grammars [
    (lib.filterAttrs (_: v: v != null))
    (lib.mapAttrsToList (_: mk-treesitter-parser))
  ];

  nvim-treesitter = pkgs.runCommand "nvim-treesitter-with-parsers" {} ''
    set -exo pipefail

    mkdir -p $out
    cp -R ${sources.nvim-treesitter}/* $out
    chmod +w $out/parser

    ${lib.concatLines tree-sitter-grammars}

    set +ex
  '';

  typescript-language-server = pkgs.nodePackages_latest.typescript-language-server.override {
    nativeBuildInputs = [];

    # fix the symlinkJoin used for fallback tools
    postInstall = ''
      set -exo pipefail
      mkdir -p $out/bin2
      find $out/bin/* \
        | while read file; do
            bin_name="$(basename $file)"
            actual="$(readlink -f "$file")"
            ln -s "$actual" $out/bin2/$bin_name
          done

      unlink $out/bin
      mv $out/bin2 $out/bin

      # bin_dir=$(readlink $out/bin)
      # unlink $out/bin
      # mkdir -p $out/bin
      # # find $bin_dir | xargs -n 1 bash -c "ln -s $bin_dir/"'$0'" $out/bin"
      # find $bin_dir \
      #   | while read file; do
      #       actual=$(readlink -f "$file")
      #       ln -s "$actual" $out/bin
      #     done
    '';
  };

  vim-snippets = lib.sources.sourceFilesBySuffices sources.vim-snippets [".snippets"];
  # vim-snippets = fileset.difference sources.vim-snippets.outPath (sources.vim-snippets + /plugin);
in
  lib.mkIf config.mistman.profile.enable {
    vanillinvim = {
      enable = true;
      tools = [];
      fallback-tools = [
        # TODO: for some reason this breaks the fallback-tools dir
        typescript-language-server

        pkgs.fd

        pkgs.gopls
        pkgs.haskell-language-server
        pkgs.lua-language-server
        pkgs.marksman
        pkgs.nixd
        pkgs.nodejs_20
        pkgs.tailwindcss-language-server
        pkgs.taplo
        pkgs.vscode-langservers-extracted
        pkgs.zls

        pkgs.fenix.stable.toolchain
        pkgs.fenix.rust-analyzer

        pkgs.nodePackages_latest.graphql-language-service-cli
        pkgs.nodePackages_latest.svelte-language-server
      ];

      plugins =
        {
          "tokyonight.nvim" = inputs.tokyonight;
          inherit nvim-treesitter vim-snippets;
        }
        // lib.genAttrs plugin-sources (plugin: sources.${plugin});
    };

    xdg.configFile.nvim.source =
      builtins.filterSource
      (path: type: let
        is-nix-dir = (type == "directory") && (builtins.baseNameOf path == "nix");
        is-default-nix-file = builtins.baseNameOf path == "default.nix";
      in
        !is-nix-dir && !is-default-nix-file)
      ./.;
  }

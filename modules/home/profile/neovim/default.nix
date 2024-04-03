{ config, inputs, lib, pkgs, ... }:

let
  # overrides for out-of-date tree-sitter plugins from nixpkgs
  # since nixpkgs doesn't keep grammars constantly up-to-date but nvim-treesitter does
  # i don't feel like fixing *all* of the grammars and this is close enough for now
  # i'm being careful to only override grammars i need for work or i imagine i *might*
  # use soon.
  # i'm also being careful to ensure that the sources for these grammars matches what's
  # used in nvim-treesitter
  # TODO: niv
  tree-sitter-src-overrides = {
    bash = {
      owner = "tree-sitter";
      repo = "tree-sitter-bash";
      rev = "f3f26f47a126797c011c311cec9d449d855c3eab";
      sha256 = "sha256-6Rfxh8Y6dg2wyQ9jYnbOaXm1SVfQDQ1B1tNqgpz6sY4=";
    };

    c-sharp = {
      owner = "tree-sitter";
      repo = "tree-sitter-c-sharp";
      rev = "92c0a9431400cd8b6b6ee7503f81da3ae83fc830";
      sha256 = "sha256-8ffTbsAOjGZi1Bcf2mOGjTLbzwVI8K1RAYrUbhj/j94=";
    };

    erlang = {
      owner = "WhatsApp";
      repo = "tree-sitter-erlang";
      rev = "20ce5a9234c7248b3f91c5b0b028f1760b954dde";
      sha256 = "sha256-5m4zWP1LPbcab73RIIXD8wG8y68s/rwFypOX7OEWgoQ=";
    };

    gomod = {
      owner = "camdencheek";
      repo = "tree-sitter-go-mod";
      rev = "bbe2fe3be4b87e06a613e685250f473d2267f430";
      sha256 = "sha256-OPtqXe6OMC9c5dgFH8Msj+6DU01LvLKVbCzGLj0PnLI=";
    };

    heex = {
      owner = "phoenixframework";
      repo = "tree-sitter-heex";
      rev = "b5ad6e34eea18a15bbd1466ca707a17f9bff7b93";
      sha256 = "sha256-o0ArFfBJTrEQVXVet+AIDPCB/b9KKvOYrrtMGyLgtM8=";
    };

    http = {
      owner = "rest-nvim";
      repo = "tree-sitter-http";
      rev = "86ad05ac2de3c63c69f65e58f0182a76c1658d1e";
      sha256 = "sha256-7iUNDri5SB9RygMcAGUo78Cbtm11fM8Wvn+KwjKC0M4=";
    };

    java = {
      owner = "tree-sitter";
      repo = "tree-sitter-java";
      rev = "2aae502017d3aed587ba85e3c7e0cbc138f3e07a";
      sha256 = "sha256-UzMpDQtvbu05iu0kL/qkPaxnAOQKLJlzqWYeUurGSqo=";
    };

    javascript = {
      owner = "tree-sitter";
      repo = "tree-sitter-javascript";
      rev = "de1e682289a417354df5b4437a3e4f92e0722a0f";
      sha256 = "sha256-HhqYqU1CwPxXMHp21unRekFDzpGVedlgh/4bsplhe9c=";
    };

    json5 = {
      owner = "Joakker";
      repo = "tree-sitter-json5";
      rev = "c23f7a9b1ee7d45f516496b1e0e4be067264fa0d";
      sha256 = "sha256-16gDgbPUyhSo3PJD9+zz6QLVd6G/W1afjyuCJbDUSIY=";
    };

    kotlin = {
      owner = "fwcd";
      repo = "tree-sitter-kotlin";
      # NOTE: 260afd9a92bac51b3a4546303103c3d40a430639 fails to build
      rev = "9145c623dabe954662e28550c24f270d6df74f83";
      sha256 = "sha256-/UvN8ZWuNtl845ySIM6WrbT0LpHKhw1QtybUj5Yim5g=";
    };

    nickel = {
      owner = "nickel-lang";
      repo = "tree-sitter-nickel";
      rev = "58baf89db8fdae54a84bcf22c80ff10ee3f929ed";
      sha256 = "sha256-WuY6X1mnXdjiy4joIcY8voK2sqICFf0GvudulZ9lwqg=";
    };

    proto = {
      owner = "treywood";
      repo = "tree-sitter-proto";
      rev = "e9f6b43f6844bd2189b50a422d4e2094313f6aa3";
      sha256 = "sha256-Ue6w6HWy+NTJt+AKTFfJIUf3HXHTwkUkDk4UdDMSD+U=";
    };

    ruby = {
      owner = "tree-sitter";
      repo = "tree-sitter-ruby";
      rev = "9d86f3761bb30e8dcc81e754b81d3ce91848477e";
      sha256 = "sha256-Ibfu+5NWCkw7jriy1tiMLplpXNZfZf8WP30lDU1//GM=";
    };

    rust = {
      owner = "tree-sitter";
      repo = "tree-sitter-rust";
      rev = "3a56481f8d13b6874a28752502a58520b9139dc7";
      sha256 = "sha256-6ROXeKuPehtIOtaI1OJuTtyPfQmZyLzCxv3ZS04yAIk=";
    };

    sql = {
      owner = "derekstride";
      repo = "tree-sitter-sql";
      # for some reason the codegen is committed to gh-pages branch
      rev = "cdb7cde9bf70b194ab8beb5069fbbc3c9640284e";
      sha256 = "sha256-yxr+AbKp4pkVpjMQXL3P5VEzSo2Ii6yE7ceEBYiDHJA=";
    };

    svelte = {
      owner = "tree-sitter-grammars";
      repo = "tree-sitter-svelte";
      rev = "6909efa7179cd655f9b48123357d65ce8fc661fd";
      sha256 = "sha256-s/aO6f91vW+XITaDkB3kyNSReLU1V125wgPcTATvgcY=";
    };
  };

  tree-sitter-typescript-repo = pkgs.fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter-typescript";
    rev = "b00b8eb44f0b9f02556da0b1a4e2f71faed7e61b";
    sha256 = "sha256-uGuwE1eTVEkuosMfTeY2akHB+bJ5npWEwUv+23nhY9M=";
  };

  override-ts-source = name: src: pkgs.tree-sitter-grammars."tree-sitter-${name}".overrideAttrs { src = pkgs.fetchFromGitHub src; };
  overridden-ts-sources = builtins.listToAttrs (lib.mapAttrsToList (name: src: { name = "tree-sitter-${name}"; value = override-ts-source name src; }) tree-sitter-src-overrides);
  overridden-tree-sitter-grammars = pkgs.tree-sitter.builtGrammars // overridden-ts-sources // {
    # i don't care about these languages, i'd rather omit for now than keep getting these up to date
    # TODO: niv
    tree-sitter-devicetree = null;
    tree-sitter-fennel = null;
    tree-sitter-gdscript = null;
    tree-sitter-latex = null;
    tree-sitter-just = null;
    tree-sitter-perl = null;
    tree-sitter-php = null;
    tree-sitter-ql-dbscheme = null;
    tree-sitter-vue = null;

    # typescript is special
    tree-sitter-tsx = pkgs.tree-sitter-grammars."tree-sitter-tsx".overrideAttrs {
      src = tree-sitter-typescript-repo;
    };

    tree-sitter-typescript = pkgs.tree-sitter-grammars."tree-sitter-typescript".overrideAttrs {
      src = tree-sitter-typescript-repo;
    };

    # same with vimdoc
    tree-sitter-vimdoc = pkgs.tree-sitter.buildGrammar {
      language = "vimdoc";
      version = "0.0.0";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "tree-sitter-vimdoc";
        rev = "a75a932449675bbd260213a95f4cd8b3193286f0";
        sha256 = "sha256-spj8h1ZDY+6sWi+FCALapBsG+ig9H1u3bjkI2+UP0ds=";
      };
    };
  };

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
    cp -R ${inputs.nvim-treesitter}/* $out
    chmod +w $out/parser

    ${lib.concatLines tree-sitter-grammars}

    set +ex
  '';

  typescript-language-server = pkgs.nodePackages_latest.typescript-language-server.override {
    nativeBuildInputs = [ ];

    # fix the symlinkJoin used for fallback tools
    postInstall = ''
      bin_dir=$(readlink $out/bin)
      unlink $out/bin
      mkdir -p $out/bin
      find $bin_dir | xargs -n 1 bash -c "ln -s $bin_dir/"'$0'" $out/bin"
    '';
  };
in

lib.mkIf config.mistman.profile.enable {
  vanillinvim = {
    enable = true;
    tools = [];
    fallback-tools = [
      # TODO: for some reason this breaks the fallback-tools dir
      # typescript-language-server

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

    plugins = {
      inherit nvim-treesitter;

      inherit
        (inputs)
        cmp-buffer
        cmp_luasnip
        cmp-nvim-lsp
        cmp-nvim-lsp-document-symbol
        cmp-nvim-lsp-signature-help
        copilot-cmp
        lspkind-nvim
        luasnip
        nvim-cmp
        nvim-lspconfig
        nvim-notify
        nvim-treesitter-context
        nvim-web-devicons
        ;

      "aerial.nvim" = inputs.aerial-nvim;
      "bufferline.nvim" = inputs.bufferline-nvim;
      "comment.nvim" = inputs.comment-nvim;
      "copilot.lua" = inputs.copilot-lua;
      "direnv.vim" = inputs.direnv-vim;
      "flash.nvim" = inputs.flash-nvim;
      "hydra.nvim" = inputs.hydra-nvim;
      "neoscroll.nvim" = inputs.neoscroll-nvim;
      "neo-tree.nvim" = inputs.neo-tree-nvim;
      "noice.nvim" = inputs.noice-nvim;
      "nui.nvim" = inputs.nui-nvim;
      "peek.nvim" = inputs.peek-nvim;
      "persistence.nvim" = inputs.persistence-nvim;
      "plenary.nvim" = inputs.plenary-nvim;
      "startup.nvim" = inputs.startup-nvim;
      "substitute.nvim" = inputs.substitute-nvim;
      "telescope.nvim" = inputs.telescope-nvim;
      "todo-comments.nvim" = inputs.todo-comments-nvim;
      "tokyonight.nvim" = inputs.tokyonight;
      "which-key.nvim" = inputs.which-key-nvim;
      "yanky.nvim" = inputs.yanky-nvim;
    };
  };

  xdg.configFile.nvim.source = builtins.filterSource (path: _: ! lib.hasSuffix ".nix" path) ./.;
}

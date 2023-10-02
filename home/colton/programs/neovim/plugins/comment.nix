{ inputs, ... }:

{
  plugin = {
    name = "comment.nvim";
    src = inputs.comment-nvim;
  };

  config = ''
    require("Comment").setup()
  '';
}


===========================
NixOS config of my computer
===========================

Tested with NixOS 18.09

1. **(in comments) e: <var>**
        | Commented expr affects expr "var" in some way and this comment is used to mark relationship between them if they are defined at distant places.
        | This is to make sure that I remember to update downstream expr if I update this expr.
        | For example: environment.variables.EDITOR (= "nvim") depends on neovim being installed but they are defined at different places.

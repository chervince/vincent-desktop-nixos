# VS Code — éditeur principal
{ pkgs, ... }:
{
  home-manager.users.vincent.programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      esbenp.prettier-vscode
      dbaeumer.vscode-eslint
    ];

    profiles.default.userSettings = {
      # Éditeur
      "editor.tabSize" = 2;
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.rulers" = [ 80 120 ];

      # Prettier
      "prettier.semi" = false;
      "prettier.singleQuote" = true;
      "prettier.trailingComma" = "all";
      "prettier.printWidth" = 100;

      # ESLint — fix on save
      "editor.codeActionsOnSave" = {
        "source.fixAll.eslint" = "explicit";
      };
      "eslint.validate" = [ "javascript" "typescript" "javascriptreact" "typescriptreact" ];

      # Emmet dans JSX/TSX
      "emmet.includeLanguages" = {
        "javascriptreact" = "html";
        "typescriptreact" = "html";
      };

      # Terminal
      "terminal.integrated.defaultProfile.linux" = "fish";
    };
  };
}

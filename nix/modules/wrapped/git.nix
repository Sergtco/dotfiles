{
  self,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user = {
          name = "Ivan Nizelnik";
          email = "iva.nizelnik@gmail.com";
        };
        alias = {
          a = "add";
          sw = "switch";
          co = "checkout";
          cc = "commit";
          ca = "commit --amend";
          p = "push";
          f = "fetch";
          st = "status";
        };
        core = {
          editor = "nvim";
          quotePath = false;
        };
        diff = {
          tool = "nvimdiff";
        };
        merge = {
          tool = "nvimdiff";
        };
        "includeIf \"gitdir:~/work/\"" = {
          path = "~/work/.gitconfig";
        };
      };
    };
  };
}

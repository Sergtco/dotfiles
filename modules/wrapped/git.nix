{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.git = inputs.wrapper-modules.wrappers.git.wrap {
        inherit pkgs;
        configFile.content = /*git_config*/''
          [user]
          	email = "iva.nizelnik@gmail.com"
          	name = "Ivan Nizelnik"

          [alias]
          	a = "add"
          	ca = "commit --amend"
          	cc = "commit"
          	co = "checkout"
          	f = "fetch"
          	p = "push"
          	st = "status"
          	sw = "switch"

          [core]
          	editor = "nvim"
          	quotePath = false

          [merge]
          	tool = "nvimdiff"

          [diff]
          	tool = "nvimdiff"

          [includeIf "gitdir:~/work/"]
          	path = "~/work/.gitconfig"
        '';
      };
    };
}

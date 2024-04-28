{lib, config, pkgs, ...}:

let
  jdks_ = with pkgs;
          [ temurin-jre-bin 
            temurin-jre-bin-8 
            temurin-jre-bin-17 
            temurin-jre-bin-19 
            jdk8 jdk17 ];
in
{
  home.packages = with pkgs; [ (prismlauncher.override { jdks = jdks_; }) ];
}

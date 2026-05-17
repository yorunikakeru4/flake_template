{
  description = "Android C++ Gradle dev shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;

        config.android_sdk.accept_license = true;
        config.allowUnfree = true;
      };

      androidComposition = pkgs.androidenv.composeAndroidPackages {
        platformVersions = ["35"];
        buildToolsVersions = ["35.0.0"];

        includeNDK = true;
        ndkVersions = ["27.2.12479018"];

        includeCmake = true;
        cmakeVersions = ["3.22.1"];

        includeEmulator = false;
        includeSystemImages = false;
      };

      androidSdk = androidComposition.androidsdk;
    in {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.temurin-bin-17
          pkgs.gradle
          androidSdk
          pkgs.cmake
          pkgs.ninja
          pkgs.pkg-config
        ];

        shellHook = ''
          export JAVA_HOME="${pkgs.temurin-bin-17}"
          export ANDROID_HOME="${androidSdk}/libexec/android-sdk"
          export ANDROID_SDK_ROOT="$ANDROID_HOME"
          export ANDROID_NDK_HOME="$ANDROID_HOME/ndk/27.2.12479018"
          export ANDROID_NDK_ROOT="$ANDROID_NDK_HOME"

          export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

          echo "JAVA_HOME=$JAVA_HOME"
          echo "ANDROID_HOME=$ANDROID_HOME"
          echo "ANDROID_NDK_HOME=$ANDROID_NDK_HOME"
        '';
      };
    });
}

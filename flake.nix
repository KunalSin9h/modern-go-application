{
  description = "Modern Go Application example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.05";
    flake-utils.url = "github:numtide/flake-utils";
    goflake.url = "github:sagikazarmark/go-flake";
    goflake.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, goflake, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;

          overlays = [ goflake.overlay ];
        };
        # Currently go is 1.20.7, soon going to be 1.21
        buildDeps = with pkgs; [ git go gnumake ];
        devDeps = with pkgs; buildDeps ++ [
          golangci-lint
          gotestsum
          goreleaser
          protobuf
          protoc-gen-go
          protoc-gen-go-grpc
          protoc-gen-kit
          gqlgen
          openapi-generator-cli
          ent
        ];
      in
      { devShell = pkgs.mkShell { buildInputs = devDeps; }; });
}

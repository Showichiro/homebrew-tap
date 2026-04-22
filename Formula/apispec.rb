class Apispec < Formula
  desc "Agent-friendly OpenAPI extraction CLI"
  homepage "https://github.com/Showichiro/moon_openapi_cli"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.4/apispec-v0.1.4-macos-arm64"
      sha256 "ed133f7dade62580eb556a6fdddc57366e974cf9a72d3e2e666b43108108ec94"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.4/apispec-v0.1.4-linux-x64"
      sha256 "1a565fcbb42b4cf968b30787e1af0b2732cc35f51b8735a13b21bdb01c01353b"
    end
  end

  def install
    bin.install Dir["apispec-*"].first => "apispec"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apispec version")
    assert_match "\"name\": \"endpoint.get\"", shell_output("#{bin}/apispec describe --subcommand endpoint.get")
  end
end

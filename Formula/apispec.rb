class Apispec < Formula
  desc "Agent-friendly OpenAPI extraction CLI"
  homepage "https://github.com/Showichiro/moon_openapi_cli"
  version "0.1.4"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.4/apispec-v0.1.4-macos-arm64"
      sha256 "d13f2df0a4739597a73e006d498ef24aa690892cf5a053663816d4138ccaf9b0"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.4/apispec-v0.1.4-linux-x64"
      sha256 "6289899818e78e95965792f9c41aef9b2e213e565e2bcb6c6139ff8f72843eec"
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

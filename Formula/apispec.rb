class Apispec < Formula
  desc "Agent-friendly OpenAPI extraction CLI"
  homepage "https://github.com/Showichiro/moon_openapi_cli"
  version "0.1.3"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.3/apispec-v0.1.3-macos-arm64"
      sha256 "49b28b2ef4cf9b3c827bec175f0634759009886d7e6b932b50cc798a9f7902d6"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.3/apispec-v0.1.3-linux-x64"
      sha256 "081db150ac1d813d30c1d88df9c952f449f465227e28085a7d45c26ad5429e18"
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

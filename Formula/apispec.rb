class Apispec < Formula
  desc "Agent-friendly OpenAPI extraction CLI"
  homepage "https://github.com/Showichiro/moon_openapi_cli"
  version "0.1.2"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.2/apispec-v0.1.2-macos-arm64"
      sha256 "d39ce517f2fb06c34e6e63625fb2843f932eae5cd8c480859b1cbc7fa689a432"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.2/apispec-v0.1.2-linux-x64"
      sha256 "fa8d3f0d1f0b5df6a1d8d447882be9265629e571d1bf32a439f1400ccb770e37"
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

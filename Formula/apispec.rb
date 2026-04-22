class Apispec < Formula
  desc "Agent-friendly OpenAPI extraction CLI"
  homepage "https://github.com/Showichiro/moon_openapi_cli"
  version "0.1.5"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.5/apispec-v0.1.5-macos-arm64"
      sha256 "3291d6d10708402a1358b43d58c9aa1acee9f0298dc219ce246b11d8f1eebf28"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Showichiro/moon_openapi_cli/releases/download/v0.1.5/apispec-v0.1.5-linux-x64"
      sha256 "e9d859ed32ff159baf29913faf4304e326f19bf29ab804d12ee12d7659f405f8"
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

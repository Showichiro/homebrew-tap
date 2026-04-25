class Trpg < Formula
  desc "Agent-friendly TRPG state manager CLI"
  homepage "https://github.com/Showichiro/trpg.mbt"
  version "0.1.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/trpg.mbt/releases/download/v0.1.0/trpg-v0.1.0-macos-arm64"
      sha256 "cbd38ea374a4f849c647f4a35c76a50677eea7dec7e876c7e85830c421ee6df8"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/Showichiro/trpg.mbt/releases/download/v0.1.0/trpg-v0.1.0-linux-x64"
      sha256 "ac9be53a90c45b870f214fb8c6a4fc68f12eefa7611782c77ad074e3716440eb"
    end
  end

  def install
    bin.install Dir["trpg-*"].first => "trpg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/trpg version --human")
    assert_match "\"id\":\"forgotten_library\"", shell_output("#{bin}/trpg scenario bundled")
  end
end

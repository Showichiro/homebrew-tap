class MysqlMcp < Formula
  desc "MCP server for local stdio integrations with MySQL"
  homepage "https://github.com/Showichiro/mysql-mcp"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/mysql-mcp/releases/download/v0.1.0/mysql-mcp_0.1.0_darwin_arm64.tar.gz"
      sha256 "1b0bbcea2c52cc19a3a47a2814628f730d386e38c6cfd99cca35c426dd41f427"
    else
      url "https://github.com/Showichiro/mysql-mcp/releases/download/v0.1.0/mysql-mcp_0.1.0_darwin_amd64.tar.gz"
      sha256 "84d2a10c0054b1da6af12bd7a69f35840e846ec791a616d11ecf99e67a9a36b6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/Showichiro/mysql-mcp/releases/download/v0.1.0/mysql-mcp_0.1.0_linux_arm64.tar.gz"
      sha256 "c42d8a662775150392456aa5f5fa2009a2e4cec12f2e8e1bf077051d665c9db9"
    else
      url "https://github.com/Showichiro/mysql-mcp/releases/download/v0.1.0/mysql-mcp_0.1.0_linux_amd64.tar.gz"
      sha256 "06383b1c7fdf8b7ef5561d448b9b5c157b0c4a2f1402c242112985a1969e7fc6"
    end
  end

  def install
    bin.install "mysql-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql-mcp --version")
  end
end

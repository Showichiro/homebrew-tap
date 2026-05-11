#!/usr/bin/env bash
set -euo pipefail

source_repository="${SOURCE_REPOSITORY:-Showichiro/mysql-mcp}"
version="${VERSION:-}"
formula_path="${FORMULA_PATH:-Formula/mysql-mcp.rb}"

if [ -z "$version" ]; then
  if ! version="$(gh release view --repo "$source_repository" --json tagName --jq '.tagName' 2>/dev/null)"; then
    echo "No release found for ${source_repository}; skipping formula update."
    exit 0
  fi
fi

version_number="${version#v}"
linux_amd64_asset="mysql-mcp_${version_number}_linux_amd64.tar.gz"
linux_arm64_asset="mysql-mcp_${version_number}_linux_arm64.tar.gz"
macos_amd64_asset="mysql-mcp_${version_number}_darwin_amd64.tar.gz"
macos_arm64_asset="mysql-mcp_${version_number}_darwin_arm64.tar.gz"

asset_url() {
  local asset="$1"
  gh release view "$version" --repo "$source_repository" --json assets --jq ".assets[] | select(.name == \"${asset}\") | .url"
}

asset_sha() {
  local asset="$1"
  gh release view "$version" --repo "$source_repository" --json assets --jq ".assets[] | select(.name == \"${asset}\") | .digest" | sed 's/^sha256://'
}

linux_amd64_url="$(asset_url "$linux_amd64_asset")"
linux_amd64_sha="$(asset_sha "$linux_amd64_asset")"
linux_arm64_url="$(asset_url "$linux_arm64_asset")"
linux_arm64_sha="$(asset_sha "$linux_arm64_asset")"
macos_amd64_url="$(asset_url "$macos_amd64_asset")"
macos_amd64_sha="$(asset_sha "$macos_amd64_asset")"
macos_arm64_url="$(asset_url "$macos_arm64_asset")"
macos_arm64_sha="$(asset_sha "$macos_arm64_asset")"

if [ -z "$linux_amd64_url" ] || [ -z "$linux_amd64_sha" ] ||
  [ -z "$linux_arm64_url" ] || [ -z "$linux_arm64_sha" ] ||
  [ -z "$macos_amd64_url" ] || [ -z "$macos_amd64_sha" ] ||
  [ -z "$macos_arm64_url" ] || [ -z "$macos_arm64_sha" ]; then
  echo "missing release asset metadata for ${version}" >&2
  gh release view "$version" --repo "$source_repository" --json assets
  exit 1
fi

mkdir -p "$(dirname "$formula_path")"
cat > "$formula_path" <<EOF
class MysqlMcp < Formula
  desc "MCP server for local stdio integrations with MySQL"
  homepage "https://github.com/Showichiro/mysql-mcp"
  version "${version_number}"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "${macos_arm64_url}"
      sha256 "${macos_arm64_sha}"
    else
      url "${macos_amd64_url}"
      sha256 "${macos_amd64_sha}"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "${linux_arm64_url}"
      sha256 "${linux_arm64_sha}"
    else
      url "${linux_amd64_url}"
      sha256 "${linux_amd64_sha}"
    end
  end

  def install
    bin.install "mysql-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysql-mcp --version")
  end
end
EOF

ruby -c "$formula_path"
echo "Updated ${formula_path} for ${version}"

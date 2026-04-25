#!/usr/bin/env bash
set -euo pipefail

source_repository="${SOURCE_REPOSITORY:-Showichiro/trpg.mbt}"
version="${VERSION:-}"
formula_path="${FORMULA_PATH:-Formula/trpg.rb}"

if [ -z "$version" ]; then
  version="$(gh release view --repo "$source_repository" --json tagName --jq '.tagName')"
fi

version_number="${version#v}"
linux_asset="trpg-${version}-linux-x64"
macos_asset="trpg-${version}-macos-arm64"

linux_url="$(gh release view "$version" --repo "$source_repository" --json assets --jq ".assets[] | select(.name == \"${linux_asset}\") | .url")"
linux_sha="$(gh release view "$version" --repo "$source_repository" --json assets --jq ".assets[] | select(.name == \"${linux_asset}\") | .digest" | sed 's/^sha256://')"
macos_url="$(gh release view "$version" --repo "$source_repository" --json assets --jq ".assets[] | select(.name == \"${macos_asset}\") | .url")"
macos_sha="$(gh release view "$version" --repo "$source_repository" --json assets --jq ".assets[] | select(.name == \"${macos_asset}\") | .digest" | sed 's/^sha256://')"

if [ -z "$linux_url" ] || [ -z "$linux_sha" ] || [ -z "$macos_url" ] || [ -z "$macos_sha" ]; then
  echo "missing release asset metadata for ${version}" >&2
  gh release view "$version" --repo "$source_repository" --json assets
  exit 1
fi

mkdir -p "$(dirname "$formula_path")"
cat > "$formula_path" <<EOF
class Trpg < Formula
  desc "Agent-friendly TRPG state manager CLI"
  homepage "https://github.com/Showichiro/trpg.mbt"
  version "${version_number}"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "${macos_url}"
      sha256 "${macos_sha}"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "${linux_url}"
      sha256 "${linux_sha}"
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
EOF

ruby -c "$formula_path"
echo "Updated ${formula_path} for ${version}"

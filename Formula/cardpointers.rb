class Cardpointers < Formula
  desc "CardPointers CLI — manage your credit card rewards from the terminal"
  homepage "https://cardpointers.com"
  version "0.0.0"
  url "https://github.com/cardpointers/cli/releases/download/v#{version}/cardpointers-#{version}.tar.gz"
  sha256 "INSERT_SHA256_HERE"

  def install
    bin.install "cardpointers"
  end

  test do
    system bin/"cardpointers", "--help"
  end
end

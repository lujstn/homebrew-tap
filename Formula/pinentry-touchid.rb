class PinentryTouchid < Formula
  desc "Custom GPG pinentry program for macOS that allows using Touch ID for fetching the password from
the macOS keychain.
"
  homepage "https://github.com/lujstn/pinentry-touchid"
  version "0.0.4"

  depends_on "pinentry"
  depends_on "pinentry-mac"
  depends_on :macos

  if Hardware::CPU.intel?
    url "https://github.com/lujstn/pinentry-touchid/releases/download/v0.0.4/pinentry-touchid_0.0.4_darwin_amd64.tar.gz"
    sha256 "fad182b0fc27c105cbfe240652cafeff0c36316b786300f02b5ba05fc559050b"

    def install
      bin.install "pinentry-touchid"
    end
  end
  if Hardware::CPU.arm?
    url "https://github.com/lujstn/pinentry-touchid/releases/download/v0.0.4/pinentry-touchid_0.0.4_darwin_arm64.tar.gz"
    sha256 "258805f02e4eaad80b159f60d8260eafccd7fb513db084b93fe27e2aefa1c6aa"

    def install
      bin.install "pinentry-touchid"
    end
  end

  def caveats
    <<~EOS
      ➡️  Ensure that pinentry-mac is the default pinentry program:
            #{bin}/pinentry-touchid -fix

      ✅  Add the following line to your ~/.gnupg/gpg-agent.conf file:
            pinentry-program #{bin}/pinentry-touchid

      🔄  Then reload your gpg-agent:
            gpg-connect-agent reloadagent /bye

      🔑  Run the following command to disable "Save in Keychain" in pinentry-mac:
            defaults write org.gpgtools.common DisableKeychain -bool yes

      ⛔️  If you are upgrading from a previous version, you will be asked to give
          access again to the keychain entry. Click "Always Allow" after the
          Touch ID verification to prevent this dialog from showing.
    EOS
  end
end

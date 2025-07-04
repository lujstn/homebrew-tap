class MlxWebsockets < Formula
  include Language::Python::Virtualenv

  desc "WebSocket streaming server for MLX models on Apple Silicon"
  homepage "https://github.com/lujstn/mlx-websockets"
  url "https://github.com/lujstn/mlx-websockets/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "d48942cb5d003d7a5efaf2b816351167ff3d23b0fb6ec10723f28264f940acad"
  license "MIT"

  depends_on "python@3.11"
  depends_on "rust" => :build

  depends_on :macos
  depends_on arch: :arm64

  def install
    virtualenv_create(libexec, "python3.11")
    system libexec/"bin/pip", "install", "--verbose", "--no-deps", "--no-binary", ":all:", buildpath
    system libexec/"bin/pip", "install", "--verbose", "--no-deps", "--only-binary", ":all:",
           "mlx>=0.15.0", "mlx-lm>=0.15.0", "mlx-vlm>=0.0.6", 
           "websockets>=12.0", "Pillow>=10.0.0", "numpy>=1.24.0",
           "rich>=13.0.0", "psutil>=5.9.0"
    
    bin.install_symlink libexec/"bin/mlx"
  end

  service do
    run [opt_bin/"mlx", "serve"]
    keep_alive true
    log_path var/"log/mlx-websockets.log"
    error_log_path var/"log/mlx-websockets.log"
  end

  test do
    # Test the CLI is accessible
    system bin/"mlx", "--help"

    # Test status command
    system bin/"mlx", "status"

    # Test Python module import
    system libexec/"bin/python", "-c", "import mlx_websockets; print(mlx_websockets.__version__)"
  end

  def caveats
    <<~EOS
      MLX WebSockets has been installed!

      Quick start:
        mlx serve                    # Run the WebSocket server
        mlx background serve         # Run server in background
        mlx background stop          # Stop background server
        mlx status                   # Check server status

      The server runs on port 8765 by default. To use a different port:
        mlx serve --port 8080

      To run as a background service with Homebrew:
        brew services start mlx-websockets
    EOS
  end
end

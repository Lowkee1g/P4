# Use a specific OCaml version with preinstalled dune for faster builds
FROM ocaml/opam:debian-ocaml-4.14

# Switch to root to install system packages
USER root

# Install system dependencies (minimal, fast)
RUN apt-get update && apt-get install -y \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Switch back to opam user
USER opam

# Set the working directory
WORKDIR /workspaces/P4

# Install only what we need
RUN opam install -y dune menhir

# Copy only dependency files first for better caching
COPY --chown=opam:opam dune-project dune ./
COPY --chown=opam:opam test.opam ./
COPY --chown=opam:opam bin/dune ./bin/
COPY --chown=opam:opam lib/dune ./lib/
COPY --chown=opam:opam test/dune ./test/

# Now copy the rest of the source code
COPY --chown=opam:opam . .

# Fix line endings for text files (convert Windows CRLF to Unix LF)
RUN find . -name "*.txt" -type f -exec sed -i 's/\r$//' {} \; 2>/dev/null || true

# Build the project
RUN eval $(opam env) && dune build

# Default command
CMD ["/bin/bash"]
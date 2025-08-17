##  via gem_guard

```sh
bundle
gem_guard sbom > sbom.json
```

NOTE: `gem_guard` is in the `main` `Gemfile` but should be put into its own.
The project does not need this gem to run. The developer wanted a reason to
play with `act`

## via GitHub actions (locally)
```sh
# NOTE: ubuntu-latest a.k.a. ubuntu-24.04 has ruby-3.2.3 pre-installed
# asdf install ruby 3.2.3
# start docker
brew install act
act --action-offline-mode -P macos-latest=-self-hosted -j generate_sbom
# select Medium size image: ~500MB image=catthehacker/ubuntu:act-latest
```

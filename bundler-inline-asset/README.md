## Bundler Inline Asset

There is a simple pattern for pure ruby plugins that might be interesting to people using bundler/inline.

This pattern makes it possible to download pure ruby gem dependenacies at runtime after the Ruby Sensu asset is downloaded unpacked into the cache directory.


This pattern will not work for anything that needs native extensions, but might be sufficient for people looking to move their existing in-house ruby based checks into the world of Sensu assets, without having to turn them into gems.


To build the check-uptime example:
```
cd example
./build.sh
```
This should produce an Sensu asset tarball in the `example/dist` directory that can be used on any system with ruby installed, including with the sensu ruby-runtime.

The `bin/check-uptime.rb` file in the asset is a helper script written in ruby that will ensure bundler gem is installed

The `rubyexec/check-uptime.rb` a slightly modified version of the check from sensu-plugins-uptime-checks, modified to include the inline gem dependenacy information.



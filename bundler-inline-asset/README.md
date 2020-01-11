## Bundler Inline Enabled Ruby Sensu Asset

There is a simple pattern for simple pure Ruby Sensu plugins that might be interesting to people using bundler/inline.
Simple in that its a small one file ruby script that expresses some useful business logic. If the Ruby plugin spans multiple files, you are better off turning it into a real gem and developing a gemspec for it. This pattern is at best appropriate for useful one-off scripts.

This pattern makes it possible to download pure ruby gem dependenacies at runtime after the Ruby Sensu asset is downloaded unpacked into the cache directory.


This pattern will not work for anything that needs native extensions, but might be sufficient for people looking to move their existing in-house ruby based checks into the world of Sensu assets, without having to turn them into gems.

### Build the example
To build the check-uptime example:
```
cd example
./build.sh
```
This should produce an Sensu asset tarball in the `example/dist` directory that can be used on any system with ruby installed, including with the sensu ruby-runtime.

### What's actually going on
The `bin/check-uptime.rb` file in the asset is a helper script written in ruby that will ensure bundler gem is installed, prior to running the actual ruby script located in `rubyexec/`

The `rubyexec/check-uptime.rb` a slightly modified version of the check from sensu-plugins-uptime-checks, modified to include the inline gem dependenacy information.

### Customizing your ruby to build a bundler-inline Sensu asset.
If you want to take this and use it with a different check here's the basic outline

1. Make sure your ruby script is pure ruby, with no gem dependancies that require native C libraries, or shells out to call a shell command as those C libraries and external command dependancies are not encoded in the gem dependancies. To use those sort of mechanisms you'll have to ensure your host environment has those things installed.

2. modify your ruby script to `require bundler/inline` and place a gem block at the top of the script that encodes your gem dependancies.

3. Place your ruby script into `rubyexec/`

4. Rename the executable wrapper in `bin/` to match the name of the actual ruby script in `rubyexec/`



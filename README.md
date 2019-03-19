# Rubohash

A ruby implementation for generating unique images based on the checksum of a given string.

## Installation

I have provided some scripts under `bin/` which should help automate the process. You'll need to either use an initializer to set the `output_path` or edit `lib/rubohash.rb` to change `@robot_output_path  = '/Users/mark/dev/backend-tools/handi/src/rubohash/output/'` to a known location on your system. You can also configure the various options like `default_set`, `default_format`, and `default_bg_set`.

You should be able to use the script `./bin/build.sh` to build, install, and launch an irb terminal with the gem loaded. You can also configure the gem in this script.

## Usage

Once you have an irb console open, simple do:

```rb
  Rubohash.assemble!("my_test_string_here")
```

This will run the algorithm and output the file to `@robot_output_path`. You also need to have ImageMagick installed on your system.

Rubohash can also be mounted inside a Rails application by setting `mounted` to `true`.

## Cleaning Up

You should be able to completely uninstall the gem by running:

```sh
  ./bin/clean.sh
```

## License and Attribution

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Derivation Notice! :

The images are licensed under Creative Commons by attribution

> Robots lovingly provided by robohash.org

This ruby gem is a derivation of the python repository at: https://github.com/e1ven/Robohash

> The Python Code is available under the MIT/Expat license. See the LICENSE.txt file for the full text of this license. Copyright (c) 2011, Colin Davis.

> The RoboHash images are available under the CC-BY-3.0 license.

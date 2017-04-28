[![CircleCI](https://circleci.com/gh/diogot/MyWeight.svg?style=svg)](https://circleci.com/gh/diogot/MyWeight)
[![Dependency Status](https://dependencyci.com/github/diogot/MyWeight/badge)](https://dependencyci.com/github/diogot/MyWeight)
[![codecov](https://codecov.io/gh/diogot/MyWeight/branch/master/graph/badge.svg)](https://codecov.io/gh/diogot/MyWeight)

# MyWeight

MyWeight is a body mass tracker focused on make easy to input new data and check your weight history.


## Getting Started

### Environment prerequisites

#### Ruby

If yon don't have experience with Ruby we recommend [rbenv](https://github.com/rbenv/rbenv):

```sh
brew install rbenv
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

Install the Ruby version used on the project:

```sh
rbenv install `cat .ruby-version`
```

#### Bundler

```sh
gem install bundler
```

#### Optional: Rakefile auto complete

Nobody likes to type 😉

Brew has a [repository](https://github.com/Homebrew/homebrew-completions) only for auto completions:

```sh
brew tap homebrew/completions
brew install bash-completion
brew install rake-completion
```

Don't forget to add to your `.bash_profile`:

```sh
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
```
### Install submodules

```sh
git submodule update --init --recursive
```

### Configuring the environment and dependencies 

```sh
rake setup
```

## Running the tests

```sh
rake unit_tests
```

## Authors

- [Diogo Tridapalli](https://twitter.com/diogot) - main development
- [Marcel Müller](https://twitter.com/grigio) - design

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Bruno Koga](https://github.com/brunokoga)
- [Bruno Mazzo](https://github.com/BrunoMazzo)
- [Igor Castañeda Ferreira](https://github.com/igorcferreira)
- All beta testers

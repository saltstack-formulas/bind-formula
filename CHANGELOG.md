# Changelog

## [0.19.1](https://github.com/saltstack-formulas/bind-formula/compare/v0.19.0...v0.19.1) (2020-01-27)


### Bug Fixes

* **default.sls:** fix subnet declaration ([c814779](https://github.com/saltstack-formulas/bind-formula/commit/c8147797747f4c9b8d07d6310df750521f01ac82)), closes [#144](https://github.com/saltstack-formulas/bind-formula/issues/144)
* **rubocop:** add fixes using `rubocop -a --safe` [skip ci] ([9d2966f](https://github.com/saltstack-formulas/bind-formula/commit/9d2966fd3226828614a9b551202fa076f048ce49))


### Reverts

* **config_spec.rb:** do partial revert of `rubocop -a --safe` ([75810c0](https://github.com/saltstack-formulas/bind-formula/commit/75810c07a71aa4b4ba74ed3c3facb1c5ee0ea6f8))

# [0.19.0](https://github.com/saltstack-formulas/bind-formula/compare/v0.18.4...v0.19.0) (2019-12-21)


### Bug Fixes

* **release.config.js:** use full commit hash in commit link [skip ci] ([adcdbb1](https://github.com/saltstack-formulas/bind-formula/commit/adcdbb12b83c5f2b2eeb1dd7197783107d9f3ae1))


### Continuous Integration

* **gemfile:** restrict `train` gem version until upstream fix [skip ci] ([b7b0d65](https://github.com/saltstack-formulas/bind-formula/commit/b7b0d655e1166a54ad5a182cf33f40df12afb2bc))
* **kitchen:** use `debian-10-master-py3` instead of `develop` [skip ci] ([c91fe2a](https://github.com/saltstack-formulas/bind-formula/commit/c91fe2a96b2c4f3d91d4d1a4996e37358cbe04ea))
* **kitchen:** use `develop` image until `master` is ready (`amazonlinux`) [skip ci] ([5afc27e](https://github.com/saltstack-formulas/bind-formula/commit/5afc27ec26fe676d99113958834398ab70f3a0dd))
* **kitchen+travis:** upgrade matrix after `2019.2.2` release [skip ci] ([6ba1dd5](https://github.com/saltstack-formulas/bind-formula/commit/6ba1dd5262b567aad0b558fdcf81c566e2232c0f))
* **travis:** apply changes from build config validation [skip ci] ([1838174](https://github.com/saltstack-formulas/bind-formula/commit/18381748c74eb54b6b7630e48ea1a9291e419889))
* **travis:** opt-in to `dpl v2` to complete build config validation [skip ci] ([577ad6d](https://github.com/saltstack-formulas/bind-formula/commit/577ad6db1ec2f5236dcf147011c67dfc567f448c))
* **travis:** quote pathspecs used with `git ls-files` [skip ci] ([88f9ff1](https://github.com/saltstack-formulas/bind-formula/commit/88f9ff128f789b6ad9c5292681f1f8f70f725e69))
* **travis:** restrict `semantic-release` version until upstream fix ([5989bb9](https://github.com/saltstack-formulas/bind-formula/commit/5989bb9a0b9112aa1fdc21ed3ec273a6a6976af9))
* **travis:** run `shellcheck` during lint job [skip ci] ([37c65de](https://github.com/saltstack-formulas/bind-formula/commit/37c65de5484c94ae031734663ac03d50c386066f))
* **travis:** update `salt-lint` config for `v0.0.10` [skip ci] ([4c6a882](https://github.com/saltstack-formulas/bind-formula/commit/4c6a88243edb1fef2e5fba0ff16fd90e8514b88e))
* **travis:** use `major.minor` for `semantic-release` version ([66c4d9f](https://github.com/saltstack-formulas/bind-formula/commit/66c4d9fe7d3c56f214f6951efcdd9cb5faa88911)), closes [/github.com/saltstack-formulas/bind-formula/issues/143#issuecomment-568197176](https://github.com//github.com/saltstack-formulas/bind-formula/issues/143/issues/issuecomment-568197176)
* **travis:** use build config validation (beta) [skip ci] ([681c345](https://github.com/saltstack-formulas/bind-formula/commit/681c345e8b78e2d3115adde39cb2202c28dc230d))
* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([7b23dbb](https://github.com/saltstack-formulas/bind-formula/commit/7b23dbbae026b0a8cc779f5ce84de92325454e8b))


### Documentation

* **contributing:** remove to use org-level file instead [skip ci] ([9c11845](https://github.com/saltstack-formulas/bind-formula/commit/9c11845a0997f7bdd6fbcae97e23262de78132a4))
* **readme:** update link to `CONTRIBUTING` [skip ci] ([ab6ea39](https://github.com/saltstack-formulas/bind-formula/commit/ab6ea391d885fc2246db94219b59662c250c0854))


### Features

* **map.jinja:** add Gentoo support ([7415a9b](https://github.com/saltstack-formulas/bind-formula/commit/7415a9b0ce788d978c583499452fdcfc22328c42))


### Performance Improvements

* **travis:** improve `salt-lint` invocation [skip ci] ([b63490c](https://github.com/saltstack-formulas/bind-formula/commit/b63490c23ddb9ccbdcfe02e85444f178441d02ad))

## [0.18.4](https://github.com/saltstack-formulas/bind-formula/compare/v0.18.3...v0.18.4) (2019-10-10)


### Bug Fixes

* **config.sls:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/bind-formula/commit/920615a))
* **named.conf.local.jinja:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/bind-formula/commit/67736a2))
* **named.conf.logging.jinja:** fix `salt-lint` errors ([](https://github.com/saltstack-formulas/bind-formula/commit/f220886))


### Continuous Integration

* merge travis matrix, add `salt-lint` & `rubocop` to `lint` job ([](https://github.com/saltstack-formulas/bind-formula/commit/5883c09))

## [0.18.3](https://github.com/saltstack-formulas/bind-formula/compare/v0.18.2...v0.18.3) (2019-10-07)


### Bug Fixes

* **pillar.example:** fix `yamllint` error ([eb29e00](https://github.com/saltstack-formulas/bind-formula/commit/eb29e00)), closes [/travis-ci.org/myii/bind-formula/builds/594704904#L211-L213](https://github.com//travis-ci.org/myii/bind-formula/builds/594704904/issues/L211-L213)


### Continuous Integration

* use `dist: bionic` & apply `opensuse-leap-15` SCP error workaround ([90abafa](https://github.com/saltstack-formulas/bind-formula/commit/90abafa))
* **kitchen:** change `log_level` to `debug` instead of `info` ([e0be98a](https://github.com/saltstack-formulas/bind-formula/commit/e0be98a))
* **kitchen:** install required packages to bootstrapped `opensuse` [skip ci] ([a5ad4c6](https://github.com/saltstack-formulas/bind-formula/commit/a5ad4c6))
* **kitchen:** use bootstrapped `opensuse` images until `2019.2.2` [skip ci] ([0d02016](https://github.com/saltstack-formulas/bind-formula/commit/0d02016))
* **platform:** add `arch-base-latest` (commented out for now) [skip ci] ([c091c74](https://github.com/saltstack-formulas/bind-formula/commit/c091c74))
* **yamllint:** add rule `empty-values` & use new `yaml-files` setting ([9163726](https://github.com/saltstack-formulas/bind-formula/commit/9163726))

## [0.18.2](https://github.com/saltstack-formulas/bind-formula/compare/v0.18.1...v0.18.2) (2019-09-05)


### Continuous Integration

* **kitchen+travis:** replace EOL pre-salted images ([3a4d4e8](https://github.com/saltstack-formulas/bind-formula/commit/3a4d4e8))


### Tests

* **inspec:** improve to work on `amazon` as well ([59684c6](https://github.com/saltstack-formulas/bind-formula/commit/59684c6))

## [0.18.1](https://github.com/saltstack-formulas/bind-formula/compare/v0.18.0...v0.18.1) (2019-08-18)


### Bug Fixes

* **tests:** move to controls sub-directory ([74bbc5b](https://github.com/saltstack-formulas/bind-formula/commit/74bbc5b))


### Continuous Integration

* **travis:** re-enable `fedora` ([4a6ac4e](https://github.com/saltstack-formulas/bind-formula/commit/4a6ac4e))

# [0.18.0](https://github.com/saltstack-formulas/bind-formula/compare/v0.17.0...v0.18.0) (2019-08-17)


### Continuous Integration

* **kitchen+travis:** modify matrix to include `develop` platform ([641e641](https://github.com/saltstack-formulas/bind-formula/commit/641e641)), closes [#129](https://github.com/saltstack-formulas/bind-formula/issues/129)


### Features

* **yamllint:** include for this repo and apply rules throughout ([a81c9ff](https://github.com/saltstack-formulas/bind-formula/commit/a81c9ff))

# [0.17.0](https://github.com/saltstack-formulas/bind-formula/compare/v0.16.0...v0.17.0) (2019-05-24)


### Continuous Integration

* reduce platforms tested ([374b777](https://github.com/saltstack-formulas/bind-formula/commit/374b777))


### Features

* implement an automated changelog ([61bb936](https://github.com/saltstack-formulas/bind-formula/commit/61bb936))


### Tests

* **inspec:** fix suse/opensuse tests ([64872f6](https://github.com/saltstack-formulas/bind-formula/commit/64872f6))

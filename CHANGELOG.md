# Changelog

# [0.20.0](https://github.com/saltstack-formulas/bind-formula/compare/v0.19.2...v0.20.0) (2021-09-13)


### Continuous Integration

* **3003.1:** update inc. AlmaLinux, Rocky & `rst-lint` [skip ci] ([8082c7e](https://github.com/saltstack-formulas/bind-formula/commit/8082c7e6d48ccf4e5e66ee821fad4f57183d7524))
* **commitlint:** ensure `upstream/master` uses main repo URL [skip ci] ([19d42a9](https://github.com/saltstack-formulas/bind-formula/commit/19d42a9776198e802215bbb38716b2295f6d18b3))
* **gemfile.lock:** add to repo with updated `Gemfile` [skip ci] ([c15db2b](https://github.com/saltstack-formulas/bind-formula/commit/c15db2bd0cbb5b303b98a9ed7102b2b26aff9057))
* **gemfile+lock:** use `ssf` customised `inspec` repo [skip ci] ([d46d646](https://github.com/saltstack-formulas/bind-formula/commit/d46d646fdc9a944a4dcecff245088b5b268da0ec))
* **gitlab-ci:** use GitLab CI as Travis CI replacement ([c642234](https://github.com/saltstack-formulas/bind-formula/commit/c64223415906f733d7db1405468a43050d9b15ad))
* **kitchen:** move `provisioner` block & update `run_command` [skip ci] ([0128f48](https://github.com/saltstack-formulas/bind-formula/commit/0128f48b0b468541db8359c98bcbcf9f52481ea2))
* **kitchen+ci:** update with latest `3003.2` pre-salted images [skip ci] ([8c1a04c](https://github.com/saltstack-formulas/bind-formula/commit/8c1a04cfbf2ee683981cacf03e89d5e0b6926d4a))
* add Debian 11 Bullseye & update `yamllint` configuration [skip ci] ([aa69b55](https://github.com/saltstack-formulas/bind-formula/commit/aa69b550eb6a6ec16e53bf7c28312cec1b6f28f8))
* **gemfile+lock:** use `ssf` customised `kitchen-docker` repo [skip ci] ([0cdaad3](https://github.com/saltstack-formulas/bind-formula/commit/0cdaad33b9b8ca1fea0ab8210182d6ccbe5a6c75))
* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([1b4cfcd](https://github.com/saltstack-formulas/bind-formula/commit/1b4cfcd1e6d19312f3e0802bc5c567ad6ea15013))
* **kitchen+ci:** use latest pre-salted images (after CVE) [skip ci] ([9de203a](https://github.com/saltstack-formulas/bind-formula/commit/9de203a5e947b282c2c99e5c66161f553b8379f6))
* **kitchen+gitlab:** adjust matrix to add `3003` [skip ci] ([9833cb6](https://github.com/saltstack-formulas/bind-formula/commit/9833cb616c026abce0b0eb11ea5620a060b0af32))
* **kitchen+gitlab:** remove Ubuntu 16.04 & Fedora 32 (EOL) [skip ci] ([a3556b4](https://github.com/saltstack-formulas/bind-formula/commit/a3556b4cc4931a0062c89019bb22a11885328c57))
* add `arch-master` to matrix and update `.travis.yml` [skip ci] ([73ee1c9](https://github.com/saltstack-formulas/bind-formula/commit/73ee1c9b9f7987c41d7f427e0a7decd8c42eaab8))
* **gitlab-ci:** add `rubocop` linter (with `allow_failure`) [skip ci] ([db90981](https://github.com/saltstack-formulas/bind-formula/commit/db90981eed9fcc4511268c2cf7dd3e0be4241216))
* **kitchen+gitlab-ci:** use latest pre-salted images [skip ci] ([df1f583](https://github.com/saltstack-formulas/bind-formula/commit/df1f58377c0497b7a5ef973df4596e4deb201a4a))
* **kitchen+travis:** remove `master-py2-arch-base-latest` [skip ci] ([f1b306d](https://github.com/saltstack-formulas/bind-formula/commit/f1b306dbef9e4f6a83a789851d1230639226ec1c))
* **pre-commit:** add to formula [skip ci] ([1b24859](https://github.com/saltstack-formulas/bind-formula/commit/1b248596e594fcfd6e0efbe08f73971fe141d879))
* **pre-commit:** enable/disable `rstcheck` as relevant [skip ci] ([ffc60d2](https://github.com/saltstack-formulas/bind-formula/commit/ffc60d2e1f5ff7b34fecb443a1f8203cdca4b988))
* **pre-commit:** finalise `rstcheck` configuration [skip ci] ([800a5e1](https://github.com/saltstack-formulas/bind-formula/commit/800a5e10db8576b5d058a63391e51c2bf1ae11c8))
* **pre-commit:** update hook for `rubocop` [skip ci] ([182622d](https://github.com/saltstack-formulas/bind-formula/commit/182622d9e811f2bcdb1019da38c8863a66307c4a))
* **travis:** add notifications => zulip [skip ci] ([51f0a8e](https://github.com/saltstack-formulas/bind-formula/commit/51f0a8e06e144054ecd5b76f8512dd080768e7d7))
* **workflows/commitlint:** add to repo [skip ci] ([b202791](https://github.com/saltstack-formulas/bind-formula/commit/b202791a7cc78370a0a610193abf39cd544e67cd))


### Documentation

* **readme:** fix headings [skip ci] ([292b023](https://github.com/saltstack-formulas/bind-formula/commit/292b0232c1c544c4fc7b3a2bad07bdc026b0a1f0))


### Features

* **config.sls:** allow to not manage zone file ([2d06954](https://github.com/saltstack-formulas/bind-formula/commit/2d069544f6e5d8cbf5a6bee23d0e9618e09cd025))


### Tests

* standardise use of `share` suite & `_mapdata` state [skip ci] ([3cb26c0](https://github.com/saltstack-formulas/bind-formula/commit/3cb26c0a71cb99b88ef1ce00747c4fe57d4a322f))

## [0.19.2](https://github.com/saltstack-formulas/bind-formula/compare/v0.19.1...v0.19.2) (2020-03-23)


### Bug Fixes

* **debian:** align Debian log directory with apparmor profile ([b5efc0b](https://github.com/saltstack-formulas/bind-formula/commit/b5efc0b9bdc24bad145c2e511a09dd976ef0a3ed))


### Continuous Integration

* **kitchen:** avoid using bootstrap for `master` instances [skip ci] ([292e495](https://github.com/saltstack-formulas/bind-formula/commit/292e495d0149599b53b588f9914f18366deac20f))

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

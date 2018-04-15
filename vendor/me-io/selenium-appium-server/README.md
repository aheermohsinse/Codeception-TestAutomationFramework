<h1 align="center">
  Selenium Appium Server
</h1>
<p align="center" style="font-size: 1.2rem;">Simple package that will configure your enviorment for using selenium or appium servers. The scripts files automatically download the required packages to run selenium or appium server.</p>

<hr/>

[![Build Status][build-badge]][build]
[![downloads][downloads-badge]][downloads]
[![MIT License][license-badge]][license]

[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors)
[![PRs Welcome][prs-badge]][prs] 
[![Code of Conduct][coc-badge]][coc]
[![Watch on GitHub][github-watch-badge]][github-watch]
[![Star on GitHub][github-star-badge]][github-star]
[![Tweet][twitter-badge]][twitter]

## Requirement

1. Bash >= 4.0

## Install

Just add the following to your composer.json file:

```json
{
    "require": {
        "me-io/selenium-appium-server": "~1"
}
```

and then run `composer install`. This will install `selenium-appium-server` scripts inside your project. Or run the following command inside your terminal:

```bash
composer require me-io/selenium-appium-server
```

## Running script files

The `me-io/selenium-appium-server` gives the following scripts files that you can use to run
selenium or appium servers: 

* `./bin/appium.sh`
* `./bin/selenium.sh`

### Selenium script

```bash
$ ./vendor/bin/selenium.sh

Usage:
    selenium <command>

Commands:
    configure            - Install selenium and its dependencies.
    start                - Start the selenium server.
    start-background     - Start selenium server in background.
    stop                 - Stop the selenium server.
    restart|force-reload - Restart the selenium server.

Examples:
    selenium start
```

### Appium script

```bash
$ ./vendor/bin/appium.sh

Usage:
    appium <command>

Commands:
    configure            - Install appium and its dependencies.
    start                - Start the appium server.
    start-background     - Start appium server in background.
    stop                 - Stop the appium server.
    restart|force-reload - Restart the appium server.

Examples:
    appium start
```

## Contributors

A huge thanks to all of our contributors::

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
| [<img src="https://avatars0.githubusercontent.com/u/45731?v=3" width="100px;"/><br /><sub><b>Mohamed Meabed</b></sub>](https://github.com/Meabed)<br />[💻](https://github.com//selenium-appium-server/commits?author=Meabed "Code") [📢](#talk-Meabed "Talks") | [<img src="https://avatars2.githubusercontent.com/u/16267321?v=3" width="100px;"/><br /><sub><b>Zeeshan Ahmad</b></sub>](https://github.com/zeeshanu)<br />[💻](https://github.com//selenium-appium-server/commits?author=zeeshanu "Code") [🐛](https://github.com//selenium-appium-server/issues?q=author%3Azeeshanu "Bug reports") [⚠️](https://github.com//selenium-appium-server/commits?author=zeeshanu "Tests") [📖](https://github.com//selenium-appium-server/commits?author=zeeshanu "Documentation") |
| :---: | :---: |
<!-- ALL-CONTRIBUTORS-LIST:END -->

## License

The code is available under the [MIT license](LICENSE.md).

[build-badge]: https://img.shields.io/travis/me-io/selenium-appium-server.svg?style=flat-square
[build]: https://travis-ci.org/me-io/selenium-appium-server
[downloads-badge]: https://img.shields.io/packagist/dm/me-io/selenium-appium-server.svg?style=flat-square
[downloads]: https://packagist.org/packages/me-io/selenium-appium-server/stats
[license-badge]: https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square
[license]: https://github.com/me-io/selenium-appium-server/blob/master/LICENSE.md
[prs-badge]: https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square
[prs]: http://makeapullrequest.com
[coc-badge]: https://img.shields.io/badge/code%20of-conduct-ff69b4.svg?style=flat-square
[coc]: https://github.com/me-io/selenium-appium-server/blob/master/CODE_OF_CONDUCT.md
[github-watch-badge]: https://img.shields.io/github/watchers/me-io/selenium-appium-server.svg?style=social
[github-watch]: https://github.com/me-io/selenium-appium-server/watchers
[github-star-badge]: https://img.shields.io/github/stars/me-io/selenium-appium-server.svg?style=social
[github-star]: https://github.com/me-io/selenium-appium-server/stargazers
[twitter]: https://twitter.com/intent/tweet?text=Check%20out%20selenium-appium-server!%20https://github.com/me-io/selenium-appium-server%20%F0%9F%91%8D
[twitter-badge]: https://img.shields.io/twitter/url/https/github.com/me-io/selenium-appium-server.svg?style=social
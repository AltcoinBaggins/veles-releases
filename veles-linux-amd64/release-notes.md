Veles Core version 0.17.1 is now available.

  <https://github.com/velescore/veles/releases/tag/v0.17.1/>

This is a new minor version release, with various bugfixes
as well as updated packaging and UI.

Please report bugs using the issue tracker at GitHub:

  <https://github.com/velescore/veles/issues>

How to Upgrade
==============

If you are running an older version, shut it down. Wait until it has completely
shut down (which might take a few minutes for older versions), then run the
installer (on Windows) or just copy over `/Applications/Veles-Qt` (on Mac)
or `Velesd`/`Veles-qt` (on Linux).

Downgrading warning
-------------------

Wallets created in 0.16 and later are not compatible with versions prior to 0.16
and will not work if you try to use newly created wallets in older versions. Existing
wallets that were created with older versions are not affected by this. This might
be useful only for exporting of old private keys, as wallets of version v0.17.0.20
and older are not compatible with the current chain anymore.

Compatibility
==============

Veles Core is extensively tested on multiple operating systems using
the Linux kernel, macOS 10.8+, and Windows Vista and later. Windows XP is not supported.

Veles Core should also work on most other Unix-like systems but is not
frequently tested on them.

0.17.1 change log
------------------

### Masternodes
- b7b6848fe - Port masternode.conf docs from Dash Core
- ad220b45f - MN: Workaround for bug #21 with start-alias
- 13ce5c40d - MN: Fix issue #24 with collateral output lock
- 133d03cbf - MN: Corrected port number in masternode.conf template
- 56571e43f - MN: Fix issue #22 with masternode.conf not loading

### GUI
- 9029d1bce - Qt: Add alternate splash, improve layout and rendering
- ac9b833a4 - Improve Qt wallet splash screen rendering
- b1c84f9e7 - Qt: Removed references to unused image resources
- 6f07dfa27 - Move source files of image resources to separate folder
- 1cf8422af - Update all icons sets and image resources.
- 020f47fb9 - Qt: Fixed missing image resources

### Build system
- 050c48850 - Fix package tarname in configure.ac (in AC_INIT)
- e59947a34 - Updated Windows NSIS installer script

### Tests and QA
- 04dbca9c5 - Travis: Updated config to match change of PACKAGE_TARNAME
- 46a0c4556 - Travis: Fixes for correct Travis-CI integration
- c380debb5 - Tests: Added linter support for alternate include guards
- 2db0cc9cc - Merge: [Tests]: Ported Travis-CI compatibility fixes from fxtc/0.17
- 89c994bb7 - Tests: Removed deprecated block testing utility
- d0ec34743 - Tests: Add an exception into lint-locale-dependence

### Documentation
- 59c920a92 - Update UNIX manual pages
- 48e06a062 - Removed irrelevant release notes
- 8b24b2276 - fix docs (#1404)
- 18e179232 - Updated copyright messages
- 60ee2d178 - Docs: Update contributig guidelines, add Discord link
- bf9b0e724 - Docs: Update GitHub issue template
- e27209642 - Merge#20: [Docs]: Correct branding, remove trailing whitespaces
- d45d27947 - Docs: Corrected branding and coin name in all the docs Also removed traling whitespaces for Travis not to fail.
- 32434a72c - Docs: Rewritten README file, added badges. Changed instructions on howto pull latest stable code from GitHub, ported Development Proccess section from Bitcoin Core, updated description of the repository, and added brand new badges.

### Miscellaneous
- c05fb8804 - Support for version codename constant
- dabecfc95 - Script: Removed masternode.sh, been moved to separate repo The masternode installer script is now maintained in separate repository velescore/masternode-installer


Credits
=======

Thanks to everyone who directly contributed to this release:

- AltcoinBaggins
- Veles Core
- UdjinM6


And to those that reported relevant bugs / issues:

- xCryptoCash
- SpektralFeniks
- thomas
- Johnny
- mdfkbtc
- Virtuado

As well as everyone that helped to improve Veles Core with their suggestions at [Veles Discord](https://discord.gg/rXgH6Qn).

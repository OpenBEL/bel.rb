# How to contribute to bel.rb

## Did you find a bug?

First check the reported issues by searching on GitHub under [Issues](https://github.com/OpenBEL/bel.rb/issues). You may be experiencing a known issue which you can contribute to diagnosing.

If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/OpenBEL/bel.rb/issues/new). Be sure to include a title and clear description, as much relevant information as possible, and a code sample or an executable test case demonstrating the expected behavior that is not occurring.

## Did you write a patch that fixes a bug?

Open a [new GitHub pull request](https://github.com/OpenBEL/bel.rb/pull/new) with the patch.

Ensure the pull request description clearly describes the problem and solution. Include the relevant issue number if applicable.

**Note:** If this is your first contribution then follow [Sign a CLA](#sign_a_cla) below.

## Did you implement a new feature?

Open a new GitHub pull request with the feature.

Ensure the pull request description clearly states:

- what the feature does
- why this feature is useful
- a summarization of the changes contained within

Include the relevant issue number if applicable.

You can always discuss your proposed feature with the community first:

- [Gitter chat](https://gitter.im/OpenBEL/chat)
- [OpenBEL discussion group](https://groups.google.com/forum/#!forum/openbel-discuss)

## Git branch recommendations

*your topic branch*

Clone bel.rb and create a branch specifically for your patch or feature work. Then you are ready to submit a pull request to the *next* branch.

*next*

The `next` branch aggregates new/unstable code intended for a future release. When code stabilizes (e.g. feature-complete, tests included and pass) it is merged to master.

*master*

The `master` branch represents stable code where releases are tagged from. When a release of `master` is ready a semantic version tag should be created and the subsequent gem pushed to rubygems.

<a name="sign_a_cla"></a>
## Sign a CLA

We'd love for you to contribute and to make this project even better than it is today! If this interests you, please begin by reading [our contributing guidelines](https://github.com/openbel/cla/blob/master/CONTRIBUTING.adoc). The contributing document will provide you with all the information you need to get started.

Once you have read that, you will need to also sign our CLA before we can accept a Pull Request from you. More information on the process is included in the [contributor's guide](https://github.com/openbel/cla/blob/master/CONTRIBUTING.adoc).

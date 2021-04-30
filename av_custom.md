# @averissimo fork

This is a great docker image maintained by [@MatthewVance](https://github.com/MatthewVance/unbound-docker).

I needed to make some changes to have it working in raspberry pi out of the box and only require the latest version.

Changes in the fork:

* Actually none, just adds a script that makes all my changes and builds docker image
* Adds a github workflow that builds image on changes and periodically

Changes by executing script `$bash av_custom.bash`:

* Removed openssl compile flag that gives an error on *arm*
* Using latest available download of unbound, instead of fixed versions.
* Builds automatically every week and publishes to docker hub

*Small note to future self:* root.hints is downloaded by `wget -O root.hints https://www.internic.net/domain/named.root`

Original documentation for image below

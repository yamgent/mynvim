# Maintenance

## Upgrading plugins

* Run "upgrade all" in Lazy first to get the list of plugins with breaking
  changes.
* Note down all the plugins with breaking changes.
* Reset the "upgrade all".
* Manually upgrade each broken plugin one step by one step. If possible, in the
  commit message, note down each commit that is marked breaking change, and
  mention whether there's any changes required.
* After all plugins with breaking changes are done, try to "upgrade all" again.
  If there are still broken stuff, reset "upgrade all" and manually upgrade
  those again one by one.
* Once all broken plugins are fixed, run "upgrade all" and this time, keep the
  change
* Ensure that `:checkhealth` did not have any `ERROR`, and ensure that all
  `WARNING` are acceptable.
* Test the upgrades on other OS.

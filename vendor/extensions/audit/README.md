# Audit Extension

An extensible auditing framework for Radiant.

## Overview

The Audit Extension provides Radiant with an extensible framework for auditing
and logging admin interactions as well as a UI for reviewing and searching the
audited events. With this extension, site admins now have the ability to track
changes to their site over time. It can be added to any existing Radiant 0.9
site with minimal effort.

Out of the box, you'll find support for: create/update/destroy of the core
Radiant models (User, Page, Snippet, and Layout), as well as User
logins/logouts (both successful and failed). Extension developers can add in
auditing capability to new models and actions with little effort.


## Installation and Setup

The Audit Extension requires Radiant 0.9 or later and all of its prerequisites.

See the INSTALL file for more details.


## Usage

After installing the Audit Extension, all core Radiant events will be logged
without any additional configuration. Just log in and use Radiant as normal to
start filling up the audit log with events.

To review the audit log, go to the [new] Tools main tab in the Radiant admin
interface and select Audit Log. You'll be able to browse the audit events by
date, and do simple filtering and searching of audit events.

Note: The Audit Log UI is available and intended to be used by all classes of
Radiant admin users as it does not expose any sensitive information aside from
the fact that objects were created/updated/deleted. If your needs are
different, however, the extension can be easily modified to restrict UI access
as desired.


## Customizing and Extending

Attention Radiant extension authors: If you've written custom extensions
(public or private) and would like to provide your users with auditing
capability, it's fairly straight-forward because the Audit Extension was
designed with extensibility as one of its core principals.

See our GitHub page for more info on the internals and how to extend/customize
the extension for your needs.

http://github.com/digitalpulp/radiant-audit-extension/


## Known Issues

* The audit log is never truncated. This is by design.


## Roadmap

### Real Soon Now

* bring back the UI for custom reports (need UI help due to new conventions
  introduced with Blade)

### Under Consideration

* YOUR FEATURE HERE


## Contributors

This extension was originally developed by Digital Pulp for a client and was
extracted for release to the Radiant community.

See the CONTRIBUTORS file for full credits list.


## Support

GitHub is the place to find all documentation, file tickets, and get the
latest releases of the Audit Extension.

http://github.com/digitalpulp/radiant-audit-extension/


## License

The Audit Extension is released under the MIT license and is copyright 
(c) 2009 Digital Pulp. A copy of the MIT license can be found in the LICENSE 
file.

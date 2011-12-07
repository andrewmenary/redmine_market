Market for Redmine
==================

Market for Redmine is a plugin for [Redmine](http://www.redmine.org/) that can 
be used to define a set of lists in a **Top List** format.  The index page shows 
up to five items from each **featured** list (as well as a link to the full 
list) and additionally provides links to the full list of the non-featured lists 
as well.

Criteria for each list can be defined from any field on the **project**, or 
**version**, as well as any **custom value** associated with either the project 
or the version.

We are using the plugin internally to show lists of items on the project 
backlog, but the plugin could be used to create an app store interface.

###WARNING:###
    Any market lists created are visible to all authenticated users.  Therefore
	it is possible to expose information that would otherwise be protected by
	system security settings.
	
	Additionally, the current version is an early release, and not generally
	considered ready for widespread use in production environments.

	
License
-------

This Market for Redmine plugin is open source software and licensed under
the terms of the [MIT License](http://www.opensource.org/licenses/mit-license.php)

See the LICENSE file.

	
Requirements
------------

NOTE: This plugin was built specifically for the 1.1.2 version of Redmine, which 
is **not** the latest version.  It *may* work with more recent releases of Redmine.

- Redmine 1.1.2
- Ruby 1.8.7
- Rails 2.3.5


Installation
------------

	$ cd {REDMINE_ROOT}/vendor/plugins/
	$ git clone git://github.com/andrewmenary/redmine_market.git
	# may need $ export RAILS_ENV="production"
	$ rake db:migrate_plugins

Then restart your web server.


Update/Upgrade
--------------

	$ cd {REDMINE_ROOT}/vendor/plugins/redmine_market
	$ git pull
	# may need $ export RAILS_ENV="production"
	$ rake db:migrate_plugins

Then restart your web server.


Release Log
-----------

0.0.1	2011-12-05	AWM
   * Ability to define lists and list criteria in database.
   * No UI for administrating the lists.
   * UI for list format hard-coded into _top_list partial view.


-=EOF=-
====
bind
====

Formulas to set up and configure the bind DNS server.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``bind``
--------

Install the bind package and start the bind service.

``bind.config``
---------------

Manage the bind configuration file.

Example Pillar
==============

.. code:: yaml

    bind:
      configured_zones:
        example.com:
          type: master
          notify: False
      available_zones:
        example.com:
          file: example.com.txt
          soa:
            ns: ns1.example.com                       # Required
            contact: hostmaster.example.com           # Required
            serial: 2017041001                        # Required
          records:                                    # Records for the zone, grouped by type
            A:
              mx1:                                    # A RR with multiple values can
                - 1.2.3.228                           # be written as an array
                - 1.2.3.229
              cat: 2.3.4.188
              rat: 1.2.3.231
              live: 1.2.3.236
      configured_views:
        myview1:
          match_clients:
            - client1
            - client2
        configured_zones:
          my.zone:
            type: master
            notify: False

See *pillar.example* for a more complete example.

Management of zone files
========================

`named.conf.local`
------------------

<zone> entries in `named.conf.local` will point to the file declared in

* `bind:configured_zones:<zone>:file` (this takes precedence)
* `bind:available_zones:<zone>:file`

zone files
----------

The `config.sls` state will  iterate on `bind:available_zones` and manage
<zone> files for each <zone> that has bind:available_zones:<zone>:file`
declared.

* If `bind:available_zones:<zone>:records` exist, a zone file will be created
  using those records (see pillar.example for more details)
* If `bind:available_zones:<zone>:records` is **NOT** declared,
  `bind:available_zones:<zone>:file` should point to an existing zone file
  that will be **sourced** by the formula.

External zone files
-------------------

To use an external tool to manage the <zone> file, simply declare the location
of the zone file in  `bind:configured_zones:<zone>:file` and **don't** add any
entry for the <zone> in  `bind:available_zones`

DNSSEC
======

The `bind` formula currently support two ways to enable DNSSEC:

* Using the `zonesigner` binary provided by `dnssec-tools` (legacy) ;
* Using internal features of `bind`.

Here is sample pillar entries to use the latter.

On the master server :

.. code:: yaml

  bind:
    lookup:
      key_directory: '/etc/bind/keys'
    config:
      options:
        dnssec-enable: 'yes'
        dnssec-validation: 'yes'
    configured_acls:
      slave_server:
        - 192.168.1.2
    configured_zones:
      domain.tld:
        file: "db.domain.tld"
        type: master
        notify: True
        allow-transfer:
          - localnets
          - localhost
          - slave_server
        allow-update: 'none'
        auto-dnssec: 'maintain'

On the slave server :

.. code:: yaml

  bind:
    config:
      options:
        dnssec-enable: 'yes'
        dnssec-validation: 'yes'
    configured_zones:
      domain.tld:
        file: "db.domain.tld.signed"
        type: slave
        masters:
          - master_server
    configured_masters:
      master_server:
        - 192.168.1.1

Notes
=====

* When using views all zones must be configured in views!

Salt Compatibility
==================

Tested with:

* 2017.7.x
* 2018.3.x

OS Compatibility
================

Tested with:

* Archlinux
* CentOS 7
* Debian-8
* Debian-9
* Fedora-27
* Ubuntu-16.04
* Ubuntu-18.04

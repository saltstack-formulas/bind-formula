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
        sub.domain.com:
          type: master
          notify: False
      configured_views:
        myview1:
          match_clients:
            - client1
            - client2
        configured_zones:
          my.zone:
            type: master
            notify: False

See *bind/pillar.example*.

Notes
=====

* When using views all zones must be configured in views!

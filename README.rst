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

Example Pillar:

.. code:: yaml

    bind:
      config:
        name: /etc/named.conf
        source: salt://bind/files/named.conf
        user: root
        group: named
        mode: 640

# -*- coding: utf-8 -*-
# vim: ft=yaml
---
bind:
  configured_acls:
    client1:
      - 127.0.0.0/8
      - 10.20.0.0/16
    client2:
      - 10.0.0.0/8
      - 10.30.0.0/16
  configured_zones:
    example.com:
      type: master
      notify: false
      update_policy:
        - "grant core_dhcp name dns_entry_allowed_to_update. ANY"
    example.net:
      type: master
      notify: false
    example.org:
      type: slave
      notify: false
      masters:
        - 192.0.2.1
        - 192.0.2.2
    113.0.203.in-addr.arpa:
      type: master
      notify: false
    100.51.198.in-addr.arpa:
      type: master
      notify: false
  available_zones:
    example.net:
      file: example.net
      soa:
        class: IN
        ns: ns1.example.net
        contact: hostmaster.example.net
        serial: auto
        retry: 300
        ttl: 300
      records:
        NS:
          '@':
            - ns1
        A:
          ns1: 198.51.100.1
          foo: 198.51.100.2
          bar: 198.51.100.3
          baz: 198.51.100.4
          mx1:
            - 198.51.100.5
            - 198.51.100.6
            - 198.51.100.7
        CNAME:
          mail: mx1.example.net.
          smtp: mx1.example.net.
    example.com:
      file: example.com
      soa:
        class: IN
        ns: ns1.example.com
        contact: hostmaster.example.com
        serial: 2018073100
        retry: 600
        ttl: 600
      records:
        NS:
          '@':
            - ns1
        A:
          ns1: 203.0.113.1
          foo: 203.0.113.2
          bar: 203.0.113.3
        CNAME:
          ftp: foo.example.com.
          www: bar.example.com.
          mail: mx1.example.com.
          smtp: mx1.example.com.
        TXT:
          '@':
            - '"some_value"'
    113.0.203.in-addr.arpa:
      file: 113.0.203.in-addr.arpa
      soa:
        class: IN
        ns: ns1.example.com
        contact: hostmaster.example.com
        serial: 2018073100
        retry: 600
        ttl: 600
      records:
        NS:
          '@':
            - ns1.example.com.
        PTR:
          1.113.0.203.in-addr.arpa: ns1.example.com.
          2.113.0.203.in-addr.arpa: foo.example.com.
          3.113.0.203.in-addr.arpa: bar.example.com.
    100.51.198.in-addr.arpa:
      file: 100.51.198.in-addr.arpa
      soa:
        class: IN
        ns: ns1.example.net
        contact: hostmaster.example.net
        serial: auto
        retry: 600
        ttl: 600
      records:
        NS:
          '@':
            - ns1.example.net.
      generate_reverse:
        net: 198.51.100.0/24
        for_zones:
          - example.net

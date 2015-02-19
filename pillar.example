bind:
  lookup:
    pkgs:
      - bind
    service:
      - named

bind:
  config:
    tmpl: salt://bind/files/debian/named.conf
    user: root
    group: named
    mode: 640
    options:
      allow-recursion: '{ any; };'  # Never include this on a public resolver

bind:
  keys:
    "core_dhcp":
      secret: "YourSecretKey"
  configured_zones:
    sub.domain.com:
      type: master
      notify: False
    1.168.192.in-addr.arpa:
      type: master
      notify: False
    dynamic.domain.com:
      type: master
      allow-update: "key core_dhcp"
      notify: True 

bind:
  available_zones:
    sub.domain.org:
      file: db.sub.domain.org
      masters: "192.168.0.1;"

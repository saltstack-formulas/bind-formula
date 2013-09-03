{% from "bind/map.jinja" import map with context %}

include:
  - bind

bind_config:
  file:
    - managed
    - name: {{ map.config }}
    - source: {{ salt['pillar.get']('bind:config:tmpl', 'salt://bind/files/named.conf') }}
    - user: {{ salt['pillar.get']('bind:config:user', 'root') }}
    - group: {{ salt['pillar.get']('bind:config:group', 'named') }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '640') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

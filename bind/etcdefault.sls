{% from "bind/map.jinja" import map with context %}

include:
  - bind

bind_etcdefault_file:
  file.managed:
    - name: {{ map.etcdefault_file }}
    - source: salt://{{ map.config_source_dir }}/etcdefault.jinja
    - template: jinja
    - watch_in:
      - service: bind_restart

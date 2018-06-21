{% from "bind/map.jinja" import map with context %}

{%- set key_directory = salt['pillar.get']('bind:config:key_directory', map.key_directory) %}

bind:
  pkg.installed:
    - pkgs: {{ map.pkgs|json }}
  service.running:
    - name: {{ map.service }}
    - enable: True
    - reload: True

bind_key_directory:
  file.directory:
    - name: {{ key_directory }}
    - require:
      - pkg: bind

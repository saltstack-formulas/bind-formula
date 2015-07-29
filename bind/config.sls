{% from "bind/map.jinja" import map with context %}

include:
  - bind

{{ map.log_dir }}:
  file.directory:
    - user: root
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 775
    - require:
      - pkg: bind

bind_restart:
  service.running:
    - name: {{ map.service }}
    - reload: False
    - watch:
      - file: {{ map.log_dir }}/query.log

{{ map.log_dir }}/query.log:
  file.managed:
    - user: bind
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 644
    - require:
      - file: {{ map.log_dir }}

named_directory:
  file.directory:
    - name: {{ map.named_directory }}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 775
    - makedirs: True
    - require:
      - pkg: bind

bind_config:
  file.managed:
    - name: {{ map.config }}
    - source: 'salt://{{ map.config_source_dir }}/named.conf'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', map.mode) }}
    - context:
        map: {{ map }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_local_config:
  file.managed:
    - name: {{ map.local_config }}
    - source: 'salt://{{ map.config_source_dir }}/named.conf.local'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - context:
        map: {{ map }}
    - require:
      - pkg: bind
      - file: {{ map.log_dir }}/query.log
    - watch_in:
      - service: bind

{% if grains['os_family'] == 'Debian' %}
bind_key_config:
  file.managed:
    - name: {{ map.key_config }}
    - source: 'salt://{{ map.config_source_dir }}/named.conf.key'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_options_config:
  file.managed:
    - name: {{ map.options_config }}
    - source: 'salt://{{ map.config_source_dir }}/named.conf.options'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

bind_default_zones:
  file.managed:
    - name: {{ map.default_zones_config }}
    - source: 'salt://{{ map.config_source_dir }}/named.conf.default-zones'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind

/etc/logrotate.d/{{ map.service }}:
  file.managed:
    - source: salt://{{ map.config_source_dir }}/logrotate_bind
    - template: jinja
    - user: root
    - group: root
    - context:
        map: {{ map }}
{% endif %}

{% for key, args in salt['pillar.get']('bind:configured_zones', {}).iteritems() -%}
{%- set file = salt['pillar.get']("bind:available_zones:" + key + ":file") %}
{% if args['type'] == "master" -%}
zones-{{ file }}:
  file.managed:
    - name: {{ map.named_directory }}/{{ file }}
    - source: 'salt://bind/zones/{{ file }}'
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - watch_in:
      - service: bind
    - require:
      - file: named_directory

{% if args['dnssec'] is defined and args['dnssec'] -%}
signed-{{ file }}:
  cmd.run:
    - cwd: {{ map.named_directory }}
    - name: zonesigner -zone {{ key }} {{ file }}
    - prereq:
      - file: zones-{{ file }}
{% endif %}

{% endif %}
{% endfor %}

{%- for view, view_data in salt['pillar.get']('bind:configured_views', {}).iteritems() %}
{% for key,args in view_data.get('configured_zones', {}).iteritems()  -%}
{%- set file = salt['pillar.get']("bind:available_zones:" + key + ":file") %}
{% if args['type'] == "master" -%}
zones-{{ file }}:
  file.managed:
    - name: {{ map.named_directory }}/{{ file }}
    - source: 'salt://bind/zones/{{ file }}'
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - watch_in:
      - service: bind
    - require:
      - file: named_directory

{% if args['dnssec'] is defined and args['dnssec'] -%}
signed-{{ file }}:
  cmd.run:
    - cwd: {{ map.named_directory }}
    - name: zonesigner -zone {{ key }} {{ file }}
    - prereq:
      - file: zones-{{ file }}
{% endif %}

{% endif %}
{% endfor %}
{% endfor %}

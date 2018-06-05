{% from "bind/map.jinja" import map with context %}

include:
  - bind

{{ map.chroot_dir }}{{ map.log_dir }}:
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
      - file: {{ map.chroot_dir }}{{ map.log_dir }}/query.log

{{ map.chroot_dir }}{{ map.log_dir }}/query.log:
  file.managed:
    - replace: False
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:log_mode', map.log_mode) }}
    - require:
      - file: {{ map.chroot_dir }}{{ map.log_dir }}

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
{%- if salt['pillar.get']('bind:config:tmpl', False) %}
    - source: {{ salt['pillar.get']('bind:config:tmpl') }}
{%- else %}
    - source: 'salt://{{ map.config_source_dir }}/named.conf'
{%- endif %}
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
    - source: salt://bind/files/named.conf.local.jinja
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - context:
        map: {{ map }}
    - require:
      - pkg: bind
      - file: {{ map.chroot_dir }}{{ map.log_dir }}/query.log
    - watch_in:
      - service: bind

{% if grains['os_family'] not in ['Arch', 'FreeBSD']  %}
bind_default_config:
  file.managed:
    - name: {{ map.default_config }}
    - source: salt://{{ map.config_source_dir }}/default
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        map: {{ map }}
    - watch_in:
      - service: bind_restart
{% endif %}

{% if grains['os_family'] == 'Debian' %}
bind_key_config:
  file.managed:
    - name: {{ map.key_config }}
    - source: 'salt://{{ map.config_source_dir }}/named.conf.key'
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '640') }}
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

{%- if salt['pillar.get']('bind:config:use_extensive_logging', False) %}
bind_logging_config:
  file.managed:
    - name: {{ map.logging_config }}
    - source: salt://bind/files/named.conf.logging.jinja
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - context:
        map: {{ map }}
    - require:
      - pkg: bind
    - watch_in:
      - service: bind
{%- endif %}
{%- if salt['pillar.get']('bind:rndc_client', False) %}
bind_rndc_client_config:
  file.managed:
    - name: {{ map.rndc_client_config }}
    - source: salt://{{ map.config_source_dir }}/rndc.conf
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '640') }}
    - context:
        map: {{ map }}
    - require:
      - pkg: bind
{%- endif %}
{% endif %}

{%- set views = {False: salt['pillar.get']('bind', {})} %}{# process non-view zones in the same loop #}
{%- do views.update(salt['pillar.get']('bind:configured_views', {})) %}
{%- for view, view_data in views.items() %}
{%- set dash_view = '-' + view if view else '' %}
{% for zone, zone_data in view_data.get('configured_zones', {}).items() -%}
{%- set file = salt['pillar.get']("bind:available_zones:" + zone + ":file", false) %}
{%- set zone_records = salt['pillar.get']('bind:available_zones:' + zone + ':records', {}) %}
{# If we define RRs in pillar, we use the internal template to generate the zone file
   otherwise, we fallback to the old behaviour and use the declared file
#}
{%- set zone_source = 'salt://bind/files/zone.jinja' if zone_records != {} else 'salt://' ~ map.zones_source_dir ~ '/' ~ file %}
{%- set serial_auto = salt['pillar.get']('bind:available_zones:' + zone + ':soa:serial', '') == 'auto' %}
{% if file and zone_data['type'] == 'master' -%}
zones{{ dash_view }}-{{ zone }}{{ '.include' if serial_auto else ''}}:
  file.managed:
    - name: {{ map.named_directory }}/{{ file }}{{ '.include' if serial_auto else ''}}
    - source: {{ zone_source }}
    - template: jinja
    {% if zone_records != {} %}
    - context:
      zone: zones{{ dash_view }}-{{ zone }}
      soa: {{ salt['pillar.get']("bind:available_zones:" + zone + ":soa") }}
      records: {{ zone_records }}
      include: False
    {% endif %}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - watch_in:
      - service: bind
    - require:
      - file: named_directory

{% if serial_auto %}
zones{{ dash_view }}-{{ zone }}:
  module.wait:
    - name: dnsutil.serial
    - update: True
    - zone: zones{{ dash_view }}-{{ zone }}
    - watch:
      - file: {{ map.named_directory }}/{{ file }}.include
  file.managed:
    - name: {{ map.named_directory }}/{{ file }}
    - require:
      - module: zones{{ dash_view }}-{{ zone }}
    - source: {{ zone_source }}
    - template: jinja
    {% if zone_records != {} %}
    - context:
      zone: zones{{ dash_view }}-{{ zone }}
      soa: {{ salt['pillar.get']("bind:available_zones:" + zone + ":soa") }}
      include: {{ file }}.include
    {% endif %}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - watch_in:
      - service: bind
    - require:
      - file: named_directory
{% endif %}
{% if zone_data['dnssec'] is defined and zone_data['dnssec'] -%}
signed{{ dash_view }}-{{ zone }}:
  cmd.run:
    - cwd: {{ map.named_directory }}
    - name: zonesigner -zone {{ zone }} {{ file }}
    - prereq:
      - file: zones{{ dash_view }}-{{ zone }}
{% endif %}

{% endif %}
{% endfor %}
{% endfor %}

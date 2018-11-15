{% from salt.file.join(tpldir, "map.jinja") import map with context %}
{% from salt.file.join(tpldir, "reverse_zone.jinja") import generate_reverse %}

{%- set key_directory = salt['pillar.get']('bind:lookup:key_directory', map.key_directory) %}
{%- set key_algorithm = salt['pillar.get']('bind:lookup:key_algorithm', map.key_algorithm) %}
{%- set key_algorithm_field = salt['pillar.get']('bind:lookup:key_algorithm_field', map.key_algorithm_field) %}
{%- set key_size = salt['pillar.get']('bind:lookup:key_size', map.key_size) %}
{%- set key_flags = {'zsk': 256, 'ksk': 257} %}

{%- if map.get('zones_directory') %}
  {%- set zones_directory = map.zones_directory %}
{%- else %}
  {%- set zones_directory = map.named_directory %}
{%- endif %}

include:
  - formula.bind

########################################
##
## Create the BIND config
## Commands are numbered only for easy reference - they are not executed in order!
##
########################################

# 1. Create log directory (/var/log/named). Configured in map.jinja.
{{ map.chroot_dir }}{{ map.log_dir }}:
  file.directory:
    - user: root
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 775
    - require:
      - pkg: bind

# 2. Trigger restarts via watches on /var/log/named/query.log and bind_key_directory
bind_restart:
  service.running:
    - name: {{ map.service }}
    - reload: False
    - watch:
      - file: {{ map.chroot_dir }}{{ map.log_dir }}/query.log
      - file: bind_key_directory

# 3. Place /var/log/named/query.log (unless it exists already)
# Require creation of the directory in command 1.
{{ map.chroot_dir }}{{ map.log_dir }}/query.log:
  file.managed:
    - replace: False
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:log_mode', map.log_mode) }}
    - require:
      - file: {{ map.chroot_dir }}{{ map.log_dir }}

# 4. Create /var/named directory. Configured in map.jinja.
# Require bind pkg.installed (via the include at the top).
named_directory:
  file.directory:
    - name: {{ map.named_directory }}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 775
    - makedirs: True
    - require:
      - pkg: bind

# 5. Create a zones directory. Configured in map.jinja.
# WE DON'T DO THIS.
{% if map.get('zones_directory') %}
bind_zones_directory:
  file.directory:
    - name: {{ zones_directory }}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: 775
    - makedirs: True
    - require:
      - pkg: bind
      - file: named_directory
{% endif %}

# 6. Create the bind config file /etc/named.conf
# Uses salt://formula/bind/files/redhat/named.conf as the source template.
# Uses jinja to template it, and passes the entire map dictionary as context.
# View the context with: 
#     salt -G role:dns state.show_sls formula.bind.config and look for the 'bind_config' ID.
# Requires bind pkg.installed (via include at the top).
# Triggers bind service reloads via the watch_in.
# Adds an include declaration for the file created in command 7.
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

# 7. Create /etc/named.conf.local. Configured in map.jinja
# Works much the same as command 6.
# Also passes zones_directory, which we don't have defined explicity, and gets set to 
# map.named_directory (/var/named).
# Requires bind pkg.installed (via include at the top) and query.log file.
# Triggers bind service reloads via the watch_in. 
bind_local_config:
  file.managed:
    - name: {{ map.local_config }}
    - source: salt://formula/bind/files/named.conf.local.jinja
    - template: jinja
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - context:
        map: {{ map }}
        zones_directory: {{ zones_directory }}
    - require:
      - pkg: bind
      - file: {{ map.chroot_dir }}{{ map.log_dir }}/query.log
    - watch_in:
      - service: bind

# 8. Create default config /etc/sysconfig/named
# Pass map as jinja context.
# Trigger bind service restarts via the watch_in.
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

# 9. Set up extensive logging - configured in bind pillar.
{%- if salt['pillar.get']('bind:config:use_extensive_logging', False) %}
bind_logging_config:
  file.managed:
    - name: {{ map.logging_config }}
    - source: salt://formula/bind/files/named.conf.logging.jinja
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
    - makedirs: True
{%- endif %}

# 10. Many nested loops and if-blocks setting up the zone files and views.
# This creates the zone files for the zones set up in available_zones and configured_zones (configured in the zones pillar).
{%- set views = {False: salt['pillar.get']('bind', {})} %}{# process non-view zones in the same loop #}
{%- do views.update(salt['pillar.get']('bind:configured_views', {})) %}
{%- for view, view_data in views|dictsort %}
{%-   set dash_view = '-' + view if view else '' %}
{%    for zone, zone_data in view_data.get('configured_zones', {})|dictsort -%}
{%-     if 'file' in zone_data %}
{%-       set file = zone_data.file %}
{%-       set zone = zone|replace(".txt", "") %}
{%-     else %}
{%-       set file = salt['pillar.get']("bind:available_zones:" + zone + ":file", false) %}
{%-     endif %}
{%-     set zone_records = salt['pillar.get']('bind:available_zones:' + zone + ':records', {}) %}
{%-     if salt['pillar.get']('bind:available_zones:' + zone + ':generate_reverse') %}
{%-       do generate_reverse(zone_records, salt['pillar.get']('bind:available_zones:' + zone + ':generate_reverse:net'), salt['pillar.get']('bind:available_zones:' + zone + ':generate_reverse:for_zones'), salt['pillar.get']('bind:available_zones', {})) %}
{%-     endif %}
{# If we define RRs in pillar, we use the internal template to generate the zone file
   otherwise, we fallback to the old behaviour and use the declared file
#}
{%-     set zone_source = 'salt://formula/bind/files/zone.jinja' if zone_records != {} else 'salt://' ~ map.zones_source_dir ~ '/' ~ file %}
{%-     set serial_auto = salt['pillar.get']('bind:available_zones:' + zone + ':soa:serial', '') == 'auto' %}
{%      if file and zone_data['type'] == 'master' -%}
zones{{ dash_view }}-{{ zone }}{{ '.include' if serial_auto else ''}}:
  file.managed:
    - name: {{ zones_directory }}/{{ file }}{{ '.include' if serial_auto else '' }}
    - source: {{ zone_source }}
    - template: jinja
    {%   if zone_records != {} %}
    - context:
        zone: zones{{ dash_view }}-{{ zone }}
        soa: {{ salt['pillar.get']("bind:available_zones:" + zone + ":soa") }}
        records: {{ zone_records }}
        include: False
    {%   endif %}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - watch_in:
      - service: bind
    - require:
      - file: named_directory
      {% if map.get('zones_directory') %}
      - file: bind_zones_directory
      {% endif %}

{% if serial_auto %}
zones{{ dash_view }}-{{ zone }}:
  module.wait:
    - name: dnsutil.serial
    - update: True
    - zone: zones{{ dash_view }}-{{ zone }}
    - watch:
      - file: {{ zones_directory }}/{{ file }}.include
  file.managed:
    - name: {{ zones_directory }}/{{ file }}
    - require:
      - module: zones{{ dash_view }}-{{ zone }}
    - source: {{ zone_source }}
    - template: jinja
    {% if zone_records != {} %}
    - context:
        zone: zones{{ dash_view }}-{{ zone }}
        soa: {{ salt['pillar.get']("bind:available_zones:" + zone + ":soa") }}
        include: {{ zones_directory }}/{{ file }}.include
    {% endif %}
    - user: {{ salt['pillar.get']('bind:config:user', map.user) }}
    - group: {{ salt['pillar.get']('bind:config:group', map.group) }}
    - mode: {{ salt['pillar.get']('bind:config:mode', '644') }}
    - watch_in:
      - service: bind
    - require:
      - file: named_directory
      {% if map.get('zones_directory') %}
      - file: bind_zones_directory
      {% endif %}
{% endif %}

# 11. Sign the zone file. Configured in the bind and zones pillar files, and the map.jinja file.
# Not sure of the hierarchy - turn off in all places if unwanted.
{% if zone_data['dnssec'] is defined and zone_data['dnssec'] -%}
signed{{ dash_view }}-{{ zone }}:
  cmd.run:
    - cwd: {{ zones_directory }}
    - name: zonesigner -zone {{ zone }} {{ file }}
    - prereq:
      - file: zones{{ dash_view }}-{{ zone }}
{% endif %}

{% endif %}

# 12. More DNSSEC stuff
{% if zone_data['auto-dnssec'] is defined -%}
zsk-{{ zone }}:
  cmd.run:
    - cwd: {{ key_directory }}
    - name: dnssec-keygen -a {{ key_algorithm }} -b {{ key_size }} -n ZONE {{ zone }}
    - runas: {{ map.user }}
    - unless: "grep {{ key_flags.zsk }} {{ key_directory }}/K{{zone}}.+{{ key_algorithm_field }}+*.key"
    - require:
      - file: bind_key_directory

# 13. More DNSSEC stuff
ksk-{{ zone }}:
  cmd.run:
    - cwd: {{ key_directory }}
    - name: dnssec-keygen -f KSK -a {{ key_algorithm }} -b {{ key_size }} -n ZONE {{ zone }}
    - runas: {{ map.user }}
    - unless: "grep {{ key_flags.ksk }} {{ key_directory }}/K{{zone}}.+{{ key_algorithm_field }}+*.key"
    - require:
      - file: bind_key_directory
{% endif %}

{% endfor %}
{% endfor %}

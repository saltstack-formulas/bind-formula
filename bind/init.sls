bind9:
  pkg.installed:
    {% if grains['os_family'] == 'Debian' %}
    - pkgs:
      - bind9
      - bind9-doc
      - bind9utils
    {% else %}
    - name: bind
  file.managed:
    - name: /etc/named.conf
    - source: salt://bind/files/named.conf
    - user: root
    - group: named
    - mode: 640
    - require:
      - pkg: bind9
  service.running:
    - name: named
    - enable: True
    - watch:
      - file: bind9

{% set tpldir = salt['file.normpath'](tpldir) %}
{% if tpldir.endswith('files') %}
{% from tpldir + "/../map.jinja" import openssh with context %}
{% else %}
{% from tpldir + "/map.jinja" import openssh with context %}
{% endif %}

snmp:
  pkg.installed:
    - name: {{ snmp.pkg }}
  service.running:
    - name: {{ snmp.service }}
    - enable: true
    - require:
      - pkg: {{ snmp.pkg }}

{% if grains['os_family'] == 'Debian' %}
include:
  - snmp.default
{% endif %}

{% set tpldir = salt['file.normpath'](tpldir) %}
{% if tpldir.endswith('files') %}
{% from tpldir + "/../map.jinja" import openssh with context %}
{% else %}
{% from tpldir + "/map.jinja" import openssh with context %}
{% endif %}

include:
  - ..snmp

trap:
  service.running:
    - name: {{ snmp.servicetrap }}
    - enable: true

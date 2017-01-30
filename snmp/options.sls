{% set tpldir = salt['file.normpath'](tpldir) %}
{% if tpldir.endswith('files') %}
{% from tpldir + "/../map.jinja" import openssh with context %}
{% else %}
{% from tpldir + "/map.jinja" import openssh with context %}
{% endif %}

include:
  - ..snmp

snmp_options:
  file.managed:
    - name: {{ snmp.options }}
    - template: jinja
    - source: {{ snmp.sourceoptions }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}

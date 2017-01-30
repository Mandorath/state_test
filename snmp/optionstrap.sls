{% set tpldir = salt['file.normpath'](tpldir) %}
{% if tpldir.endswith('files') %}
{% from tpldir + "/../map.jinja" import openssh with context %}
{% else %}
{% from tpldir + "/map.jinja" import openssh with context %}
{% endif %}

include:
  - ..snmp

trap_options:
  file.managed:
    - name: {{ snmp.optionstrap }}
    - template: jinja
    - source: {{ snmp.sourceoptionstrap }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.servicetrap }}

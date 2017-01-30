{% set tpldir = salt['file.normpath'](tpldir) %}
{% if tpldir.endswith('files') %}
{% from tpldir + "/../map.jinja" import openssh with context %}
{% else %}
{% from tpldir + "/map.jinja" import openssh with context %}
{% endif %}

include:
  - ..snmp

snmp_conf:
  file.managed:
    - name: {{ snmp.config }}
    - template: jinja
    - context:
      config: {{ salt['pillar.get']('snmp:conf:settings', {}) }}
    - source: {{ snmp.source }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}

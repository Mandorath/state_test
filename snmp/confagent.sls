{% set tpldir = salt['file.normpath'](tpldir) %}
{% if tpldir.endswith('files') %}
{% from tpldir + "/../map.jinja" import openssh with context %}
{% else %}
{% from tpldir + "/map.jinja" import openssh with context %}
{% endif %}

include:
  - ..snmp

{% for name, source in salt['pillar.get']("snmp:conf:mibs").items() %}
{% if source %}
snmp_mib_{{ name }}:
  file.managed:
    - name: {{ snmp.mibsdir }}/{{ name }}.txt
    - source: {{ source }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}
{% endif %}
{% endfor %}

snmp_agentconf:
  file.managed:
    - name: {{ snmp.configagent }}
    - source: {{ snmp.sourceagent }}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: {{ snmp.service }}

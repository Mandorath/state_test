# == State: firewalld.direct

{% from salt['file.normpath'](tpldir + "/map.jinja") import firewalld with context %}


# == Define: firewalld.direct
#
# This defines a configuration for permanent direct chains,
# rules and passtthroughs, see firewalld.direct (5) man page.

{%- if firewalld.get('direct', False) %}
/etc/firewalld/direct.xml:
  file:
    - managed
    - name: /etc/firewalld/direct.xml
    - user: root
    - group: root
    - mode: "0644"
    - source: salt://{{ slspath }}/files/direct.xml
    - template: jinja
    - require:
      - pkg: package_firewalld # make sure package is installed
      - file: directory_firewalld
    - listen_in:
      - module: service_firewalld # restart service
    - context:
        direct: {{ firewalld.direct|json }}
{%- endif %}

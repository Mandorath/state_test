
# == State: firewalld
#
# This state installs/runs firewalld.
#
{% from salt['file.normpath'](tpldir + "/map.jinja") import firewalld with context %}

{% if salt['pillar.get']('firewalld:enabled') %}
include:
  - .config
  - .ipsets
  - .services
  - .zones
  - .direct

# iptables service that comes with rhel/centos
iptables:
  service.disabled:
    - enable: False

ip6tables:
  service.disabled:
    - enable: False

package_firewalld:
  pkg.installed:
    - name: {{ firewalld.package }}

service_firewalld_running:
  service.running:
    - name: {{ firewalld.service }}
    - enable: True         # start on boot
    - require:
      - pkg: package_firewalld
      - file: config_firewalld
      - service: iptables  # ensure it's stopped
      - service: ip6tables # ensure it's stopped

service_firewalld:
  module.wait:
    - name: service.restart
    - m_name: {{ firewalld.service }}
    - require:
      - pkg: package_firewalld
      - file: config_firewalld
      - service: iptables  # ensure it's stopped
      - service: ip6tables # ensure it's stopped

{% else %}
service_firewalld_dead:
  service.dead:
    - name: {{ firewalld.service }}
    - enable: False # don't start on boot
{% endif %}

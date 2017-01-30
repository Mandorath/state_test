{% from salt['file.normpath'](tpldir + "/map.jinja") import openssh with context %}

ensure dig is available:
  pkg.installed:
    - name: {{ openssh.dig_pkg }}
    - unless: which dig

manage ssh_known_hosts file:
  file.managed:
    - name: {{ openssh.ssh_known_hosts }}
    - source: salt://{{ slspath }}/files/ssh_known_hosts
    - template: jinja
    - user: root
    - group: {{ openssh.root_group }}
    - mode: 644
    - show_changes: False
    - require:
      - pkg: ensure dig is available

# Everything below this is custom and not part of the default openssh formula!!!
{% if salt['file.file_exists']('/home/saabsys/.ssh/id_rsa') == False %}
cmd_saabsys_ssh:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /home/saabsys/.ssh/id_rsa
    - user: saabsys
    - output_loglevel: quiet

{% endif %}

manage ssh_saabsys_authorized_key file:
  file.managed:
    - name: /home/saabsys/.ssh/authorized_keys
    - source: salt://{{ slspath }}/authorized_keys
    - template: jinja
    - user: saabsys
    - group: saabsys
    - mode: 600
    - show_changes: False
    - defaults:
        custom_var: "saabsys"
    - require:
      - pkg: ensure dig is available

manage ssh_saabsys_id_rsa:
  file.managed:
    - name: /home/saabsys/.ssh/id_rsa.pub
    - source: salt://{{ slspath }}/id_rsa_pub
    - template: jinja
    - user: saabsys
    - group: saabsys
    - mode: 600
    - show_changes: False

cpy_contents_pub:
  cmd.run:
    - name: cat /etc/ssh/ssh_host_rsa_key.pub > /home/saabsys/.ssh/id_rsa.pub
    - output_loglevel: quiet
    - require:
      - file: manage ssh_saabsys_id_rsa

manage ssh__priv_saabsys_id_rsa:
  file.managed:
    - name: /home/saabsys/.ssh/id_rsa
    - source: salt://{{ slspath }}/id_rsa
    - template: jinja
    - user: saabsys
    - group: saabsys
    - mode: 600
    - show_changes: False

cpy_contents_priv:
  cmd.run:
    - name: cat /etc/ssh/ssh_host_rsa_key > /home/saabsys/.ssh/id_rsa
    - output_loglevel: quiet
    - require:
      - file: manage ssh__priv_saabsys_id_rsa

# root settings
{% if salt['file.file_exists']('/root/.ssh/id_rsa') == False %}
cmd_root_ssh:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /root/.ssh/id_rsa
    - user: root
    - output_loglevel: quiet
{% endif %}

manage ssh_root_authorized_key file:
  file.managed:
    - name: /root/.ssh/authorized_keys
    - source: salt://{{ slspath }}/authorized_keys
    - template: jinja
    - user: root
    - group: {{ openssh.root_group }}
    - mode: 600
    - defaults:
        custom_var: "root"
    - require:
      - pkg: ensure dig is available

manage ssh_root_id_rsa:
  file.managed:
    - name: /root/.ssh/id_rsa.pub
    - source: salt://{{ slspath }}/id_rsa_pub
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - show_changes: False

root_cpy_contents_pub:
  cmd.run:
    - name: cat /etc/ssh/ssh_host_rsa_key.pub > /root/.ssh/id_rsa.pub
    - output_loglevel: quiet

manage ssh__priv_root_id_rsa:
  file.managed:
    - name: /root/.ssh/id_rsa
    - source: salt://{{ slspath }}/id_rsa
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - show_changes: False


root_cpy_contents_priv:
  cmd.run:
    - name: cat /etc/ssh/ssh_host_rsa_key > /root/.ssh/id_rsa
    - output_loglevel: quiet

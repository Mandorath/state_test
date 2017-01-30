# vim: sts=2 ts=2 sw=2 et ai
{% from salt['file.normpath'](tpldir + "/map.jinja") import users with context %}

# Ensure availability of bash
users_bash-package:
  pkg.latest:
    - name: {{ users.bash_package }}
    - refresh: True
    - allow_updates: True

users_sudo-package:
  pkg.installed:
    - name: {{ users.sudo_package }}
    - require:
      - file: {{ users.sudoers_dir }}

users_{{ users.sudoers_dir }}:
  file.directory:
    - name: {{ users.sudoers_dir }}

users_sudoer-defaults:
    file.append:
        - name: {{ users.sudoers_file }}
        - require:
          - pkg: users_sudo-package
        - text:
          - Defaults   env_reset
          - Defaults   secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          - '#includedir {{ users.sudoers_dir }}'

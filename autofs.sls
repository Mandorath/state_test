file_exports:
  file.managed:
    - name: /etc/exports
    - backup: minion

file_auto.master:
  file.managed:
    - name: /etc/auto.master
    - backup: minion

{% if pillar['PROJECT_AUTOMOUNT'] is defined %}
{% if pillar['PROJECT_AUTOMOUNT'] == grains['host'] %}

srv_nfs:
  service.running:
    - name: nfs
    - reload: True
    - enable: True
    
srv_rpcbind:
  service.running:
    - name: rpcbind
    - enable: True

dir_changes:
  file.directory:
    - name: /HITT/DATA/changes
    - user: nfsnobody
    - group: nfsnobody
    - mode: 775
    - makedirs: True

dir_auto:
  file.directory:
    - name: /auto
    - user: root
    - group: root
    - mode: 755

sym_changes:
  file.symlink:
   - name: /auto/changes
   - target: /HITT/DATA/changes

{% if salt['cmd.retcode']('grep -c "/srv/SAAB/data/changes" /etc/exports') == 1 %}
append_exports:
  file.append:
    - name: /etc/exports
    - text:
      - /srv/SAAB/data/changes *(rw,sync,no_root_squash,no_subtree_check)

srv_nfs_reload:
  service.mod_watch:
    - name: /etc/init.d/nfs
    - reload: True
    
{% endif %}    
{% else %}

pkg_autofs:
  pkg.installed:
    - name: autofs
    - require:
      - sls: installation.repo

pkg_rpcbind:
  pkg.installed:
    - name: rpcbind
    - require:
      - sls: installation.repo

file_append_exports:
  file.append:
    - name: /etc/auto.hitt
    - text:
      - changes -fstype=nfs,vers=4,rsize=8192,wsize=8192,soft pillar['PROJECT_AUTOMOUNT']:/srv/SAAB/data/changes

{% if salt['cmd.run']('grep auto.hitt /etc/auto.master | wc -l') == 0 %}

file_append_exports:
  file.append:
    - name: /etc/auto.master
    - text:
      - /auto /etc/auto.hitt

file_append_autofs:
  file.append:
    - name: /etc/sysconfig/autofs
    - text:
      - AUTOFS_OPTIONS "--timeout 60"
      
{% endif %}
  
srv_autofs:
  service.running:
    - name: autofs
    - enable: True
    - require:
      - pkg: pkg_autofs
    
srv_rpcbind_client:
  service.running:
    - name: rpcbind
    - enable: True
    - require:
      - pkg: pkg_rpcbind
    
{% endif %}
{% endif %}
#################################################################
##                      OS_REPO                                ##
#################################################################
version_repo:
  pkgrepo.managed:
    - humanname: version {{ pillar['active_version'] }}
    - baseurl: {{ pillar['REPO_LOCATION'] }}/repositories/Sysat/Packages/{{ pillar['active_version'] }}
    - gpgcheck: 0

centos_repo:
    pkgrepo.managed:
      - humanname: CentOS Base
      - baseurl: {{ pillar['REPO_LOCATION'] }}/centos/$releasever/os/$basearch/
      - gpgcheck: 0

# ################################################################
# ##                      MGT_REPO                              ##
# ################################################################
#mgt_repo_accum:
#    file.accumulated:
#      - filename: /etc/yum.repos.d/mgt.repo
#      - text: {{ pillar['REPO_LOCATION'] }}
#      - require_in:
#        - file: mgt_repo_manage

#mgt_repo_manage:
#    file.managed:
#      - name: /etc/yum.repos.d/mgt.repo
#      - source: salt://{{ slspath }}/templates/repo/mgt.repo
#      - template: jinja

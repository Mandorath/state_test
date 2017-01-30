include:
  - installation.repo

{% if salt['grains.get']('gpus:vendor') == 'nvidia' %} 
{% set nvidia_run = salt['cmd.run']('yum -y nvidia-detect') %}
nvidia_detect:
  pkg.installed:
    - name: nvidia-detect
    - require:
      - sls: installation.repo
    
pkg_kmod_nvidia:
  pkg.installed:
    - name: kmod-nvidia
    - require:
      - sls: installation.repo

{% endif %}

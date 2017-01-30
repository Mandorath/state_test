{% if salt['grains.get']('gpus:vendor') == 'nvidia' %} 

{% set nvidia_ret_code = salt['cmd.retcode']('nvidia-detect') %}
    
{% if nvidia_ret_code == 1 %}
pkg_kmod_nvidia_lt:
  pkg.latest:
    - name: kmod-nvidia

{% elif nvidia_ret_code == 2 %}
pkg_rm_kmod_nvidia:
   pkg.removed:
    - name: kmod-nvidia

pkg_kmod_nvidia_96:
  pkg.installed:
    - name: kmod-nvidia-96xx.x86_64

{% elif nvidia_ret_code == 3 %}
pkg_rm_kmod_nvidia:
   pkg.removed:
    - name: kmod-nvidia

pkg_kmod_nvidia_173:
  pkg.installed:
    - name: kmod-nvidia-173xx.x86_64

{% elif nvidia_ret_code == 4 %}
pkg_rm_kmod_nvidia:
   pkg.removed:
    - name: kmod-nvidia

pkg_kmod_nvidia_304:
  pkg.installed:
    - name: kmod-nvidia-304xx.x86_64

{% elif nvidia_ret_code == 5 %}

pkg_rm_kmod_nvidia:
   pkg.removed:
    - name: kmod-nvidia

pkg_kmod_nvidia_340:
  pkg.installed:
    - name: kmod-nvidia-340xx.x86_64
{% else %}
cmd_no_nvidia:
  cmd.run:
    - name: echo "no nvidia card detected skipping..."
{% endif %}

{% endif %}

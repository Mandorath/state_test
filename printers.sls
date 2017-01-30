############## Printer state ################33
# note clear the ppd directory?? else this will keep generating new ppd files without removing the old ones!
printers_conf:
  file.managed:
   - name: /etc/cups/printers.conf
   - user: root
   - group: lp
   - mode: 600
   - source: salt://templates/printer/printers.conf
   - template: jinja

{%- set default_printer = salt['pillar.get']('DEFAULT_PRINTER') %}
{% if pillar['DEFAULT_PRINTER'] is defined %}
create_ppd:
  cmd.run:
    - name: foomatic-ppdfile -p Generic-PCL_6_PCL_XL_Printer  > /etc/cups/ppd/{{ pillar['DEFAULT_PRINTER'] }}.ppd
    - use_vt: True
    - unless: /etc/cups/ppd/{{ pillar['DEFAULT_PRINTER'] }}.ppd

adjust_ppd_D1:
  file.replace:
    - name: /etc/cups/ppd/{{ pillar['DEFAULT_PRINTER'] }}.ppd
    - pattern: "DefaultPageSize: Letter"
    - repl: "DefaultPageSize: A4"
    - append_if_not_found: False
    - require:
      - cmd: create_ppd

adjust_ppd_D2:
  file.replace:
    - name: /etc/cups/ppd/{{ pillar['DEFAULT_PRINTER'] }}.ppd
    - pattern: "DefaultPrintoutMode: Normal.Gray"
    - repl: "DefaultPrintoutMode: Normal"
    - append_if_not_found: False
    - require:
      - cmd: create_ppd

lpoptions:
  cmd.run:
    - name: lpoptions -p {{ pillar['DEFAULT_PRINTER'] }} -o PageSize=A4 -o PrintoutMode=Normal -o media=A4
    - use_vt: True
    - require:
      - cmd: create_ppd

{% endif %}

{% for key in pillar.keys() if key.startswith('PRINTER') %}
create_ppd_1:
  cmd.run:
    - name: foomatic-ppdfile -p Generic-PCL_6_PCL_XL_Printer > /etc/cups/ppd/{{ pillar[key] }}.ppd
    - use_vt: True
    - unless: /etc/cups/ppd/{{ pillar[key] }}.ppd

adjust_ppd_P1:
  file.replace:
    - name: /etc/cups/ppd/{{ pillar[key] }}.ppd
    - pattern: "DefaultPrintoutMode: Normal.Gray"
    - repl: "DefaultPrintoutMode: Normal"
    - append_if_not_found: False
    - require:
      - cmd: create_ppd_1

adjust_ppd_P2:
  file.replace:
    - name: /etc/cups/ppd/{{ pillar[key] }}.ppd
    - pattern: "DefaultPrintoutMode: Normal.Gray"
    - repl: "DefaultPrintoutMode: Normal"
    - append_if_not_found: False
    - require:
      - cmd: create_ppd_1

lpoptions_1:
  cmd.run:
    - name: lpoptions -p {{ pillar[key] }} -o PageSize=A4 -o PrintoutMode=Normal -o media=A4
    - use_vt: True
    - require:
      - cmd: create_ppd_1
{% endfor %}

cups:
  service.running:
    - name: cups
    - reload: True
    - enable: True

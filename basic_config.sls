######################################################################
##                       Keyboard Layout                            ##
######################################################################
#                                                                     <---- variable
default_locale:
  locale.system:
   - name: {{ pillar['KEYBOARD_LAYOUT'] }}

######################################################################
##                      Branding	                                ##
######################################################################

/etc/motd:
  file.append:
    - text:
         - {{ pillar['MOTD'] }}

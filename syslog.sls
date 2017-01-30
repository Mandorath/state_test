
##########################################################
##   User xsessions-errors log files			        ##
##########################################################

logrot_xsession_manage:
  file.managed:
    - name: /etc/logrotate.d/xsessionerror
    - source: salt://installation/templates/syslog/xsessionerror
    - template: jinja

##########################################################
##			 postgresql			                        ##
##########################################################
rsyslog_postgres_manage:
  file.managed:
   - name: /etc/rsyslog.d/postgresql.conf
   - source: salt://installation/templates/syslog/postgresql.conf
   - template: jinja

logrot_postgres_manage:
  file.managed:
    - name: /etc/logrotate.d/postgresql
    - source: salt://installation/templates/syslog/postgresql
    - template: jinja

##########################################################
##			 Restart postgres	                        ##
##########################################################  
rsyslog:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: logrot_postgres_manage
#######################################################
##		Enable CoreDumps		                     ##
#######################################################
#kernel.core_pattern:
#  file.replace:
#    - name: /etc/sysctl.conf
#    - pattern: /HITT/coredumps/core-%e-%p-%t
#    - replace: /HITT/coredumps/core-%e-%p-%t
#    - append_if_not_found: True

#kernel.core_pattern:
#  sysctl.present:
#    - value: /HITT/coredumps/core-%e-%p-%t

kernel.core_pattern:
  module.run:
    - name: sysctl.persist 
    - m_name: kernel.core_pattern 
    - value: /HITT/coredumps/core-%e-%p-%t

#######################################################
##		increase SHMAX			                     ##
#######################################################
kernel.shmmax:
  module.run:
    - name: sysctl.persist 
    - m_name: kernel.shmmax
    - value: 18446744073709551615
    
#Due to a bug the state version of sysctl always trows an error on the first run    
#kernel.shmmax:
#  sysctl.present:
#    - value: 18446744073709551615

#######################################################
##		Ephameral PortRange		                     ##
#######################################################
#net.ipv4.ip_local_port_range:
#  sysctl.present:
#    - value: '55000 65635'

net.ipv4.ip_local_port_range:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.ipv4.ip_local_port_range\s*=)\s*.*(#\s.*)?'
    - repl: net.ipv4.ip_local_port_range = 55000 65635
    - append_if_not_found: True

#net.ipv4.ip_local_port_range:
#  module.run:
#    - name: sysctl.persist 
#    - m_name: net.ipv4.ip_local_port_range
#    - value: 55000 65635

########################################################
##			SCTP Parameters		                      ##
########################################################
#net.sctp.rto_min:
#  sysctl.present:
#    - value: 300

net.sctp.rto_min:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.rto_min\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.rto_min = 300
    - append_if_not_found: True
    
#net.sctp.rto_max:
#  sysctl.present:
#    - value: 5000

net.sctp.rto_max:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.rto_max\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.rto_max = 5000
    - append_if_not_found: True
    
#net.sctp.association_max_retrans:
#  sysctl.present:
#    - value: 4

net.sctp.association_max_retrans:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.association_max_retrans\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.association_max_retrans = 4
    - append_if_not_found: True
    
#net.sctp.path_max_retrans:
#  sysctl.present:
#    - value: 2

net.sctp.path_max_retrans:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.path_max_retrans\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.path_max_retrans = 2
    - append_if_not_found: True
    
#net.sctp.max_init_retransmits:
#  sysctl.present:
#    - value: 3

net.sctp.max_init_retransmits:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.max_init_retransmits\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.max_init_retransmits = 3
    - append_if_not_found: True
    
#net.sctp.hb_interval:
#  sysctl.present:
#    - value: 500

net.sctp.hb_interval:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.hb_interval\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.hb_interval = 500
    - append_if_not_found: True
    
#net.sctp.prsctp_enable:
#  sysctl.present:
#    - value: 0

net.sctp.prsctp_enable:
  file.replace:
    - name: /etc/sysctl.conf
    - pattern: '#?(\s*net.sctp.prsctp_enable\s*=)\s*.*(#\s.*)?'
    - repl: net.sctp.prsctp_enable = 0
    - append_if_not_found: True
    
###############################################################
##		Increase Buffersize rc.local		                 ##
###############################################################
/etc/rc.local":
  file.append:
   - text:
     - # The default (1 MByte) and maximum (6 MByte) amount for the receive socket memory.
     - echo 6291456 > /proc/sys/net/core/rmem_max
     - echo 1048576 > /proc/sys/net/core/rmem_default' >> "$rclocal"


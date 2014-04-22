bind:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW,ESTABLISHED
    - dport: 53
    - proto: tcp
    - save: True

  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW,ESTABLISHED
    - dport: 53
    - proto: udp
    - save: True
  

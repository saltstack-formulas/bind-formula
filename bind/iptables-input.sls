bind.input:
  iptables.chain_present:
    -

tcp:
  iptables.insert:
    - table: filter
    - position: 1
    - chain: bind.input
    - jump: ACCEPT
    - match: state
    - connstate: NEW,ESTABLISHED
    - dport: 53
    - proto: tcp
    - save: True

udp:
  iptables.insert:
    - table: filter
    - position: 1
    - chain: bind.input
    - jump: ACCEPT
    - match: state
    - connstate: NEW,ESTABLISHED
    - dport: 53
    - proto: udp
    - save: True

query.reponses:
  iptables.insert:
    - table: filter
    - position: 1
    - chain: bind.input
    - jump: ACCEPT
    - match: state
    - connstate: RELATED,ESTABLISHED
    - sport: 53
    - proto: udp
    - save: True

filter:
  iptables.insert:
    - table: filter
    - position: 1
    - chain: INPUT
    - jump: bind.input
    - save: True


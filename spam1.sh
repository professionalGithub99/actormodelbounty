for i in {1..10000}; do echo "changing to identity network_wallet and sending to principal go7ym-nx4wu-fa2th-u634f-7hp2b-dvfxc-rrp7o-36xl2-sbzmp-r76ho-cqe user network1";dfx identity use network_wallet; dfx canister call btconicpexample send '(principal "go7ym-nx4wu-fa2th-u634f-7hp2b-dvfxc-rrp7o-36xl2-sbzmp-r76ho-cqe",20000000000)';echo "changing identity to network1 and sending to principal go7ym-nx4wu-fa2th-u634f-7hp2b-dvfxc-rrp7o-36xl2-sbzmp-r76ho-cqe";dfx identity use network1; dfx canister call btconicpexample send '(principal "go7ym-nx4wu-fa2th-u634f-7hp2b-dvfxc-rrp7o-36xl2-sbzmp-r76ho-cqe",10000000000)';sleep 0.01; done

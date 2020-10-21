#include <uapi/linux/if_ether.h>
#include <uapi/linux/in.h>
#include <uapi/linux/ip.h>
#include <uapi/linux/tcp.h>


// XDP program that passes all packets to the network stack
int pass_all_packets(struct xdp_md *ctx) {
	return XDP_PASS;
}

// XDP program that drops IPv4 packets with TCP transport protocol towards port 80
// Source: https://gist.github.com/yunazuno/14eb1b7fc5eb6bb23f36d1d01ed00367#file-drop_ipv4_tcp_80-c
int drop_ipv4_tcp_80(struct xdp_md *ctx) {

	void *data = (void *)(long)ctx->data;
	void *data_end = (void *)(long)ctx->data_end;

	struct ethhdr *eth;
	struct iphdr *iph;
	struct tcphdr *th;

	eth = data;
	if ((void *)(eth + 1) > data_end)
		return XDP_DROP;

	if (eth->h_proto != htons(ETH_P_IP))
		return XDP_PASS;

	iph = (struct iphdr *)(eth + 1);
	if ((void *)(iph + 1) > data_end)
		return XDP_DROP;

	if (iph->ihl != 5 || iph->frag_off & htons(0x2000 | 0x1FFF))
		return XDP_PASS;

	if (iph->protocol != IPPROTO_TCP) {
		return XDP_PASS;
	}

	th = (struct tcphdr *)(iph + 1);
	if ((void *)(th + 1) > data_end)
		return XDP_DROP;

	if (th->dest == htons(80))
		return XDP_DROP;

	return XDP_PASS;
}

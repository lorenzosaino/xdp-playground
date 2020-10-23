from bcc import BPF, libbcc
import ctypes
from scapy.all import *


class TestSuite(object):

    xdp_retvals = {val: name for name, val in BPF.__dict__.items()
                   if name.startswith("XDP_")}

    def compile_and_load(self, src_file, func_name):
        bpf = BPF(src_file=src_file)
        self.func = bpf.load_func(func_name, BPF.XDP)

    def run_test(self, data, data_out_expect, retval_expect,
                 repeat=1, data_out_len=1514):
        size = len(data)
        data = ctypes.create_string_buffer(raw(data), size)
        data_out = ctypes.create_string_buffer(data_out_len)
        size_out = ctypes.c_uint32()
        retval = ctypes.c_uint32()
        duration = ctypes.c_uint32()

        ret = libbcc.lib.bpf_prog_test_run(self.func.fd, repeat,
                                           ctypes.byref(data), size,
                                           ctypes.byref(data_out),
                                           ctypes.byref(size_out),
                                           ctypes.byref(retval),
                                           ctypes.byref(duration))
        assert ret == 0

        assert self.xdp_retvals[retval.value] == self.xdp_retvals[retval_expect]
        if data_out_expect:
            assert data_out[:size_out.value] == raw(data_out_expect)


class TestPass(TestSuite):

    def setup_method(self):
        self.compile_and_load(b"xdp.c", b"pass_all_packets")

    def test_tcp_pass(self):
        packet_in = Ether() / IP() / TCP()
        self.run_test(packet_in, None, BPF.XDP_PASS)

    def test_udp_pass(self):
        packet_in = Ether() / IP() / UDP()
        self.run_test(packet_in, None, BPF.XDP_PASS)


class TestDrop(TestSuite):

    def setup_method(self):
        self.compile_and_load(b"xdp.c", b"drop_ipv4_tcp_80")

    def test_ipv4_tcp_80(self):
        packet_in = Ether() / IP() / TCP(dport=80)
        self.run_test(packet_in, None, BPF.XDP_DROP)

    def test_ipv4_udp_80(self):
        packet_in = Ether() / IP() / UDP(dport=80)
        self.run_test(packet_in, packet_in, BPF.XDP_PASS)

    def test_ipv4_tcp_443(self):
        packet_in = Ether() / IP() / TCP(dport=443)
        self.run_test(packet_in, packet_in, BPF.XDP_PASS)

    def test_ipv6_tcp_80(self):
        packet_in = Ether() / IPv6() / TCP(dport=443)
        self.run_test(packet_in, packet_in, BPF.XDP_PASS)

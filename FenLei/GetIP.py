# -*- coding: utf-8 -*-
"""
Created on Mon Jun 17 10:00:39 2024

@author: Administrator
"""

import ifaddr


def get_local_ip_address_starting_with(prefix):
    # 遍历所有网络接口
    for interface in ifaddr.get_adapters():
        for ip in interface.ips:
            # 检查IP地址是否为IPv4且以指定前缀开头
            if ip.is_IPv4 and str(ip.ip).startswith(prefix):
                return str(ip.ip)
    return None  # 如果没有找到符合条件的IP地址，则返回None


# 调用函数并打印IP地址
ip_prefix = '192.168.0.'
ip_address = get_local_ip_address_starting_with(ip_prefix)
# if ip_address:
#     print(f"本机局域网中以{ip_prefix}开头的IPv4地址是: {ip_address}")
# else:
#     print(f"无法找到本机局域网中以{ip_prefix}开头的IPv4地址")

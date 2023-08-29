# Overview
This tool implements the least information redundancy algorithm of printable shellcode encoding for x86.

# Usage

```shell
$ python3 Lycan.py 
usage: Lycan [-h] [-e  | -t | --template | --no-template] [-H | --hex | --no-hex] [-g | --generate | --no-generate]

Lycan -- a tool that implements the least information redundancy algorithm of printable shellcode encoding for x86

options:
  -h, --help            show this help message and exit
  -e , --encode         encode the original shellcode
  -t, --template, --no-template
                        use the Lycan's default template shellcode (default: False)
  -H, --hex, --no-hex   output the encoded shellocode in hex format (default: False)
  -g, --generate, --no-generate
                        generate template C code in `temp.c` and compile it to `temp` (default: False)

Example:
python3 Lycan.py -e "\xde\xad\xbe\xef"
python3 Lycan.py -H -g -e \xde\xad\xbe\xef
python3 Lycan.py -H -e 'DeadBeef'
python3 Lycan.py -g -t
```

# Detail

This work is inspired by [psc](https://github.com/dhrumil29699/Printable-Encoder) and utilizes the XOR patching technique. `Notice` that Lycan assumes the register `eax` represents the start address of shellcode for injection.
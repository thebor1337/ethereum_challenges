# @version ^0.3.7

b: public(bool)
i: public(int128)  # -2 ** 127 to (2 ** 127 - 1)
u: public(uint256)  # 0 to 2 ** 256 - 1
dec: public(decimal)  # -2 ** 127 to (2 ** 127 - 1), 10 decimal places
addr: public(address)
b32: public(bytes32)
bs: public(Bytes[100])
s: public(String[100])


@external
def __init__():
    self.b = False
    self.i = -5
    self.u = 150
    self.dec = 3.14
    self.addr = 0x0000000000000000000000000000000000000000
    self.b32 = 0xada1b75f8ae9a65dcc16f95678ac203030505c6b465c8206e26ae84b525cdacb
    self.bs = b"\x01"
    self.s = "Hello Vyper"
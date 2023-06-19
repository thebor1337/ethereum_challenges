# @version ^0.3.7

interface HelloCtf:
    def capture(): nonpayable


target: public(HelloCtf)


@external
def __init__(target: address):
    self.target = HelloCtf(target)


@external
def pwn():
    # write your code here
    self.target.capture()
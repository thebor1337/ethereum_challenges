# @version ^0.3.7


@external
@payable
def __default__():
    pass


@external
def kill():
    selfdestruct(msg.sender)


@external
def burn():
    selfdestruct(empty(address))
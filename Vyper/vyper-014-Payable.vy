# @version ^0.3.7
owner: public(address)

event Deposit:
    sender: indexed(address)
    amount: uint256


@external
@payable
def deposit():
    log Deposit(msg.sender, msg.value)


@external
@view
def getBalance() -> uint256:
    # Get balance of Ether stored in this contract
    return self.balance


@external
@payable
def pay():
    assert msg.value > 0, "invalid value"
    self.owner = msg.sender
# @version ^0.3.7


@external
@nonreentrant("lock")
def func0():
    # call back msg.sender
    raw_call(msg.sender, b"", value=0)


@external
@nonreentrant("lock")
def func1():
    raw_call(msg.sender, b"", value=0)


@external
@nonreentrant("lock")
def func2():
    raw_call(msg.sender, b"", value=0)
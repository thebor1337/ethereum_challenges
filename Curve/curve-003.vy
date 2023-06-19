# @version ^0.3.7

from vyper.interfaces import ERC20

TRICRYPTO_POOL: constant(address) = 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46
USDT: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7

interface ICryptoSwap:
    def exchange(
      i: uint256, j: uint256, dx: uint256, min_dy: uint256, use_eth: bool = False
    ): payable


@external
@payable
def swap():
    ICryptoSwap(TRICRYPTO_POOL).exchange(2, 0, msg.value, 0, True, value=msg.value)
    self._safeTransfer(USDT, msg.sender, ERC20(USDT).balanceOf(self))


@internal
def _safeTransfer(coin: address, to: address, amount: uint256):
    res: Bytes[32] = raw_call(
        coin,
        concat(
            method_id("transfer(address,uint256)"),
            convert(to, bytes32),
            convert(amount, bytes32),
        ),
        max_outsize=32,
    )

    if len(res) > 0:
        assert convert(res, bool)
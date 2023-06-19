# @version ^0.3.7

from vyper.interfaces import ERC20

TRICRYPTO_POOL: constant(address) = 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46
POOL_TOKEN: constant(address) = 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff

USDT: constant(address) = 0xdAC17F958D2ee523a2206206994597C13D831ec7
WBTC: constant(address) = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
WETH: constant(address) = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2

COINS: constant(address[3]) = [USDT, WBTC, WETH]


interface ICryptoSwap:
    def add_liquidity(amounts: uint256[3], min_mint_amount: uint256): nonpayable
    def remove_liquidity(shares: uint256, min_amounts: uint256[3]): nonpayable
    def remove_liquidity_one_coin(shares: uint256, i: uint256, min_amount: uint256): nonpayable

interface IWETH:
    def deposit(): payable
    def withdraw(amount: uint256): nonpayable


@external
@payable
def addLiquidity():
    IWETH(WETH).deposit(value=msg.value)
    ERC20(WETH).approve(TRICRYPTO_POOL, msg.value)
    ICryptoSwap(TRICRYPTO_POOL).add_liquidity([0, 0, msg.value], 0)


@external
def removeLiquidity():
    shares: uint256 = ERC20(POOL_TOKEN).balanceOf(self)
    ICryptoSwap(TRICRYPTO_POOL).remove_liquidity(shares / 2, [0, 0, 0])
    for i in range(3):
        self._safeTransfer(COINS[i], msg.sender, ERC20(COINS[i]).balanceOf(self))


@external
def removeLiquidityOneCoin():
    shares: uint256 = ERC20(POOL_TOKEN).balanceOf(self)
    ICryptoSwap(TRICRYPTO_POOL).remove_liquidity_one_coin(shares, 2, 0)
    IWETH(WETH).withdraw(ERC20(WETH).balanceOf(self))
    send(msg.sender, self.balance)


@external
@payable
def __default__():
    pass


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
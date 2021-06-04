pragma solidity 0.6.12;

import "./helpers/ERC20.sol";

import "./libraries/Address.sol";

import "./libraries/SafeERC20.sol";

import "./libraries/EnumerableSet.sol";

import "./helpers/Ownable.sol";

import "./helpers/ReentrancyGuard.sol";

abstract contract BUST is ERC20{
    function mint(address _to, uint256 _amount) public virtual;
}//inheriting the functionality of ERC20 and we add one extra function mint to be present 
contract some is Ownable,ReentrancyGuard{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    
    uint public BNBPerBlock=;
    uint public BUSTPerBlock=480;
   
    struct PoolInfo {
        IERC20 want; // Address of the want token.
        uint256 bnballocPoint; // How many allocation points assigned to this pool. AUTO to distribute per block.
        uint256 bustallocPoint;
        uint256 lastRewardBlock; // Last block number that AUTO distribution occurs.
        uint256 accBNBPerShare; // Accumulated BNB per share, times 1e12. See below. 
        uint256 accBustperShare;//Accumulated bust per share
        address strat; // Strategy address that will au'[to compound want tokens
    }
    //we will create some other function and update all bust and bnb 
    //create a for loop to update each and every pool with specific amount and update that pool shares
    //whenever we want to update the pools we will call that mass update
  function updatepool(uint256 _pid) public{

      PoolInfo storage pool = poolInfo[_pid];
      if (block.number <= pool.lastRewardBlock) {
          return;
     }
       
     uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
     if (multiplier <= 0) { 
         return;//if multiplier is 0 we cannot mint auto tokens
    }
    uint256 sharesTotal = IStrategy(pool.strat).sharesTotal();
        if (sharesTotal == 0) {
            pool.lastRewardBlock = block.number;//is there are 0 shares in the statergy that mmeans no one added the lp token in between
            return;
    }
        
    uint256 BNBAmount=multiplier.mul(BNBPerBlock).mul(pool.bnballocPoint).div(totalBNBAllocPoint);//you will mint the bnb as per the mint percentage of pool
    uint256 BUSTAmount=multiplier.mul(BUSTPerBlock).mul(pool.bustallocPoint).div(totalBUSTAllocPoint);//you will mint the bust as per the mint percentage of pool
    IERC20(BNB).safeTransferFrom(_spender,address(this),BNBAmount);//transfer the specified bnb amount from the account 0
    BUST(BUST).mint(address(this),BUSTAmount);//take the address of the contract which implements ERC20 and the additional mint function
    pool.accBNBPerShare = pool.accBNBPerShare.add(
            BNBAmount.mul(1e12).div(sharesTotal)
    );
    pool.accBustperShare=pool.accBustperShare.add(
        BUSTAmount.mul(1e12).div(sharesTotal)
    );
     pool.lastRewardBlock = block.number;
    
    //uint FarmingBUSTShare=BUSTAmount.mul(95).div(100);
    //uint affialateShare=BUSTAmount.mul(5).div(100);
    //uint BNB-SINGLE-POOL_amount=BNBAmount.mul(3).div(100);
    //uint BUSTBUSDLPpool_amount=FarmingBUSTShare
    //BNBSinglePoolDeposit(BNBAmount.mul(3).div(100));
    //BUSTBNBLpPoolDeposit(FarmingBUSTShare.mul(16).div(100),BNBAmount.mul(16).div(100)); 
    //BUSTBUSDLPpoolDeposit(FarmingBUSTShare.mul(32).div(100));//swap half into BUSD
    //BUSTSinglepoolDeposit(FarmingBUSTShare.mul(32).div(100));
    //DAOTreasuryDeposit(FarmingBUSTShare.mul(0.5).div(100),BNBAmount.mul(0.5).div(100));
    //AffiliateRewardPoolDeposit(affialateShare);
}
function getMultiplierforBNB(uint256 _from, uint256 _to)
        public
        view
        returns (uint256)
   {
        if (IERC20(BNB).totalSupply() >= BNBMaxSupply) {//if we minted more than the auto max supply there is no way to mint
            return 0;
        }
        return _to.sub(_from);
    }
 
 /*
 
// BUSTToken(BUST).mint(A,BUSTAmount.mul(5).div(100));


  BNBSinglePoolStake(uint amount){
        IERC20(BNB).safeIncreaseAllowance(routeraddress,amount);
        Interface(routeraddress).addLiquidity(amount);

    }
    BUSTBNBLpPool(uint _token0amount,uint _token1amount)
    {
       // IERC20(token0Address) incereae allowance to poolcontract for token0amount to spend
       //IERC20(token1Address)increasse allowance to poolcontract for token1amount to spend
       //Interface(routeraddress).addLiquidity
    }
    BUSTBUSDLPpool(uint _bsutamount){
        //split bsut into two parts
        //convert one part swap into bsud 
        //Take two tokens and provide liquidity
    }
    BUSTSinglepool(uint amount){
        //IERC20(BUST).safeIncreaseAllowance(routeraddress,amount);
        //Interface(routeraddress).addLiquidity(amount);
    }

    //BSUT/BUSD-->take 32 persent amount of BSUT and divide into half and convert half of the amount nto the BUSD and deposit both into Bust and Busd pool
    
}*/
}

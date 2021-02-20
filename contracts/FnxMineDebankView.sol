
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./Storage.sol";
import "./Ownable.sol";


interface IFixedMinePool {
     function getUserCurrentAPY(address account,address mineCoin) external view returns (uint256);
     function getUserFPTBBalance(address account) external view returns (uint256);
     function getUserFPTABalance(address account) external view returns (uint256);
     function getMinerBalance(address account,address mineCoin) external view returns(uint256);
}

interface IFnxOracle {
     function getPrice(address asset) external view returns (uint256);
}

interface ICollateralPool {
     function getTokenNetworth() external view returns (uint256);
     function getUserInputCollateral(address user,address collateral) external view returns (uint256);
     function getUserPayingUsd(address account) external view returns (uint256);

}

interface IMineConverter {
     function lockedBalanceOf(address account) external view returns (uint256);
}

contract FnxMineDebankView is Storage,Ownable {
    
    using SafeMath for uint256;

    function getMinedUnclaimedBalance(address _user) public view returns (uint256) {
        return IFixedMinePool(fixedMinePool).getMinerBalance(_user,cfnxToken);
    }

    function getConverterLockedBalance(address _user) public view returns (uint256) {
        return IMineConverter(cfnxToken).lockedBalanceOf(_user);
    }

    
    function getApy(address _user) public view returns (uint256) {
            uint256 mineofyear = IFixedMinePool(fixedMinePool).getUserCurrentAPY(_user,cfnxToken);
            
            uint256 FTPA = IFixedMinePool(fixedMinePool).getUserFPTABalance(_user);
            uint256 FTPB = IFixedMinePool(fixedMinePool).getUserFPTBBalance(_user);
            uint256 fnxprice =  IFnxOracle(fnxOracle).getPrice(fnxToken);
            uint256 fptaprice = ICollateralPool(usdcColPool).getTokenNetworth();
            uint256 fptbprice = ICollateralPool(fnxColPool).getTokenNetworth();

            uint256 denominater = (FTPA.mul(fptaprice)).add(FTPB.mul(fptbprice));
            
            if(denominater==0) {
               return 0;
            }
            
            return mineofyear.mul(fnxprice).mul(1000).div(denominater);
    }
    
    
    function getFnxPoolColValue(address _user) public view returns (uint256) {
       return ICollateralPool(fnxColPool).getUserPayingUsd(_user);
    }


    function getUsdcPoolColValue(address _user)  public view returns (uint256) {
        return ICollateralPool(fnxColPool).getUserPayingUsd(_user);
    }
    
    /**
     * @dev Retrieve user's locked balance. 
     * @param _user account.
     * @param _collateral the collateal token address
     * @param _pool the collateal pool     
     */
    function getUserInputCollateral(address _user,address _collateral,address _pool) public view returns (uint256){
      return ICollateralPool(_pool).getUserInputCollateral(_user,_collateral);   
    }
    
    function getVersion() public pure returns (uint256)  {
        return 1;
    }
    

    function resetTokenAddress( 
                                address _fnxColPool, 
                                address _usdcColPool, 
                                address _fnxToken,   
                                address _usdcToken, 
                                address _usdtToken,
                                address _cfnxToken,
                                address _fnxOracle,
                                address _fixedMinePool
                                
                              )  public onlyOwner {
                                  
        fnxColPool  = _fnxColPool;
        usdcColPool = _usdcColPool;
        fnxToken    = _fnxToken; 
        usdcToken   = _usdcToken;
        usdtToken   = _usdtToken;
        cfnxToken   = _cfnxToken;
        fnxOracle    = _fnxOracle;
        fixedMinePool = _fixedMinePool;
    }
    
    
}


  
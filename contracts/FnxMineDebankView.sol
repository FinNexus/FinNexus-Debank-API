
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
     function userInputCollateral(address user,address collateral) external view returns (uint256);
     function getUserPayingUsd(address account) external view returns (uint256);

}

interface IMineConverter {
     function lockedBalanceOf(address account) external view returns (uint256);
}

contract FnxMineDebankView is Ownable {
    using SafeMath for uint256;

    address public fnxColPool = 0xfDf252995da6D6c54C03FC993e7AA6B593A57B8d;
    address public fnxToken = 0xeF9Cd7882c067686691B6fF49e650b43AFBBCC6B;
    address public cfnxToken = 0x9d7beb4265817a4923FAD9Ca9EF8af138499615d;
    address public fnxOracle = 0x43BD92bF3Bb25EBB3BdC2524CBd6156E3Fdd41F3;

    function getMinedUnclaimedBalance(address _user,address minepool) public view returns (uint256) {
        return IFixedMinePool(minepool).getMinerBalance(_user,cfnxToken);
    }

   function getApy(address _user,address minepool,address colforfptapool) public view returns (uint256) {
            uint256 mineofyear = IFixedMinePool(minepool).getUserCurrentAPY(_user,cfnxToken);
            
            uint256 FTPA = IFixedMinePool(minepool).getUserFPTABalance(_user);
            uint256 FTPB = IFixedMinePool(minepool).getUserFPTBBalance(_user);
            uint256 fnxprice =  IFnxOracle(fnxOracle).getPrice(fnxToken);

            uint256 fptaprice = ICollateralPool(colforfptapool).getTokenNetworth();
            uint256 fptbprice = ICollateralPool(fnxColPool).getTokenNetworth();

            uint256 denominater = (FTPA.mul(fptaprice)).add(FTPB.mul(fptbprice));
            if(denominater==0) {
               return 0;
            }

            return mineofyear.mul(fnxprice).mul(1000).div(denominater);
    }

    /**
     * @dev Retrieve user's locked balance. 
     * @param _user account.
     * @param _collateral the collateal token address
     * @param _colpool the collateal pool
     */
    function getUserInputCollateral(address _user,address _collateral,address _colpool) public view returns (uint256){
      return ICollateralPool(_colpool).userInputCollateral(_user,_collateral);
    }
    
    function getVersion() public pure returns (uint256)  {
        return 1;
    }

    function resetTokenAddress( 
                                address _fnxColPool, 
                                address _fnxToken,
                                address _cfnxToken,
                                address _fnxOracle
                              )  public onlyOwner {
                                  
        fnxColPool  = _fnxColPool;
        fnxToken    = _fnxToken;
        cfnxToken   = _cfnxToken;
        fnxOracle    = _fnxOracle;
    }
    
}


  
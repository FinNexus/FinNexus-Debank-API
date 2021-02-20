pragma solidity ^0.5.0;

import "./util/openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./util/openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract TokenMock is ERC20, ERC20Detailed {

    string public _name;
    string public _symbol;
    uint8 public _decimals;

    constructor () public ERC20Detailed("", "", 18)
    {
    }

 
     function getUserCurrentAPY(address account,address mineCoin) external view returns (uint256){
            return 1 ether;
     }

     function getUserFPTBBalance(address account) external view returns (uint256){
        return 1 ether;
     }

     function getUserFPTABalance(address account) external view returns (uint256){
            return 1 ether;
     }

     function getMinerBalance(address account,address mineCoin) external view returns(uint256){
            return 1 ether;
     }



     function getPrice(address asset) external view returns (uint256){
            return 1e8;
     }


     function getTokenNetworth() external view returns (uint256){
         return 1e8;
     }
     function getUserInputCollateral(address user,address collateral) external view returns (uint256){
            return 1 ether;
     }

     function getUserTotalWorth(address account) external view returns (uint256){
            return 1e8;
     }

     function lockedBalanceOf(address account) external view returns (uint256){
         return 1 ether;
     }

      
   
 }

contract TokenFactory {
    address public createdToken;

    function createToken(uint8 decimals) public returns (address token) {
        bytes memory bytecode = type(TokenMock).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(createdToken));
        assembly {
            token := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        createdToken = token;
        TokenMock(createdToken).setDecimal(decimals);
    }
}

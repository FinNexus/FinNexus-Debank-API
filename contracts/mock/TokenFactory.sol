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

     }

     function getUserFPTBBalance(address account) external view returns (uint256){

     }

     function getUserFPTABalance(address account) external view returns (uint256){

     }

     function getMinerBalance(address account,address mineCoin) external view returns(uint256){

     }



     function getPrice(address asset) external view returns (uint256){

     }



     function getTokenNetworth() external view returns (uint256){

     }
     function getUserInputCollateral(address user,address collateral) external view returns (uint256){

     }

     function getUserTotalWorth(address account) external view returns (uint256){

     }




     function lockedBalanceOf(address account) external view returns (uint256){
         
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

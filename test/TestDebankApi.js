
const DebankApi = artifacts.require('FnxMineDebankView');
const Token = artifacts.require("TokenMock");

const assert = require('chai').assert;
const Web3 = require('web3');
const config = require("../truffle.js");
const BN = require("bn.js");


web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));


/**************************************************
 test case only for the ganahce command
 ganache-cli --port=7545 --gasLimit=8000000 --accounts=10 --defaultBalanceEther=100000 --blockTime 1
 **************************************************/
contract('FnxMineDebankView', function (accounts){
    let mockToken;
    let debankApi;

    before("init", async()=>{
        debankApi = await DebankApi.new();
        console.log("debankApi address:", debankApi.address);

        mockToken = await Token.new();
        console.log("mockToken address:",mockToken.address);

        let tx= await debankApi.resetTokenAddress(mockToken.address,mockToken.address,mockToken.address,mockToken.address);

        assert.equal(tx.receipt.status,true);
    })


   it("[0010]vote from all of pools,should pass", async()=>{
      let unclaimedBal = await debankApi.getMinedUnclaimedBalance(accounts[0],mockToken.address);
      unclaimedBal = web3.utils.fromWei(new BN(unclaimedBal));
      console.log(unclaimedBal);
      assert.equal(unclaimedBal,1);

     let getApy = await debankApi.getApy(accounts[0],mockToken.address,mockToken.address);
     console.log(getApy);
     assert.equal(getApy,500);

     let getUserInputCollateral = await debankApi.getUserInputCollateral(accounts[0],mockToken.address,mockToken.address);
     getUserInputCollateral = web3.utils.fromWei(new BN(getUserInputCollateral));
     console.log(getUserInputCollateral);
     assert.equal(getUserInputCollateral,1);

		})

})

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

//import 1155 token contract from Openzeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";



contract Kaktos is ERC1155, Ownable {
    using SafeMath for uint256;

    address payable accountOne;
    address payable accountTwo;
    address public lastToWithdraw;
    uint256 public lastWithdrawAmount;
    uint256 public contractBalance;
    string public baseURI;
    uint256 public totalSupply = 1000;
    uint256 public mintPrice = 10 ether;
    uint256 public maxMintAmount = 10;
    bool public paused = false;

    //owner?
    //gas limit?

    constructor(
        string memory _name, 
        //string memory _symbol, 
        string memory _initBaseURI)
        ERC1155(_name) {
            setBaseURI(_initBaseURI);
            mint(msg.sender, 10);
        }
  
    function mint(address account, uint256 _mintAmount) public payable {
        uint256 supply = totalSupply;
        require(!paused);
        require(_mintAmount > 0);
        require(_mintAmount <= maxMintAmount);
        require(supply.add(_mintAmount) <= totalSupply);

          for (uint256 i = 1; i <= _mintAmount; i++) { 
            (account, supply + i);
        }
    }

    function burn(address account, uint256 id, uint256 amount) public {
        require(msg.sender == account);
        _burn(account, id, amount);
    }
    
     function withdraw (uint amount, address payable recipient) public {

        require(recipient == accountOne || recipient == accountTwo , "You dont own this account");

        require(amount <= contractBalance, "Insufficient Funds"); 

        if (lastToWithdraw != recipient) {
            lastToWithdraw = recipient;
        }
 
        recipient.transfer(amount);

        lastWithdrawAmount = amount;

        contractBalance = address(this).balance; 
    }

    function setAccounts (address payable account1, address payable account2) public {

        accountOne = account1;
        accountTwo = account2;
    }

    receive() external payable {}

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

//import 1155 token contract from Openzeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";



contract NFTContract is ERC1155, Ownable {
    using SafeMath for uint256;

    address payable accountOne;
    address payable accountTwo;
    address payable accountThree;
    address payable accountFour;
    address public lastToWithdraw;
    uint public lastWithdrawAmount;
    uint public contractBalance;

    string public baseURI;
    uint256 public totalSupply = 1000;
    uint256 public mintPrice = 10 ether;
    uint256 public maxMintAmount = 10;
    //owner?
    //gas limit?

    constructor(string memory _name, 
                string memory _symbol, 
                string memory _initBaseURI)
        ERC1155(_name, _symbol) {
            setBaseURI(_initBaseURI);
            _mint(msg.sender, 20);
        }
  
    function mint(address account, uint256 id, uint256 amount) public payable {
        _mint(account, id, amount, "");
    }

    function burn(address account, uint256 id, uint256 amount) public {
        require(msg.sender == account);
        _burn(account, id, amount);
    }
    
     function withdraw (uint amount, address payable recipient) public {

        require(recipient == accountOne || recipient == accountTwo 
        || recipient == accountOne || recipient == accountFour, "You dont own this account");

        require(amount <= contractBalance, "Insufficient Funds"); 

        if (lastToWithdraw != recipient) {
            lastToWithdraw = recipient;
        }
 
        recipient.transfer(amount);

        lastWithdrawAmount = amount;

        contractBalance = address(this).balance; 
    }

    function setAccounts (address payable account1, address payable account2, 
    address payable account3, address payable account4) public {

        accountOne = account1;
        accountTwo = account2;
        accountThree = account3;
        accountFour = account4;
    }

    fallback() external payable {}
}

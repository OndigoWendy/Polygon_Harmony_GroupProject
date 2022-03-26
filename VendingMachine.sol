pragma solidity ^0.8.7;

contract SmartVendingMachine {
    enum Statuses { InStock, OutOfStock }
    Statuses currentStatus;

    event Dispense(address _buyer, uint _value);    //the vending machine can subscribe to this event and dispense the item
    address payable public owner;                   //the guy that owns the vending machine
    //uint public numItemsLeft;

    constructor() public {
        owner = payable(msg.sender); //owner is the guy that creates the contract
        currentStatus = Statuses.InStock;
    }

    modifier isInStock{
        require(currentStatus == Statuses.InStock, "Sorry, this product is not available right now.");
        _;
    }
    
    modifier priceIsMet (uint _price) {
        require(msg.value >= _price, "Not enought Ether provided");
        _;
    }
    
    receive() external payable isInStock priceIsMet(2 ether) {
        currentStatus = Statuses.OutOfStock;
        owner.transfer(msg.value);
        emit Dispense(msg.sender, msg.value);
    }
}
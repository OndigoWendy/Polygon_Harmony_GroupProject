pragma solidity ^0.8.7;

contract HotelBooking {
    enum Statuses { InStock, OutOfStock }
    Statuses currentStatus;

    event OpenRoom(address _buyer, uint _value);   
    address payable public owner;                   

    constructor() public {
        owner = payable(msg.sender);
        currentStatus = Statuses.InStock;
    }

    modifier isInStock{
        require(currentStatus == Statuses.InStock, "Sorry, this room is taken.");
        _;
    }
    
    modifier priceIsMet (uint _price) {
        require(msg.value >= _price, "Not enought Ether provided");
        _;
    }
    
    receive() external payable isInStock priceIsMet(2 ether) {
        currentStatus = Statuses.OutOfStock;
        owner.transfer(msg.value);
        emit OpenRoom(msg.sender, msg.value);
    }
}
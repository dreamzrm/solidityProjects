pragma solidity ^0.8.1;

contract ticketSystem {
    
    uint count=0;
    uint maxCount;

    address private owner;
    uint ticketCost;

    enum guestListStatus { open, close }
    guestListStatus currentStatus;

    mapping(address => uint) public guestList;

    modifier ownerOnly {
        require(msg.sender == owner, "Authorization required");
        _;
    }

    modifier cost (uint _amount) {
        require(msg.value >= _amount, "Just a little higher amount required. 5 finney Required.");
        _;
    }

    modifier ifGuestListNotFull {
        require(count<maxCount, "Guest list full");
        _;
    }

    /*function isOwner() public view returns (bool){
        return msg.sender == owner;
    }*/

    constructor() {
        owner = msg.sender;
        currentStatus = guestListStatus.open;
    }

    function maximumCount(uint _maxCount) public {
        maxCount = _maxCount;
    }

    function ticketCostProvider (uint _ticketCost) public {
        ticketCost = _ticketCost;
    }

    function bookTicket() external payable ifGuestListNotFull cost(5 ether) {
        count++;
        guestList[msg.sender] = count;
        payable(owner).transfer(msg.value);
    }

}

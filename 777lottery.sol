pragma solidity ^0.8.11;

contract lottery {
    mapping(address => uint) public lotteryOwners;
    uint sold;
    uint lotteryPrice = 5;
    address owner;

    modifier cost() {
        require(msg.value >= lotteryPrice, "Not enough money");
        _;
    }

    modifier ticketsLeft {
        require(sold > 0, "The lottery is sold out.");
        _;
    }

    constructor(uint _sold){
        owner = msg.sender;
        sold = _sold;
    }

    function createTicket() internal returns (uint) {
        uint ticket = 900000 + sold;
        sold--;
        return ticket;
    }

    function getTicket() external payable ticketsLeft cost() {
        lotteryOwners[msg.sender] = createTicket();
    }
}

pragma solidity ^0.8.11;

contract lottery {
    //mapping(address => uint) public lotteryOwners;
    mapping(address => uint) public lotteryOwners;
    uint public ticketsLeft;
    uint totalTickets;
    uint lotteryPrice = 5;
    address owner;
    address payable public winner;

    modifier cost() {
        require(msg.value >= lotteryPrice, "Not enough money");
        _;
    }

    modifier ticketsReallyLeft {
        require(ticketsLeft > 0, "The lottery is sold out.");
        _;
    }

    modifier ownerOnly {
        require(msg.sender == owner, "The owner get to help in picking the owner");
        _;
    }

    modifier noTicketsLeft {
        require( ticketsLeft < 1, "Tickets still left");
        _;
    }

    constructor(uint _ticketsLeft){
        owner = msg.sender;
        ticketsLeft = _ticketsLeft;
        totalTickets = _ticketsLeft;

    }

    function createTicket() internal returns (uint) {
        uint256 ticket = 900000 + ticketsLeft;
        ticketsLeft--;
        return ticket;
    }

    function getTicket() external payable ticketsReallyLeft cost() {
        lotteryOwners[msg.sender] = createTicket();
    }

    function pickWinner() external payable ownerOnly noTicketsLeft {
        //Randomly pick a winner and put all the ether in their account
        winner = payable(0x583031D1113aD414F02576BD6afaBfb302140225);
        winner.transfer(address(this).balance);
    }

}

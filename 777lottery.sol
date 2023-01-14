pragma solidity 0.8.7;

contract lottery {
    //mapping(address => uint) public lotteryOwners;
    mapping(address => uint) public lotteryOwners;
    mapping(uint => address) checker;
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
        return ticket;
    }

    function getTicket() external payable ticketsReallyLeft cost() {
        lotteryOwners[msg.sender] = createTicket();
        checker[ticketsLeft] = msg.sender;
        ticketsLeft--;
    }

    function random() private view returns (uint) {
        uint randomHash = uint(keccak256(abi.encodePacked(block.difficulty, ticketsLeft)));
        return randomHash % totalTickets;
    }

    function pickWinner() external payable ownerOnly noTicketsLeft {
        //Randomly pick a winner and put all the ether in their account
        uint player = random();
        winner = payable(checker[player]);
        winner.transfer(address(this).balance);
    }

}

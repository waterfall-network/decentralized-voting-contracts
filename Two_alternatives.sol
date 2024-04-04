pragma solidity ^0.5.9;

contract SimpleVoting {

    struct Voter {
        bool voted;
        bool reg;
        uint8 vote1;
        uint8 vote2;       
    }
    struct Proposal {
        uint voteCount;
    }
   
    address chairperson;
    mapping(address => Voter) voters;
    uint numberVoted;
    Proposal[2] proposals;
    uint startTime;

    event Registrated(address newVoter);
    event HowVoted(address who, uint8 case1, uint case2, uint totalVoters);         


    constructor() public {
        chairperson = msg.sender;
        //startTime = now;        
    }

    function register(address toVoter) public {
        //require(
        //    msg.sender == chairperson,
        //    "Only the chairperson can give right to vote"
        //);
        require(
            !voters[toVoter].reg,
            "The voter was already registrated"
        );        
        //require(
        //     now < (startTime + 60 seconds),
        //     "The registration is closed"
        //);
        voters[toVoter].reg = true;        
        emit Registrated(toVoter);        
    }

    function vote(uint8 _voteCase1, uint8 _voteCase2) public {
        Voter storage sender = voters[msg.sender];                
        //require(
        //    now < (startTime + 300 seconds),
        //    "Voting is finished"
        //);
        require(!sender.voted, "Already voted");
        require(_voteCase1 <= 10, "The 1st value is greater than 10");
        require(_voteCase2 <= 10, "The 2nd value is greater than 10");
        sender.voted = true;
        sender.vote1 = _voteCase1;
        sender.vote2 = _voteCase2;
        proposals[0].voteCount += _voteCase1;
        proposals[1].voteCount += _voteCase2;
        ++numberVoted;
        emit HowVoted(msg.sender, _voteCase1, _voteCase2, numberVoted);        
    }

    function winningProposal() public view returns (uint8 _winningProposal) {
        //require(
        //    now > (startTime + 300 seconds),
        //    "Please, wait. Voting is NOT finished"
        //);
        if (proposals[0].voteCount < 3*numberVoted && proposals[1].voteCount < 3*numberVoted) return(100);
        if (proposals[0].voteCount == proposals[1].voteCount) return(200);        
        if (proposals[0].voteCount < proposals[1].voteCount) return(1);
        return(0);
    }

    function scoreProposal(uint8 prop) public view returns (uint256 scoreProposal_){
        //require(
        //    now > (startTime + 300 seconds),
        //    "Please, wait. Voting is NOT finished"
        //);    
        require(prop == 1 || prop == 2, "Value is out of range");
        scoreProposal_ = proposals[--prop].voteCount;
    }

}
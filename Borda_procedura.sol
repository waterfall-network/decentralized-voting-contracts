pragma solidity ^0.5.9;

contract BordaVoting {

    struct Voter {
        bool voted;
        bool reg;
        uint8[] vote;       
    }
    struct Proposal {
        uint256 voteCount;
        //bytes32 name;
    }
   
    address chairperson;
    mapping(address => Voter) voters;
    uint256 numberVoted;
    uint256 quorum;
    Proposal[] proposals;
    //uint startTime;    

    event Registrated(address newVoter);
    event HowVoted(address who, uint8[] result, uint256 totalVoters);
        

    constructor(uint8 _numProposals, uint256 _quorum) public {
        chairperson = msg.sender;
        proposals.length = _numProposals;
        quorum = _quorum;        
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
        //    now < (startTime + 60 seconds),
        //    "Registration is closed"
        //);
        voters[toVoter].reg = true;        
        emit Registrated(toVoter);        
    }

    // Exampe: [a,b,c] [a,b,c] [c,b,a] [b,c,a] --> b won with 5 points
    // Exampe: [1,2,3] [1,2,3] [3,2,1] [2,3,1] --> 2 won with 5 points
    function vote(uint8[] memory _voteCase) public {
        Voter storage sender = voters[msg.sender];                
        //require(
        //    now < (startTime + 300 seconds),
        //    "Voting is finished"
        //);
        require(!sender.voted, "Already voted");
        for (uint8 i = 0; i < proposals.length; ++i)
            require(1 <= _voteCase[i] && _voteCase[i] <= proposals.length, "Values are out of range");        
        bool[] memory count = new bool[](proposals.length);
        for (uint8 i = 0; i < proposals.length; ++i) {
            require(!count[_voteCase[i]-1], "There are duplicate values");
            count[_voteCase[i]-1] = true; 
        }
        sender.vote = _voteCase;    
        for (uint8 i = 0; i < proposals.length; ++i)            
            proposals[_voteCase[i]-1].voteCount += proposals.length - i - 1;       
        sender.voted = true;
        ++numberVoted;
        emit HowVoted(msg.sender, _voteCase, numberVoted);        
    }

    function winningProposal() public view returns (uint8 winningProposal_){
       //require(
        //    now > (startTime + 300 seconds),
        //    "Please, wait. Voting is NOT finished"
        //);
        require(
            numberVoted != 0,
            "Nobody voted"
        );
        require(
            numberVoted >= quorum,
            "There was no quorum"
        );        
        uint256 winningVoteCount;
        for (uint8 i = 0; i < proposals.length; ++i) {
            if (proposals[i].voteCount > winningVoteCount) {
                winningVoteCount = proposals[i].voteCount;
                winningProposal_ = i;
            }        
        }        
        ++winningProposal_;        
    }

    function scoreProposal(uint8 prop) public view returns (uint256 scoreProposal_){
        //require(
        //    now > (startTime + 300 seconds),
        //    "Please, wait. Voting is NOT finished"
        //);    
        require(1 <= prop && prop <= proposals.length, "Value is out of range");
        scoreProposal_ = proposals[--prop].voteCount;
    }

}
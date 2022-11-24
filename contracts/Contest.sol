pragma solidity >=0.5.16;

contract Contest {
    struct Contestant {
        uint256 id;
        string name;
        uint256 voteCount;
        string party;
        uint256 age;
        string qualification;
    }

    struct Voter {
        bool hasVoted;
        uint256 vote;
        bool isRegistered;
    }

    address admin;
    mapping(uint256 => Contestant) public contestants;
    // mapping(address => bool) public voters;
    mapping(address => Voter) public voters;
    uint256 public contestantsCount;
    // uint public counter;
    enum PHASE {
        reg,
        voting,
        done
    }
    PHASE public state;

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    modifier validState(PHASE x) {
        require(state == x);
        _;
    }

    constructor() public {
        admin = msg.sender;
        state = PHASE.reg;
        // counter = 0;
    }

    function changeState(PHASE x) public onlyAdmin {
        require(x > state);
        state = x;
    }

    function addContestant(
        string memory _name,
        string memory _party,
        uint256 _age,
        string memory _qualification
    ) public onlyAdmin validState(PHASE.reg) {
        contestantsCount++;
        contestants[contestantsCount] = Contestant(
            contestantsCount,
            _name,
            0,
            _party,
            _age,
            _qualification
        );
    }

    function voterRegisteration(address user)
        public
        onlyAdmin
        validState(PHASE.reg)
    {
        voters[user].isRegistered = true;
    }

    function vote(uint256 _contestantId) public validState(PHASE.voting) {
        require(voters[msg.sender].isRegistered);
        require(!voters[msg.sender].hasVoted);
        require(_contestantId > 0 && _contestantId <= contestantsCount);
        contestants[_contestantId].voteCount++;
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].vote = _contestantId;
    }
}

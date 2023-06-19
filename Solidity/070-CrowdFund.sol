// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

contract CrowdFund {
    event Launch(
        uint id,
        address indexed creator,
        uint goal,
        uint32 startAt,
        uint32 endAt
    );
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint id, address indexed caller, uint amount);

    struct Campaign {
        // Creator of campaign
        address creator;
        // Amount of tokens to raise
        uint goal;
        // Total amount pledged
        uint pledged;
        // Timestamp of start of campaign
        uint32 startAt;
        // Timestamp of end of campaign
        uint32 endAt;
        // True if goal was reached and creator has claimed the tokens.
        bool claimed;
    }

    IERC20 public immutable token;
    // Total count of campaigns created.
    // It is also used to generate id for new campaigns.
    uint public count;
    // Mapping from id to Campaign
    mapping(uint => Campaign) public campaigns;
    // Mapping from campaign id => pledger => amount pledged
    mapping(uint => mapping(address => uint)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    modifier mustBeActive(uint _id) {
        require(block.timestamp >= campaigns[_id].startAt, "not started");
        require(block.timestamp < campaigns[_id].endAt, "already ended");
        _;
    }

    function launch(uint _goal, uint32 _startAt, uint32 _endAt) external {
        // code
        require(_startAt >= block.timestamp, "invalid startAt");
        require(_endAt > _startAt, "invalid endAt");
        require(_endAt <= block.timestamp + 90 days, "too big endAt");
        
        count++;
        
        Campaign storage campaign = campaigns[count];
        campaign.creator = msg.sender;
        campaign.goal = _goal;
        campaign.startAt = _startAt;
        campaign.endAt = _endAt;
        
        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external {
        // code
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp < campaign.startAt, "already started");
        
        delete campaigns[_id];
        
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external mustBeActive(_id) {
        // code
        token.transferFrom(msg.sender, address(this), _amount);
        
        campaigns[_id].pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        
        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external mustBeActive(_id) {
        require(pledgedAmount[_id][msg.sender] >= _amount, "not enough pledged");
        
        // code
        unchecked {
            campaigns[_id].pledged -= _amount;
            pledgedAmount[_id][msg.sender] -= _amount;    
        }
        
        token.transfer(msg.sender, _amount);
        
        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        // code
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended yet");
        require(msg.sender == campaign.creator, "not creator");
        require(campaign.pledged >= campaign.goal, "not reached the goal");
        require(!campaign.claimed, "already claimed");
        
        campaigns[_id].claimed = true;
        
        token.transfer(campaign.creator, campaign.pledged);
        
        emit Claim(_id);
    }

    function refund(uint _id) external {
        // code
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended yet");
        require(campaign.pledged < campaign.goal, "reached the goal");
        
        uint amount = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        
        token.transfer(msg.sender, amount);
        
        emit Refund(_id, msg.sender, amount);
    }
}
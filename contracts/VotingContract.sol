// SPDX-License-Identifier: MIT

pragma solidity ^0.8.27;

import "./VotingLibrary.sol";

contract VotingContract {
using VoteLibrary for *;

struct Candidate{
string name ;
uint256 votesCounted ;
}

struct Election {
bytes32 title;
bytes32 description;
uint256 totalVotes ;
}

mapping(bytes32 =>Candidate[]) candidates;
mapping(bytes32 =>Election)public elections ;

address[] public voters;

event VoteCast(address indexed voter, string memory title , bytes memory description);
event ElectionCreated(string indexed hash, string _title, string _memory_description);

bytes32 public electionId;

function createElection(string memory _title, string memory _description)
external
returns (string memory )
{
bytes32 hash = keccak256(abi.encodePacked(_title,_description));
elections[hash] = Election({

title:keccak256(abi.encodePacked(_title)),
description :keccak256(abi.encodePacked(_description)),
totalVotes:0})
;
emit ElectionCreated(hash,_title, _description);
return hash ;
}

function castVote(string memory candidateName) external {
require(elections[electionId].totalVotes == 0 || voters[msg.sender] == false,"Invalid operation");
require(bytes(candidateName).length > 0 ,"Candidate name cannot be empty");

Election storage election = elections[electionId];
candidates[electionId][candidateName]= Candidate({name: candidateName,votesCounted :1});

}

function getCandidates(string memory _electionID) public view returns (Candidate[]memory){
return candidates[_electionID];
}

function getTotalVotes()public view returns(uint256){

return elections[electionId].totalVotes ;
}

function getWinner()public view returns(bytes32){

Candidate[] memory candidateArray = getCandidates();
bytes32 winnerHash= VoteLibrary.calculateWinner(candidateArray).name ;
return keccak256(abi.encodePacked(winnerHash));
}
}
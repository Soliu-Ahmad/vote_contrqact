// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

library VoteLibrary {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    function addVote(Candidate memory self) internal pure {
        self.voteCount += 1;
    }

    function calculateWinner(Candidate[] memory candidates)
        internal
        pure
        returns (Candidate memory)
    {
        Candidate memory maxCandidate = candidates[0];
        for (uint i = 1; i < candidates.length; i++) {
            if (candidates[i].voteCount > maxCandidate.voteCount) {
                maxCandidate = candidates[i];
            }
        }
        return maxCandidate;
    }
}

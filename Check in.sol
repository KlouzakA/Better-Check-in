// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Check_in {
    // Mapping to store user data (e.g., check-in count)
    mapping(address => uint256) public userCheckIns;
    
    event CheckedIn(address indexed user, uint256 timestamp);

    function _getDailyResetPoint() view internal returns (uint256) {
        return block.timestamp / 86400 * 86400; // calculate daily reset point in seconds
    }

    function checkIn() external {
        require(userCheckIns[msg.sender] == 0); // ensure user hasn't checked in today
        
        uint256 currentResetPoint = _getDailyResetPoint();
        
        if (block.timestamp < currentResetPoint + 86400) { 
            revert("Cannot re-check-in before daily reset point"); 
        }
        
        require(block.timestamp >= currentResetPoint);
        
        // Reset user's check-ins for the day
        delete userCheckIns[msg.sender];
        
        emit CheckedIn(msg.sender, block.timestamp);

        userCheckIns[msg.sender] = 1; // mark as checked in today
        
    }
}
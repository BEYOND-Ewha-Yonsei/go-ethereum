pragma solidity 0.5.16;

contract teamBeyond {
  string internal constant seeWhoWeAre = "We are Team BEYOND!";
  string internal chainResult;

  function beyond(string memory _chainResult) public {
    chainResult = _chainResult;
  }

  function showWhoWeAre() external pure returns (string memory) {
    return seeWhoWeAre;
  }

  function cleaner(string calldata _chainEntry) external view returns (string memory) {
// completely disregard the _chainEntry
    return chainResult;
  }
}
pragma solidity ^0.4.18;

contract NeverSatisfy{

	function() public { 
		neverSatisfy();
	}

	function neverSatisfy() internal{
		require(2!=2);
	}
}
pragma solidity ^0.4.18;

contract Storage{

	uint x;
	address addr;
	bytes bts;

	function setUint(uint _x) public {
		x = _x;
	}

	function setAddr(address _addr) public {
		addr = _addr;
	}

	function setUintAndAddr(uint _x, address _addr) public {
		addr = _addr;
		x = _x;
	}


	function setBytes(bytes _bts) public {
		bts = _bts;
	}


	function getUint() public view returns(uint){
		return x;
	}

	function getAddr() public view returns(address){
		return addr;
	}

	function getBytes() public view returns(bytes){
		return bts;
	}
}
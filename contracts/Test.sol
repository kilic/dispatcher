


contract Test{

	bool public success;

	function fwd(address dest, bytes calldata) public{
	
		bool _success;
		assembly{
			_success := call(sub(gas,5000),
				dest,
				0,
				add(calldata,0x20),
				mload(calldata),
				0,0)
		}
		success = _success;
	}
}
pragma solidity ^0.4.18;

import "./BytesOp.sol";

contract Dispatcher is BytesOp{

	/*
	@param _data Concantated array of call elements. 
	An element should consist of a destinationaddress,
	an input and the length of the input
	@param _mayRollback Rollback all changes if any call fails.
	@dev Data should be serialized as
	(destinationAddr0 + inputLen0 + input0 +
	destinationAddr1 + inputLen1 + input1 + .. )
 	*/

	function forwardBatch(bytes _data, bool _mayRollback) public {
	
		uint ptr = dataPtr(_data);
		uint end = ptr + _data.length;
		forwardBatch(ptr, end, _mayRollback,0);
	}


	function forwardBatch(uint ptr, uint end, bool mayRollback, uint8 callIndex) internal {
	
		bytes memory calldata;
		address dest;
		(dest, calldata) = deserialize(ptr);
		//require(isContract(dest))
		bool success = fwd(dest, calldata);
		if(mayRollback && !success){
			revert(); // revert(callIndex);
		} 
		ptr += ADDRESS_SIZE + WORD_SIZE + calldata.length;
		if(end > ptr){
			forwardBatch(ptr, end, mayRollback, callIndex + 1);
		}
	}


	function deserialize(uint ptr) internal pure returns(address dest,bytes memory calldata){
	
		dest = toAddress(ptr);
		uint calldatalen = toUint(ADDRESS_SIZE + ptr);
		calldata = toBytes((ADDRESS_SIZE + WORD_SIZE + ptr), calldatalen);
	}


	function fwd(address dest, bytes calldata) internal returns(bool success){
	
		assembly{
			success := call(sub(gas,5000),
				dest,
				0,
				add(calldata,0x20),
				mload(calldata),
				0,0)
		}
	}


	function isContract(address _target) internal view returns (bool) {
	
		uint256 size;
		assembly { size := extcodesize(_target) }
		return size > 0;
	}


	function forwardBatchStraightforward(bytes _data, bool _rollback) public {

		uint ptr = dataPtr(_data);
		uint end = ptr + _data.length;
		bool success = false;
		while(end > ptr){

			address dest = toAddress(ptr);
			//require(isContract(dest))
			uint calldatalen = toUint(ADDRESS_SIZE + ptr);
			bytes memory calldata = toBytes((ADDRESS_SIZE + WORD_SIZE + ptr), calldatalen);
			ptr += ADDRESS_SIZE + WORD_SIZE + calldatalen;
			assembly{
				success := call(sub(gas, 5000),
					dest,
					0,
					add(calldata, 0x20),
					mload(calldata),
					0,0)
			}
			//Log(success,dest,calldata);
			if(_rollback){
				require(success);
			}
		}
	}
}

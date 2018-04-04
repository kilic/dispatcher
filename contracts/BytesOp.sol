pragma solidity ^0.4.18;

contract BytesOp{

    /*
    https://github.com/ethereum/solidity-examples
    */

	uint internal constant WORD_SIZE = 32;
    uint internal constant ADDRESS_SIZE = 20;


    function dataPtr(bytes memory bts) internal pure returns (uint addr) {
        
        assembly {
            addr := add(bts, 0x20)
        }
    }


    function copy(uint src, uint dest, uint len) internal pure {
        
        for (; len >= WORD_SIZE; len -= WORD_SIZE) {
            assembly {
                mstore(dest, mload(src))
            }
            dest += WORD_SIZE;
            src += WORD_SIZE;
        }

        uint mask = 256 ** (WORD_SIZE - len) - 1;
        assembly {
            let srcpart := and(mload(src), not(mask))
            let destpart := and(mload(dest), mask)
            mstore(dest, or(destpart, srcpart))
        }
    }


    function toBytes(uint addr, uint len) internal pure returns (bytes memory bts) {
        
        bts = new bytes(len);
        uint btsptr;
        assembly {
            btsptr := add(bts, 0x20)
        }
        copy(addr, btsptr, len);
    }


    function toUint(uint addr) internal pure returns (uint n) {
        
        assembly {
            n := mload(addr)
        }
    }


    function toAddress(uint addr) internal pure returns (address res){

        assembly{
            let word := mload(addr)
            res := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
            0x1000000000000000000000000)
        }
    }


    function bytesAt(bytes _data, uint offset, uint len) internal pure returns(bytes memory bts){

        uint ptr = dataPtr(_data) + offset;
        bts = toBytes(ptr,len);
    }


    function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {

        assembly {
            result := mload(add(_data, add(0x20, _location)))
        }
    }


    function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {

        uint256 word = uint256At(_data, _location);
        assembly {
            result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
            0x1000000000000000000000000)
        }
    }

    /*function toAddress(uint addr) internal pure returns (address){

        assembly{
            return(addr,0x14)
        }
    }*/

}

pragma ton-solidity >=0.43.0;

pragma AbiHeader expire;
pragma AbiHeader  time;

import "./IERC721Enumerable.sol";
import "./ERC721.sol";

contract ERC721Enumerable is ERC721, IERC721Enumerable {

    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    mapping(uint256 => uint256) private _ownedTokensIndex;

    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;

    constructor(string _name, string _symbol) ERC721(_name, _symbol) public {
        tvm.accept();
    }

    function totalSupply() public view override returns(uint256) {
        return _allTokens.length;
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns(uint256 tokenId) {
        require(index < balanceOf(owner));
        return _ownedTokens[owner][index];
    }

    function tokenByIndex(uint256 index) public view override returns(uint256) {
        require(index < _allTokens.length);
        return _allTokensIndex[index];
    }

}
pragma ton-solidity >=0.43.0;

pragma AbiHeader expire;
pragma AbiHeader  time;

import "./interfaces/IERC721Enumerable.sol";
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

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) internal {
        uint256 length = balanceOf(to);
        _ownedTokens[to][length];
        _ownedTokensIndex[tokenId] = length;
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) internal {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) internal {

        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;
        }

        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) internal {
        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId;
        _allTokensIndex[lastTokenId] = tokenIndex;

        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }

}
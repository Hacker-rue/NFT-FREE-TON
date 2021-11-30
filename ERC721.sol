pragma ton-solidity >=0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import "./interfaces/IERC721.sol";

contract ERC721 is IERC721 {

    string private _name;

    string private _symbol;

    //Владелец токена
    mapping(uint256 => address) private _owners;

    //Количество токенов адреса
    mapping(address => uint256) private _balances;

    //Адрес которому можно управлять токеном
    mapping(uint256 => address) private _tokenApprovals;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string name, string symbol) public {
        tvm.accept();
        _name = name;
        _symbol = symbol;
    }


    function getName() public view returns(string) {
        return _name;
    }

    function getSymbol() public view returns(string) {
        return _symbol;
    }

    function balanceOf(address owner) public view override returns(uint256) {
        require(!address(owner).isStdZero());
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view override returns(address) {
        address owner = _owners[tokenId];
        require(!address(owner).isStdZero());
        return owner;
    }

    function approve(address to, uint256 tokenId) public override {
        address owner = ownerOf(tokenId);
        require(owner != to);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
        _approve(to, tokenId);
    }

    function getApproved(uint256 tokenId) public view override returns(address) {
        require(_exists(tokenId));
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address operator, bool approved) public override {
        require(msg.sender != operator);
        require(!address(operator).isStdZero());
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public view override returns(bool) {
        return _operatorApprovals[owner][operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        require(_isApprovedOrOwner(msg.sender, tokenId));
        _transfer(from, to, tokenId);
    }



    

    //internal function

    function _approve(address to, uint256 tokenId) internal {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        return !address(_owners[tokenId]).isStdZero();
    }

    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId));
        address owner = ownerOf(tokenId);
        return (spender == owner || spender == getApproved(tokenId) || isApprovedForAll(owner, spender));
    }

    function _transfer(address from, address to, uint256 tokenId) private {
        require(from == ownerOf(tokenId));
        require(!address(to).isStdZero());
        _approve(address(0), tokenId);

        _beforeTokenTransfer(from, to, tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    function _mint(address to, uint256 tokenId) internal {
        require(!address(to).isStdZero());
        require(!_exists(tokenId));

        _balances[to] +=1;
        _owners[tokenId] = to;

        _beforeTokenTransfer(address(0), to, tokenId);

        emit Transfer(address(0), to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {

    }


}
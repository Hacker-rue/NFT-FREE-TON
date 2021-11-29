pragma ton-solidity >= 0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import "./ERC721Enumerable.sol";

contract NFTColection is ERC721Enumerable {



    string public baseURI;
    string baseExtension = ".png";
    uint128 private cost;
    uint256 private maxSupply;
    bool private paused = false;
    bool public isMintUser = false;
    address Radiance;
    address authorColection;
    address ownerColection;


    modifier onlyOwner() {
        require(msg.sender == ownerColection);
        _;
    }


    constructor(string name, string symbol, string _baseURI, string _baseExtension, 
    uint256 _maxSupply, uint128 _cost, address author, address radiance) ERC721Enumerable(name, symbol) public {
        baseURI = _baseURI;
        baseExtension = _baseExtension;
        maxSupply = _maxSupply;
        cost = _cost;
        authorColection = author;
        ownerColection = author;
        Radiance = radiance;
    }

    function mint(address _to) public {
        uint256 supply = totalSupply();
        require(!paused);
        require(supply + 1 <= maxSupply);

        if(isMintUser) {
            if(msg.sender != ownerColection) {
                require(msg.value >= cost + 0.1 ton);
                ownerColection.transfer(cost);
                Radiance.transfer(0.1 ton);
            }
        }

        _mint(_to, supply + 1);
    }

    function getTokenURI(uint256 tokenId) public view returns(string, uint256, string) {
        require(_exists(tokenId));
        return (baseURI, tokenId,baseExtension);
    }

    function getBaseURI() public view returns(string) {
        return baseURI;
    }

    function setCost(uint128 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setBaseURI(string _newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    function setColectionOwner(address _newColectionOwner) public onlyOwner {
        ownerColection = _newColectionOwner;
    }

    function setBaseExtension(string _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function setPaused(bool _status) public onlyOwner {
        paused = _status;
    }

    function setMintUser(bool _status) public onlyOwner {
        isMintUser = _status;
    }

    function newOwner(address newOwner) public onlyOwner {
        require(!address(newOwner).isStdZero())
        ownerColection = newOwner;
    }



    


    


}
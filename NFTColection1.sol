pragma ton-solidity >= 0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

import "./ERC721Enumerable.sol";

contract NFTColection is ERC721Enumerable {

    event buyTransfer(address from, address to, uint256 tokenId, uint128 cost);

    struct metadataToken {
        string name;
        string description;
        string dna;
        uint256 data;
    }

    struct attribute {
        string traitType;
        string value;
        uint8 rare; //редкость
    }

    struct offer {
        uint256 tokenId;
        uint128 cost;
        bool active;
    }


    string public baseURI;
    string baseExtension = ".png";
    uint128 private cost;
    uint256 public maxSupply;
    bool public paused = false;
    bool public isMintUser = false;
    address radiance;
    address authorColection;
    address ownerColection;

    mapping(uint256 => metadataToken) private metadataTokens;
    mapping(uint256 => attribute[]) private tokenAttributes;

    offer[] private offerSaleTokens;


    modifier onlyOwner() {
        require(msg.sender == ownerColection);
        _;
    }


    constructor(string name, string symbol, string _baseURI, string _baseExtension, 
    uint256 _maxSupply, uint128 _cost, address author, address _radiance) ERC721Enumerable(name, symbol) public {
        baseURI = _baseURI;
        baseExtension = _baseExtension;
        maxSupply = _maxSupply;
        cost = _cost;
        authorColection = author;
        ownerColection = author;
        radiance = _radiance;
    }

    function mint(address _to, string name, string description, string dna, 
    attribute[] attributes) public {
        uint256 supply = totalSupply();
        require(!paused);
        require(supply + 1 <= maxSupply);

        if(isMintUser) {
            if(msg.sender != ownerColection) {
                require(msg.value >= cost + 0.1 ton);
                ownerColection.transfer(cost);
                radiance.transfer(0.1 ton);
            }
        }

        metadataToken newMetadataToken = metadataToken(name, description, dna, tx.timestamp);
        metadataTokens[supply + 1] = newMetadataToken;
        tokenAttributes[supply + 1] = attributes;
        offerSaleTokens.push(offer(supply + 1, 0, false));

        _mint(_to, supply + 1);
    }

    function buyToken(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        offer _offer = offerSaleTokens[tokenId - 1];
        require(_offer.active);

        require(msg.value >= _offer.cost + 0.2 ton);

        authorColection.transfer(msg.value / 100 * 5);
        radiance.transfer(msg.value / 100 * 5);

        owner.transfer(msg.value / 100 * 90);

        _transfer(owner, msg.sender, tokenId);

        offerSaleTokens[tokenId - 1].active = false;
        emit buyTransfer(owner, msg.sender, tokenId, _offer.cost);
        

    }

    function getMetadataToken(uint256 tokenId) public view returns(metadataToken) {
        require(_exists(tokenId));
        return metadataTokens[tokenId];
    }

    function getTokenAttributes(uint256 tokenId) public view returns(attribute[]) {
        require(_exists(tokenId));
        return tokenAttributes[tokenId];
    }

    function getTokenURI(uint256 tokenId) public view returns(string, uint256, string) {
        require(_exists(tokenId));
        return (baseURI, tokenId, baseExtension);
    }

    function getOfferSaleTokens() public view returns(offer[]) {
        return offerSaleTokens;
    }

    function getOggerSaleToken(uint256 tokenId) public view returns(offer) {
        require(_exists(tokenId));
        return offerSaleTokens[tokenId -1];
    }

    function getBaseURI() public view returns(string) {
        return baseURI;
    }

    function setOfferSaleToken(uint256 tokenId, uint128 cost, bool _status) public {
        require(_isApprovedOrOwner(msg.sender, tokenId));

        offerSaleTokens[tokenId -1].cost = cost;
        offerSaleTokens[tokenId -1].active = _status;

        _approve(address(0), tokenId);
    }

    function setCost(uint128 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setBaseURI(string _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
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

    function newOwner(address _newOwner) public onlyOwner {
        require(!address(_newOwner).isStdZero());
        ownerColection = _newOwner;
    }



    


    


}
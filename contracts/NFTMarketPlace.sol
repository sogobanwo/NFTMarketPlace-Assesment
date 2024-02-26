// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {
    uint count;

    struct NFT {
        uint256 id;
        address owner;
        string yourNFTUrl;
        uint256 amount;
        bool isAvailableForSale;
    }

    mapping(uint256 => NFT) public NFTs;
    mapping(address => bool) public canUserMint;

    constructor() ERC721("NFT", "NFT") {}

    modifier canMint() {
        require(canUserMint[msg.sender], "You can't Mint");
        _;
    }

    function addMinter(address _userToMint) external {
        require(_userToMint != address(0), "Address zero Detected");
        canUserMint[_userToMint] = true;
    }

    function removeMinter(address _userToMint) external {
        require(_userToMint != address(0), "Invalid userToMint address");
        canUserMint[_userToMint] = false;
    }

    function mintNFT(string memory _yourNFTUrl, uint256 _amount) external canMint {
        uint _id = count + 1;
        uint256 newNFTId = _id;
        _mint(msg.sender, newNFTId);

        NFT memory newNFT = NFT({
            id: newNFTId,
            owner: msg.sender,
            yourNFTUrl: _yourNFTUrl,
            amount: _amount,
            isAvailableForSale: false
        });

        NFTs[newNFTId] = newNFT;
        count ++;
    }

    function buyNFT(uint256 _tokenId) external payable {
        NFT storage nft = NFTs[_tokenId];
        require(nft.isAvailableForSale == true, "not for sale");
        require(msg.value >= nft.amount, "you lack funds funds");

        address payable seller = payable(ownerOf(_tokenId));
        seller.transfer(msg.value);

        _transfer(seller, msg.sender, _tokenId);
        nft.isAvailableForSale = false;
    }

    function sellNFT(uint256 _tokenId, uint256 _amount) external {
        require(ownerOf(_tokenId) == msg.sender, "This is not your NFT");

        NFT storage nft = NFTs[_tokenId];
        require(!nft.isAvailableForSale, "NFT is already for sale");

        nft.amount = _amount;
        nft.isAvailableForSale = true;
    }

    function getNFT(uint256 _tokenId) external view returns (uint256, address, string memory, uint256, bool) {
        NFT memory nft = NFTs[_tokenId];
        return (nft.id, nft.owner, nft.yourNFTUrl, nft.amount, nft.isAvailableForSale);
    }
}

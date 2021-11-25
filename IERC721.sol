pragma ton-solidity >=0.43.0;

pragma AbiHeader expire;
pragma AbiHeader time;

interface IERC721 {

    //Emitted when `tokenId` token is transferred from `from` to `to`.
    event Transfer(address from, address to, uint256 tokenId);

    //Emitted when `owner` enables `approved` to manage the `tokenId` token.
    event Approval(address owner, address approved, uint256 tokenId);

    //Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
    event ApprovalForAll(address owner, address operator, bool approved);

    //Returns the number of tokens in ``owner``'s account.
    function balanceOf(address owner) external view returns(uint256 balance);

    //Returns the owner of the `tokenId` token.
    function ownerOf(uint256 tokenId) external view returns(address owner);

    //Transfers `tokenId` token from `from` to `to`.
    //Emits a {Transfer} event.
    function transferFrom(address from, address to, uint256 tokenId) external;

    //Gives permission to `to` to transfer `tokenId` token to another account.
    //The approval is cleared when the token is transferred.
    //Emits an {Approval} event.
    function approve(address to, uint256 tokenId) external;

    //Returns the account approved for `tokenId` token.
    function getApproved(uint256 tokenId) external view returns (address operator);

    //Approve or remove `operator` as an operator for the caller.
    //Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
    //Emits an {ApprovalForAll} event.
    function setApprovalForAll(address operator, bool _approved) external;

    //Returns if the `operator` is allowed to manage all of the assets of `owner`.
    //See {setApprovalForAll}
    function isApprovedForAll(address owner, address operator) external view returns (bool);

}
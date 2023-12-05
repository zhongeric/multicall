interface IMockMulticallableContract {
    error CustomError();
    error CustomErrorWithString(string reason);
    error CustomErrorWithBytes(bytes reason);
    error CustomErrorWithUint(uint256 reason);
    error CustomErrorWithTwoPrimitives(uint256 reason1, bool reason2);
}

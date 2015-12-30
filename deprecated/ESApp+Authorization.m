///=============================================
/// @name Authorization
///=============================================

/**
 * Request `AddressBook` authorization if needed. `completion` and `failure` will callback on the main thread.
 */
- (void)requestAddressBookAccessWithCompletion:(dispatch_block_t)completion failure:(dispatch_block_t)failure
{
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        if (kABAuthorizationStatusAuthorized == status) {
                if (completion)
                        ESDispatchOnMainThreadAsynchrony(completion);

        } else if (kABAuthorizationStatusNotDetermined == status) {
                ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                        if (addressBook) {
                                CFRelease(addressBook);
                        }
                        if (granted) {
                                if (completion) ESDispatchOnMainThreadAsynchrony(completion);
                        } else {
                                if (failure) ESDispatchOnMainThreadAsynchrony(failure);
                        }
                });
        } else {
                if (failure)
                        ESDispatchOnMainThreadAsynchrony(failure);
        }
}



/**
 * @"camelCase" to @"camel<replace>case"
 * @"CamelCase" to @"camel<replace>case"
 *
 * It will convert all "\W" to "_", and replace Uppercase to "_"+lowercase.
 */
- (NSString *)stringByReplacingCamelcaseWith:(NSString *)replace
{
        NSString *string = [self stringByReplacingRegex:@"\\W" with:@"_" caseInsensitive:YES];
        NSMutableString *result = [NSMutableString string];
        for (NSUInteger i = 0; i < string.length; i++) {
                NSString *aChar = [string substringWithRange:NSMakeRange(i, 1)];
                if (![aChar isEqualToString:@"_"] && [aChar isEqualToString:[aChar uppercaseString]]) {
                        if (i == 0) {
                                [result appendString:[aChar lowercaseString]];
                        } else {
                                [result appendFormat:@"%@%@", replace, [aChar lowercaseString]];
                        }
                } else {
                        [result appendString:[aChar lowercaseString]];
                }
        }
        return result;
}

/**
 * @"camelCase" to @"camel_case"
 * @"CamelCase" to @"camel_case"
 *
 * @see -stringByReplacingCamelcaseWith:
 */
- (NSString *)stringByReplacingCamelcaseWithUnderscore
{
        return [self stringByReplacingCamelcaseWith:@"_"];
}

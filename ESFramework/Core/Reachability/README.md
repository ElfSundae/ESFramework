Reachability
============

Mirror repository of DDG's Reachability.
http://blog.ddg.com/?p=24

Version: 2.0.4ddg


* Convert to ARC
* Support ObjC Modules

Usage
-------------
```
 [self setNetworkReachabilityChangedHandler:^(Reachability *reachability, NetworkStatus currentNetworkStatus) {
                NSLog(@"status: %d, %@", currentNetworkStatus, [UIDevice currentNetworkStatusString]);
 }];
```
jsonController
==============

ios json controller class

How to use
==============

1. with delegate


  implement URLRequestDelegate in .h file

  run query in .m file:
  
  
  URLRequest *request = [[URLRequest alloc] initWithRequest:[URLRequest getData]];
  
  [request startWithDelegate:self];


  implement delegate functions:
  
  
  @optional -(void)requestFinished:(id)request withData:(NSMutableDictionary *)data;

  @optional -(void)requestFailed:(id)request withError:(NSError *)error;

  @optional -(void)requestShouldStart:(id)request;

  
2. with block


  run query in .m file:
  
  
  URLRequest *request = [[URLRequest alloc] initWithRequest:[URLRequest getVersion]];
  
  [request startWithCompletion:^(URLRequest *request, NSMutableDictionary* result, NSError *error) {
  
    //do something
    
  }
  



3. without callback

  run query in .m file:
  
  
  [request startWithNoCallback];
  

URLRequest properties
==============

@property (nonatomic, readonly) NSData *rawData;

if you don't need json structure you can use rawData property to get the raw data from the response


@property (readonly) int httpStatusCode;

show the http status code, what the server gives

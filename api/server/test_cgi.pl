print &get_response("./json_api.pl", "request=GetVariables");

sub get_response {
  my ($cgi, $CMD) = shift;
 
  ## prepare proper (CGI) environment
  $ENV{QUERY_STRING} = $CMD;
  $ENV{REQUEST_METHOD} = 'GET';
  $ENV{GATEWAY_INTERFACE} = 'CGI/1.1';
  # add more as needed
  open(CGI, "$cgi |") or die "Can't exec $cgi, $!";
  local $/ = undef;
  my $res = <CGI>;
  close(CGI) or die "Error running $cgi, $!";
  return $res;
}

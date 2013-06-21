#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;

# Proxy Setting
# $ENV{HTTPS_PROXY} = 'proxy-ip:8080'; # For Crypt::SSLeay
# $ENV{HTTPS_PROXY_USERNAME} = 'user';
# $ENV{HTTPS_PROXY_PASSWORD} = 'pass';

my $ua = new LWP::UserAgent;
my $req = new HTTP::Request('GET', 'https://www.example.com/');
my $res = $ua->request($req);
my $content = $res->content;
my $code = $res->code;

print "$content\n\n";
print "$code\n";

__END__

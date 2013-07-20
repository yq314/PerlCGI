#!/usr/local/bin/perl

############################################################################
#
# authoer: Qing YE
# email: 2chin.yip@gmail.com
# date: 17 JUL 2013
#
# NOTE: This script requires libwww-perl to run, install by run: 
#       perl -MCPAN -e 'install Bundle::LWP'    
#
# Function: This is a CGI client doing 3 jobs:
#           1. Encrypt a passphrase using the RSA public key
#           2. Send the encrypted passphrase along with a number to server
#           3. Read the response from server and print Fibonacci's series   
#
############################################################################

use LWP::UserAgent;
use Crypt::RSA;

#---------------------------
# pre defined variables
#---------------------------
my $url = 'http://localhost/cgi-bin/server.pl';
my $public_key = 'rsa_key.public';
my $passphrase = 'This is a passphrase';

#---------------------------
# functions defination
#---------------------------
sub post_to_server{
    my $ua = new LWP::UserAgent;
    my $res = $ua->post($_[0], $_[1]);
    
    return $res->content;
}

sub encrypt_msg{
    my $rsa = new Crypt::RSA;
    my $key = new Crypt::RSA::Key::Public;
    my $key_file = $key->read(Filename => $_[1]);
 
    my $encrypted = $rsa->encrypt (
        Message => $_[0],
        Key     => $key_file
    ) or die $rsa->errstr();
    
    return $encrypted;
}

sub get_nth_fibonacci{
    my $n = $_[0];
    my ($first, $second) = (0, 1);
    my $result = 0;
    
    if ($n < 2) {
        return $n;
    }
    
    for (my $i = 2; $i <= $n; $i++) {
        $result = $first + $second;
        $first = $second;
        $second = $result;
    }
    
    return $result;
}

#---------------------------
# main job starts from here
#---------------------------
my $message = &encrypt_msg($passphrase, $public_key);
srand;
my $n = int(rand(9999) + 1); # a random number between 1 and 10000

print "Sending message encrypted with '$public_key' and ",
    "number $n to server...\n";

my $nth_primer = &post_to_server($url, {message=>$message, number=>$n});
print "Server returns the ${n}th primer number: $nth_primer.\n";

print "The ${nth_primer} term of the Fibonacci's series is: ";
print &get_nth_fibonacci($nth_primer), ".\n";

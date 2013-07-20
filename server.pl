#!/usr/local/bin/perl

############################################################################
#
# authoer: Qing YE
# email: 2chin.yip@gmail.com
# date: 17 JUL 2013  
#
# Function: This is a CGI server doing 2 jobs:
#           1. Read the encrypted passphrase posted from client and decrypt
#              it using the RSA private key
#           2. Read the number posted from server and return the Nth prime
#              number 
#
############################################################################

use CGI;
use Crypt::RSA;

#---------------------------
# pre defined variables
#---------------------------
my $private_key = 'rsa_key.private';
my $passphrase = 'This is a passphrase';

#---------------------------
# functions defination
#---------------------------
sub decrypt_msg{
    my $rsa = new Crypt::RSA;
    my $key = new Crypt::RSA::Key::Private;
    my $key_file = $key->read(Filename => $_[1]);

    my $decrypted = $rsa->decrypt (
        Cyphertext => $_[0],
        Key     => $key_file
    ) or die $rsa->errstr();
    
    return $decrypted;
}

sub get_nth_primer{
    my $n = $_[0];
    my @primes = (2, 3);
    
    my $i = 5;
    for ($cnt = 2; $cnt <= $n; $i += 2) {
        my $flag = 1;
        for ($j = 1; @primes[$j] * @primes[$j] <= $i; ++$j) {
            if ($i % @primes[$j] == 0) {
                $flag = 0;
                break;    
            }    
        }
        
        if ($flag) {
            @primes[$cnt] = $i;
            ++$cnt;    
        } 
    }
    
    return @primes[$n - 1];
}

#---------------------------
# main job starts from here
#---------------------------
my $cgi = new CGI;
print $cgi->header;

if ($cgi->param('message') && $cgi->param('number')){
    my $passphrase = &decrypt_msg($cgi->param('message'), $private_key);
    if(!$passphrase){
        die "Decryption unsuccessfully.\n";   
    }
    
    print &get_nth_primer($cgi->param('number'));
    
} else {
    print "Sorry, no data recieved.\n";
}
#!/usr/local/bin/perl

############################################################################
#
# authoer: Qing YE
# email: 2chin.yip@gmail.com
# date: 17 JUL 2013  
#
# Function: This script is a RSA public/private key pair generator  
#
############################################################################

use Crypt::RSA;

use constant {
    DEFAULT_IDENTITY  => 'Qing YE <2chin.yip@gmail.com>',
    DEFAULT_KEY_FILE  => "$ENV{'PWD'}/rsa_key",
    DEFAULT_KEY_SIZE  => 512,
    DEFAULT_VERBOSITY => 1
};

my $rsa = new Crypt::RSA;

print "Enter file in which to save the key (", DEFAULT_KEY_FILE, "):";
chomp (my $key_file = <STDIN>);
if (!$key_file){
    $key_file = DEFAULT_KEY_FILE;   
}

my ($password, $password2);
while(!defined $password){
    system "stty -echo";
    print "Enter password (empty for no password):";
    chomp ($password = <STDIN>);
    print "\nEnter same password again:";
    chomp ($password2 = <STDIN>);
    if ($password2 ne $password){
        print "Passwords do not match. Try again.\n";
        undef $password;
    }
    system "stty echo";
}

print "Generating public/private RSA key pair, please wait...\n";

my ($public, $private) = $rsa->keygen(
    Identity  => DEFAULT_IDENTITY,
    Size      => DEFAULT_KEY_SIZE,
    Password  => $password,
    Verbosity => DEFAULT_VERBOSITY,
    Filename  => $key_file
) or die $rsa->errstr();

print "Your private key has been saved in $key_file.private.\n";
print "Your public key has been saved in $key_file.public.\n";
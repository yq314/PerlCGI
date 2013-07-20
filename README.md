PerlCGI
=======

This is a Perl practice project, which implemented a server/client cgi communication programme.


Objective:
----------
Client/Server communication over HTTP POST developed in PERL with RSA encryption mechanism

Step 1:
-------
Develop a CGI script (client) that will send a request to another CGI script (server). 

Step 2:
-------
Client will encrypt a passphrase using the RSA public key and will send it to the server that will decrypt it using the private key. In addition a second parameter N (number between 1 and 10000) will be passed to the server

Step 3:
-------
If the passphrase is successfully decrypted, the server will return the N(th) prime number Np to the client, the client will finally calculate and print the Np(th) term of the Fibonacci's series.

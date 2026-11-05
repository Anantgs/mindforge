# Notes

## How TLD Gets Information About a Domain

1.  You register a domain with a registrar.
2.  The registrar sends your domain + nameserver info to the TLD
    registry.
3.  The TLD registry adds your domain to its zone file.
4.  DNS root servers reference the TLD servers.
5.  When someone queries your domain:
    -   Root → TLD → your domain's nameservers.
6.  TLD only stores NS records, not website content.

------------------------------------------------------------------------

## Flow When You Access `www.google.com` from a Linux Server

1.  Application requests DNS resolution from Linux resolver.
2.  Linux checks:
    -   `/etc/hosts`
    -   DNS cache
    -   `/etc/resolv.conf` DNS servers
3.  Linux sends query to recursive DNS resolver.
4.  Recursive resolver performs full DNS lookup:
    -   Root servers → `.com` TLD → Google's authoritative DNS.
5.  Resolver returns IP to Linux.
6.  Linux opens TCP handshake → TLS handshake → HTTP(S) request.
7.  Google responds with the requested content.

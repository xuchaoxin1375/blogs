[toc]



```powershell
#⚡️[Administrator@CXXUDESK][C:\Share\df\wp_sites\wp_migration][16:04:43][UP:6.9Days]
PS> Get-DomainUserDictFromTable -Table C:\Users\Administrator\Desktop\table.conf |%{$_.domain}|%{flarectl zone info $_}
Try parse table from file:[C:\Users\Administrator\Desktop\table.conf]
                 ID                |       ZONE       |     PLAN     | STATUS |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+------------------+--------------+--------+--------------------------------+--------+-------
  439b89d74f44c24d56c57f572481b6a8 | erntegeraete.com | Free Website | active | aitana.ns.cloudflare.com,      | false  | full
                                   |                  |              |        | jeremy.ns.cloudflare.com       |        |
                 ID                |         ZONE         |     PLAN     | STATUS  |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+----------------------+--------------+---------+--------------------------------+--------+-------
  3a01971a92b2dcaf00fafa39a7c5d9fd | mdecineesthtique.com | Free Website | pending | aitana.ns.cloudflare.com,      | false  | full
                                   |                      |              |         | jeremy.ns.cloudflare.com       |        |
                 ID                |        ZONE         |     PLAN     | STATUS |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+---------------------+--------------+--------+--------------------------------+--------+-------
  d8a5f1302ab35e6e4bc0e014f79e6795 | magasinpourtous.com | Free Website | active | aitana.ns.cloudflare.com,      | false  | full
                                   |                     |              |        | jeremy.ns.cloudflare.com       |        |



#⚡️[Administrator@CXXUDESK][C:\Share\df\wp_sites\wp_migration][16:08:03][UP:6.9Days]
PS> Add-CloudflareZoneDNSRecords -Domains C:\Users\Administrator\Desktop\table.conf -AddRecordOnly
Mode:C:\share\df
parsing table from multiline string
WARNING: If the lines are not separated by comma,space,semicolon,etc,it may not work correctly! check it carefully
Domains: erntegeraete.com mdecineesthtique.com magasinpourtous.com
Press Enter to continue...:
Adding DNS record: erntegeraete.com|www -> 23.239.111.202 (A)
                 ID                |         NAME         | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+----------------------+------+----------------+-----+-----------+--------
  cda3eb75ddd2999e32384136e0574773 | www.erntegeraete.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: erntegeraete.com|* -> 23.239.111.202 (A)
                 ID                |        NAME        | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+--------------------+------+----------------+-----+-----------+--------
  0ca718c207746baa04bbb886b04b6765 | *.erntegeraete.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: erntegeraete.com|erntegeraete.com -> 23.239.111.202 (A)
                 ID                |       NAME       | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+------------------+------+----------------+-----+-----------+--------
  36f47cadc4dcda7df6a850b6d25307a9 | erntegeraete.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: mdecineesthtique.com|www -> 23.239.111.202 (A)
                 ID                |           NAME           | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+--------------------------+------+----------------+-----+-----------+--------
  895b38f7229deb0f2b5076829a04e704 | www.mdecineesthtique.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: mdecineesthtique.com|* -> 23.239.111.202 (A)
                 ID                |          NAME          | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+------------------------+------+----------------+-----+-----------+--------
  abf5495fb4024028c1bea1e956249892 | *.mdecineesthtique.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: mdecineesthtique.com|mdecineesthtique.com -> 23.239.111.202 (A)
                 ID                |         NAME         | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+----------------------+------+----------------+-----+-----------+--------
  a66452a2e07a13eca27edcf56744b4d3 | mdecineesthtique.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: magasinpourtous.com|www -> 23.239.111.202 (A)
                 ID                |          NAME           | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+-------------------------+------+----------------+-----+-----------+--------
  c758649e866a4635a27bbb6ba75881f2 | www.magasinpourtous.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: magasinpourtous.com|* -> 23.239.111.202 (A)
                 ID                |         NAME          | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+-----------------------+------+----------------+-----+-----------+--------
  569b5e53e6a49313a64dab800357d985 | *.magasinpourtous.com | A    | 23.239.111.202 |   1 | true      | true
Adding DNS record: magasinpourtous.com|magasinpourtous.com -> 23.239.111.202 (A)
                 ID                |        NAME         | TYPE |    CONTENT     | TTL | PROXIABLE | PROXY
-----------------------------------+---------------------+------+----------------+-----+-----------+--------
  ef4b2d7d3c1863ab16f35ae38cf7fce6 | magasinpourtous.com | A    | 23.239.111.202 |   1 | true      | true

#⚡️[Administrator@CXXUDESK][C:\Share\df\wp_sites\wp_migration][16:08:28][UP:6.9Days]
PS> Get-DomainUserDictFromTable -Table C:\Users\Administrator\Desktop\table.conf |%{$_.domain}|%{flarectl dns list --zone $_}
Try parse table from file:[C:\Users\Administrator\Desktop\table.conf]
                 ID                | TYPE |         NAME         |    CONTENT     | PROXIED | TTL
-----------------------------------+------+----------------------+----------------+---------+------
  0ca718c207746baa04bbb886b04b6765 | A    | *.erntegeraete.com   | 23.239.111.202 | true    |   1
  36f47cadc4dcda7df6a850b6d25307a9 | A    | erntegeraete.com     | 23.239.111.202 | true    |   1
  cda3eb75ddd2999e32384136e0574773 | A    | www.erntegeraete.com | 23.239.111.202 | true    |   1
                 ID                | TYPE |           NAME           |    CONTENT     | PROXIED | TTL
-----------------------------------+------+--------------------------+----------------+---------+------
  abf5495fb4024028c1bea1e956249892 | A    | *.mdecineesthtique.com   | 23.239.111.202 | true    |   1
  a66452a2e07a13eca27edcf56744b4d3 | A    | mdecineesthtique.com     | 23.239.111.202 | true    |   1
  895b38f7229deb0f2b5076829a04e704 | A    | www.mdecineesthtique.com | 23.239.111.202 | true    |   1
                 ID                | TYPE |          NAME           |    CONTENT     | PROXIED | TTL
-----------------------------------+------+-------------------------+----------------+---------+------
  569b5e53e6a49313a64dab800357d985 | A    | *.magasinpourtous.com   | 23.239.111.202 | true    |   1
  ef4b2d7d3c1863ab16f35ae38cf7fce6 | A    | magasinpourtous.com     | 23.239.111.202 | true    |   1
  c758649e866a4635a27bbb6ba75881f2 | A    | www.magasinpourtous.com | 23.239.111.202 | true    |   1
```



```powershell
#⚡️[Administrator@CXXUDESK][~\Desktop][20:16:08][UP:0.08Days]
PS> Get-DomainUserDictFromTable -Table C:\Users\Administrator\Desktop\table.conf |%{$_.domain}
Try parse table from file:[C:\Users\Administrator\Desktop\table.conf]
prolampen.com
homelicht.com
eveilsoin.com
avenuedesachats.com

#⚡️[Administrator@CXXUDESK][~\Desktop][20:16:36][UP:0.08Days]
PS> Get-DomainUserDictFromTable -Table C:\Users\Administrator\Desktop\table.conf |%{$_.domain}|%{flarectl zone info $_}
Try parse table from file:[C:\Users\Administrator\Desktop\table.conf]
                 ID                |     ZONE      |     PLAN     | STATUS |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+---------------+--------------+--------+--------------------------------+--------+-------
  aa9c8cedb8c5e5dc68bf4bfc745648ae | prolampen.com | Free Website | active | aitana.ns.cloudflare.com,      | false  | full
                                   |               |              |        | jeremy.ns.cloudflare.com       |        |
                 ID                |     ZONE      |     PLAN     | STATUS |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+---------------+--------------+--------+--------------------------------+--------+-------
  fa59be48cc892c09bdd72bc86e11cef5 | homelicht.com | Free Website | active | aitana.ns.cloudflare.com,      | false  | full
                                   |               |              |        | jeremy.ns.cloudflare.com       |        |
                 ID                |     ZONE      |     PLAN     | STATUS |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+---------------+--------------+--------+--------------------------------+--------+-------
  6cb1a9b09ab64ba4aef09834f745240e | eveilsoin.com | Free Website | active | aitana.ns.cloudflare.com,      | false  | full
                                   |               |              |        | jeremy.ns.cloudflare.com       |        |
                 ID                |        ZONE         |     PLAN     | STATUS |          NAME SERVERS          | PAUSED | TYPE
-----------------------------------+---------------------+--------------+--------+--------------------------------+--------+-------
  9e6f4478d9798b276c5d943a74e6db3a | avenuedesachats.com | Free Website | active | aitana.ns.cloudflare.com,      | false  | full
                                   |                     |              |        | jeremy.ns.cloudflare.com       |        |

#⚡️[Administrator@CXXUDESK][~\Desktop][20:17:20][UP:0.08Days]
PS> Get-DomainUserDictFromTable -Table C:\Users\Administrator\Desktop\table.conf |%{$_.domain}|%{flarectl dns list $_}
Try parse table from file:[C:\Users\Administrator\Desktop\table.conf]
                 ID                | TYPE |       NAME        |    CONTENT     | PROXIED | TTL
-----------------------------------+------+-------------------+----------------+---------+------
  1bba06f37e6c647e8339a7a115673554 | A    | *.prolampen.com   | 23.239.111.202 | true    |   1
  08a9ac4738fce34b3c2eb485becb9462 | A    | prolampen.com     | 23.239.111.202 | true    |   1
  4ff5d74d5c63ab6f09591cd880f511d7 | A    | www.prolampen.com | 23.239.111.202 | true    |   1
                 ID                | TYPE |       NAME        |    CONTENT     | PROXIED | TTL
-----------------------------------+------+-------------------+----------------+---------+------
  fc27f90e5661b6cdcd195f56a7a9bd2b | A    | *.homelicht.com   | 23.239.111.202 | true    |   1
  baa636f9ebb9f0f8ea21bcc57007bee2 | A    | homelicht.com     | 23.239.111.202 | true    |   1
  c36e09850abd825fdff2219fe0eb99c5 | A    | www.homelicht.com | 23.239.111.202 | true    |   1
                 ID                | TYPE |       NAME        |    CONTENT     | PROXIED | TTL
-----------------------------------+------+-------------------+----------------+---------+------
  f5935ddc0d792a80cef06cc3a30e96ce | A    | *.eveilsoin.com   | 23.239.111.202 | true    |   1
  a09777527f7f1f6093f87c4fda83ecac | A    | eveilsoin.com     | 23.239.111.202 | true    |   1
  51519e029e590260d76b19d1e5191ca1 | A    | www.eveilsoin.com | 23.239.111.202 | true    |   1
                 ID                | TYPE |          NAME           |    CONTENT     | PROXIED | TTL
-----------------------------------+------+-------------------------+----------------+---------+------
  9a36a74fba770f92671d19a4b86d02ca | A    | *.avenuedesachats.com   | 23.239.111.202 | true    |   1
  f99f2e7a1c5750324044801e591c5985 | A    | avenuedesachats.com     | 23.239.111.202 | true    |   1
  f7586591a42ff17b53a98106b9c477a1 | A    | www.avenuedesachats.com | 23.239.111.202 | true    |   1
```


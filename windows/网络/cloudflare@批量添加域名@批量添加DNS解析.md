[toc]



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


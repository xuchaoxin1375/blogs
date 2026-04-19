[toc]

## 阅读curl自带的帮助

```powershell
PS> curl.exe --help category
Usage: curl [options...] <url>
 auth        Different types of authentication methods
 connection  Low level networking operations
 curl        The command line tool itself
 dns         General DNS options
 file        FILE protocol options
 ftp         FTP protocol options
 http        HTTP and HTTPS protocol options
 imap        IMAP protocol options
 misc        Options that don't fit into any other category
 output      Filesystem output
 pop3        POP3 protocol options
 post        HTTP Post specific options
 proxy       All options related to proxies
 scp         SCP protocol options
 sftp        SFTP protocol options
 smtp        SMTP protocol options
 ssh         SSH protocol options
 telnet      TELNET protocol options
 tftp        TFTP protocol options
 tls         All TLS/SSL related options
 upload      All options for uploads
 verbose     Options related to any kind of command line output of curl
```

### curl 基础xuan'xiang

查看curl本身的帮助`curl --help curl`

```bash
PS> curl --help curl
Usage: curl [options...] <url>
curl: The command line tool itself
 -K, --config <file>                 Read config from a file
     --create-dirs                   Create necessary local directory hierarchy
 -q, --disable                       Disable .curlrc
     --disallow-username-in-url      Disallow username in URL
     --fail-early                    Fail on first transfer error
     --ftp-create-dirs               Create the remote dirs if not present
 -g, --globoff                       Disable URL globbing with {} and []
 -h, --help <category>               Get help for commands
     --libcurl <file>               Generate libcurl code for this command line
 -M, --manual                        Display the full manual
 -n, --netrc                         Must read .netrc for username and password
     --netrc-file <filename>         Specify FILE for netrc
     --netrc-optional                Use either .netrc or URL
 -:, --next                       Make next URL use its separate set of options
 -N, --no-buffer                     Disable buffering of the output stream
     --no-clobber                    Do not overwrite files that already exist
 -o, --output <file>                 Write to file instead of stdout
     --output-dir <dir>              Directory to save files in
 -Z, --parallel                      Perform transfers in parallel
     --parallel-immediate        Do not wait for multiplexing (with --parallel)
     --parallel-max <num>            Maximum concurrency for parallel transfers
     --path-as-is                    Do not squash .. sequences in URL path
     --proto <protocols>             Enable/disable PROTOCOLS
     --proto-default <protocol>      Use PROTOCOL for any URL missing a scheme
     --proto-redir <protocols>       Enable/disable PROTOCOLS on redirect
     --remove-on-error               Remove output file on errors
     --retry <num>                   Retry request if transient problems occur
     --retry-all-errors              Retry all errors (with --retry)
     --retry-connrefused             Retry on connection refused (with --retry)
     --retry-delay <seconds>         Wait time between retries
     --retry-max-time <seconds>      Retry only within this period
 -S, --show-error                    Show error even when -s is used
     --url <url>                     URL to work with
     --variable <[%]name=text/@file>  Set variable
 -V, --version                       Show version number and quit

```

### http 选项

```bash
PS> curl --help http
Usage: curl [options...] <url>
http: HTTP and HTTPS protocol options
     --alt-svc <filename>             Enable alt-svc with this cache file
     --anyauth                        Pick any authentication method
     --aws-sigv4 <provider1[:prvdr2[:reg[:srv]]]>  AWS V4 signature auth
     --compressed                     Request compressed response
 -b, --cookie <data|filename>         Send cookies from string/load from file
 -c, --cookie-jar <filename>         Save cookies to <filename> after operation
 -d, --data <data>                    HTTP POST data
     --data-ascii <data>              HTTP POST ASCII data
     --data-binary <data>             HTTP POST binary data
     --data-raw <data>                HTTP POST data, '@' allowed
     --data-urlencode <data>          HTTP POST data URL encoded
     --digest                         HTTP Digest Authentication
 -D, --dump-header <filename>         Write the received headers to <filename>
     --etag-compare <file>            Load ETag from file
     --etag-save <file>               Parse incoming ETag and save to a file
     --expect100-timeout <seconds>    How long to wait for 100-continue
 -f, --fail                           Fail fast with no output on HTTP errors
     --fail-with-body                 Fail on HTTP errors but save the body
 -F, --form <name=content>            Specify multipart MIME data
     --form-escape                    Escape form fields using backslash
     --form-string <name=string>      Specify multipart MIME data
 -G, --get                            Put the post data in the URL and use GET
     --haproxy-clientip <ip>          Set address in HAProxy PROXY
     --haproxy-protocol               Send HAProxy PROXY protocol v1 header
 -I, --head                           Show document info only
 -H, --header <header/@file>          Pass custom header(s) to server
     --hsts <filename>                Enable HSTS with this cache file
     --http0.9                        Allow HTTP 0.9 responses
 -0, --http1.0                        Use HTTP 1.0
     --http1.1                        Use HTTP 1.1
     --http2                          Use HTTP/2
     --http2-prior-knowledge          Use HTTP 2 without HTTP/1.1 Upgrade
     --http3                          Use HTTP v3
     --http3-only                     Use HTTP v3 only
     --ignore-content-length          Ignore the size of the remote resource
     --json <data>                    HTTP POST JSON
 -j, --junk-session-cookies           Ignore session cookies read from file
 -L, --location                       Follow redirects
     --location-trusted           Like --location, but send auth to other hosts
     --max-redirs <num>               Maximum number of redirects allowed
     --negotiate                     Use HTTP Negotiate (SPNEGO) authentication
     --no-alpn                        Disable the ALPN TLS extension
     --no-npn                         Disable the NPN TLS extension
     --ntlm                           HTTP NTLM authentication
     --ntlm-wb                        HTTP NTLM authentication with winbind
     --post301                        Do not switch to GET after a 301 redirect
     --post302                        Do not switch to GET after a 302 redirect
     --post303                        Do not switch to GET after a 303 redirect
     --proxy-http2                    Use HTTP/2 with HTTPS proxy
 -r, --range <range>                  Retrieve only the bytes within RANGE
     --raw                            Do HTTP raw; no transfer decoding
 -e, --referer <URL>                  Referrer URL
     --request-target <path>          Specify the target for this request
 -z, --time-cond <time>               Transfer based on a time condition
     --tr-encoding                    Request compressed transfer encoding
     --url-query <data>               Add a URL query part
 -A, --user-agent <name>              Send User-Agent <name> to server
```


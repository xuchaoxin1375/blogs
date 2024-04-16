[toc]

## cdn加速

- **内容分发网络**（英语：**C**ontent **D**elivery **N**etwork或**C**ontent **D**istribution **N**etwork，缩写：**CDN**）
  - 是指一种透过[互联网](https://zh.wikipedia.org/wiki/互聯網)互相连接的电脑网络系统，利用**最靠近每位用户的服务器**，更快、更可靠地将音乐、图片、视频、应用程序及其他文件发送给用户，来提供高性能、可扩展性及低成本的网络内容传递给用户

- [jsDelivr - A free, fast, and reliable CDN for open source](https://www.jsdelivr.com/)

- [Content delivery network - Wikipedia](https://en.wikipedia.org/wiki/Content_delivery_network)

## github_cdn加速用例

### raw.githubusercontent.com资源链接加速

#### markdown&图片加速

- `https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main`
- 以下是在图床软件picgo中设置设置cdn域名头加速
  - 关于图床的配置,参看其他教程

![](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images20220617160254.png)

- 大概的使用方法是:将`https://cdn.jsdelivr.net/gh/`作为第一部分(cdn)
- 第二部分为,github仓库和目录`xuchaoxin1375/pictures/`
- 第三部分,指明仓库分支`@main/`

> - 上述所作的是不连续替换,从GitHub原始链接做了两部分替换,第一部分比较简答,
> - 第二部分在仓库目录名后添加分支号`@yourBranchName/`(注意原来的`/`变成`@`)
> - 最后的部分和原链接部分一致

- `https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images20220617160254.png`
- `https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/images20220617160254.png`
- [https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/images20220617160254.png](https://raw.githubusercontent.com/xuchaoxin1375/pictures/main/images20220617160254.png)
- [https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images20220617160254.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images20220617160254.png)

## what is cdn

- A **content delivery network**, or **content distribution network** (**CDN**), is a geographically distributed network of [proxy servers](https://en.wikipedia.org/wiki/Proxy_server) and their [data centers](https://en.wikipedia.org/wiki/Data_center). 
- The **goal** is to provide **high availability and performance** by distributing the service **spatially**(空间上地) relative to [end users](https://en.wikipedia.org/wiki/End_user). 
- CDNs came into existence in the late 1990s **as a means for alleviating (缓解)the performance bottlenecks of the Internet[**[1\]](https://en.wikipedia.org/wiki/Content_delivery_network#cite_note-:0-1)[[2\]](https://en.wikipedia.org/wiki/Content_delivery_network#cite_note-2) as the Internet was starting to become a mission-critical medium (关键媒介)for people and enterprises. 
- Since then, CDNs have grown to serve a large portion of the Internet content today, including web objects (text, graphics and scripts), downloadable objects (media files, software, documents), applications ([e-commerce](https://en.wikipedia.org/wiki/E-commerce), [portals](https://en.wikipedia.org/wiki/Web_portal)), [live streaming](https://en.wikipedia.org/wiki/Live_streaming) media, on-demand streaming media, and [social media](https://en.wikipedia.org/wiki/Social_media) sites.[[3\]](https://en.wikipedia.org/wiki/Content_delivery_network#cite_note-3)

- CDNs are a [layer](https://en.wikipedia.org/wiki/Abstraction_layer) in the internet ecosystem. 
  - Content owners such as media companies and e-commerce vendors pay CDN operators to deliver their content to their end users. 
  - In turn, a CDN pays [Internet service providers](https://en.wikipedia.org/wiki/Internet_service_provider) (ISPs), carriers(`a person or thing that carries, holds, or conveys something.?`), and network operators for hosting its servers in their data centers.

- CDN is **an umbrella term** (总括术语) spanning different types of content delivery services: [video streaming](https://en.wikipedia.org/wiki/Video_streaming), software downloads, web and mobile content acceleration, licensed/managed CDN, transparent caching, and services to measure 
- CDN performance, [load balancing](https://en.wikipedia.org/wiki/Load_balancing_(computing)), Multi CDN switching and analytics and cloud intelligence(情报). 
- CDN vendors may cross over into other industries like security, [DDoS](https://en.wikipedia.org/wiki/DDoS) protection and [web application firewalls](https://en.wikipedia.org/wiki/Web_application_firewall) (WAF), and WAN optimization.

- 内容分发网络（CDN）是指一组分布在不同地理位置的服务器，协同工作以提供互联网内容的快速交付。

- CDN 允许**快速传输加载互联网内容所需的资源**，包括 HTML 页面、javascript 文件、样式表、图像和视频。

-  CDN 服务已得到不断普及。

- 如今，大多数 web 流量都通过 CDN 提供服务，包括来自**Facebook、Netflix 和亚马逊等主要网站的流量**。

- 正确配置的 CDN 还可**帮助保护网站免受某些常见的恶意攻击**，例如[分布式拒绝服务（DDOS）攻击](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)。

- 虽然 CDN 不承载内容，也不能取代适当 web 托管的需求，但它确实帮助在[网络边缘](https://www.cloudflare.com/learning/serverless/glossary/what-is-edge-computing/)[缓存](https://www.cloudflare.com/learning/cdn/what-is-caching/)内容，从而提高网站性能。许多网站很难通过传统的托管服务满足其[性能](https://www.cloudflare.com/learning/cdn/performance/)需求，这就是他们选择 CDN 的原因。

  CDN 利用缓存来减少托管带宽，[帮助防止服务中断](https://www.cloudflare.com/learning/cdn/cdn-load-balance-reliability/)，以及[提高安全性](https://www.cloudflare.com/learning/cdn/cdn-ssl-tls-security/)，因此对于传统网页托管带来的一些主要痛点，CDN 成为一种流行的选择。

### 使用 CDN 有什么好处？

尽管使用 CDN 的好处取决于互联网资产的大小和需求，但对于大多数用户而言，主要好处可以分为以下四个不同的部分：

1. **缩短网站加载时间** – 通过将内容分发到访问者附近的 CDN 服务器（以及其他优化措施），访问者体验到更快的页面加载时间。由于访问者更倾向于离开加载缓慢的网站，CDN 可以降低跳出率并增加人们在该网站上停留的时间。换句话说，网站速度越快，用户停留的时间越长。
2. **减少带宽成本** – 网站托管的带宽消耗成本是网站的主要费用。通过缓存和其他优化，CDN 能够减少源服务器必须提供的数据量，从而降低网站所有者的托管成本。
3. **增加内容可用性和冗余** – 大流量或硬件故障可能会扰乱正常的网站功能。由于 CDN 具有分布式特性，因此与许多源服务器相比，CDN 可以处理更多流量并更好地承受硬件故障。
4. **改善网站安全性** – CDN 可以通过提供 [DDoS 缓解](https://www.cloudflare.com/learning/ddos/ddos-mitigation/)、安全证书的改进以及其他优化措施来提高安全性。

- 内容分发网络的总承载量可以比单一骨干最大的带宽还要大。这使得内容分发网络可以承载的用户数量比起传统单一服务器多。也就是说，若把有100Gbps处理能力的服务器放在只有10Gbps带宽的数据中心，则亦只能发挥出10Gbps的承载量。但如果放到十个有10Gbps的地点，整个系统的承载量就可以到10*10Gbps。

- 同时，将服务器放到不同地点，可以减少互连的流量，进而降低带宽成本。

- 对于[TCP](https://zh.wikipedia.org/wiki/传输控制协议)传输而言，TCP的速度（throughput）会受到延迟时间（latency）与数据包漏失率（packet loss）影响。
  - 为了改善这些负面因素，内容分发网络通常会指派较近、较顺畅的服务器节点将资料传输给用户。
  - 虽然距离并不是绝对因素，但这么做可以尽可能提高性能，用户将会觉得比较顺畅。
  - 这使得一些比较高带宽的应用（传输[高清视频](https://zh.wikipedia.org/w/index.php?title=高清影片&action=edit&redlink=1)）更容易推动。

- 内容分发网络另外一个好处在于有异地备援。当某个服务器故障时，系统将会调用其他邻近地区的服务器服务，进而**提供接近100%的可靠度**。
- 除此之外，内容分发网络提供给服务提供者**更多的控制权**。提供服务的人可以针对客户、地区，或是其他因子调整。

### CDN 技术&如何工作？

- CDN 的核心是一个服务器网络，目的是尽可能快速、便宜、可靠和安全地交付内容。
- 为了提高速度和连接性，CDN 会将服务器放置在不同网络之间的交换点。
  - 这些[互联网交换点（IXP）](https://www.cloudflare.com/learning/cdn/glossary/internet-exchange-point-ixp/)是不同互联网提供商连接的主要位置，以便彼此提供对来自其不同网络的流量的访问。
  - 这些节点之间会动态的互相传输内容，对用户的下载行为优化，并借此减少内容供应者所需要的带宽成本，改善用户的下载速度，提高系统的稳定性。
  - 内容分发网络所需要的节点数量随着需求而不同，依照所需要服务的对象大小，有可能有数万台服务器。
    - 服务器的运作方式一般是基于[nginx](https://zh.wikipedia.org/wiki/Nginx)的模式，也就是仅仅缓存网站的静态内容，不过，随着2017年世界各地CDN服务商纷纷推出HTTPS加速功能，运作方式也变得略有不同，变成了nginx+SNI（一个CDN节点上可以借此技术绑定N个域名），同时，[BGP](https://zh.wikipedia.org/wiki/BGP) [anycast](https://zh.wikipedia.org/wiki/Anycast)技术也逐渐引入了CDN领域中。

- 通过连接到这些高速且高度互连的位置，CDN 提供商可以减少高速数据传输中的成本和传输时间。

![什么是 CDN](https://cf-assets.www.cloudflare.com/slt3lc6tev37/540CpDkqSDg6QAPi5nO1AP/b44a3edb5abc4e115ddab9b4d9bf7a32/Learning-How-does-a-CDN-work.svg)

- 除了在 IXP 中放置服务器，CDN 还对标准客户端/服务器数据传输进行了诸多优化。 
- CDN 将数据中心放置在全球的战略位置，增强安全性，并设计成可承受各种类型的故障和互联网拥塞。

### 延迟 – CDN 如何改善网站加载时间？

- 在网站加载内容方面，隨着网站速度变慢，用户数量会迅速减少。 

- CDN 服务可以通过以下方式帮助减少加载时间：

  - CDN 的全球分布性可缩短用户与网站资源之间的距离。
  - CDN 使得用户不必连接到网站[源服务器](https://www.cloudflare.com/learning/cdn/glossary/origin-server/)的所在地，而是连接到一个地理位置更近的[数据中心](https://www.cloudflare.com/learning/cdn/glossary/internet-exchange-point-ixp/)。更少的传输时间意味着更快的服务。

  - 硬件和软件优化，例如有效的负载均衡和固态硬盘驱动器，可以帮助数据更快地到达用户。

  - CDN 可以使用[最小化](https://www.cloudflare.com/learning/performance/why-minify-javascript-code/)和文件压缩之类的策略来**减小文件大小，从而减少传输的数据量**。较小的文件意味着更快的加载时间。

  - CDN 还可以通过优化连接重用和启用 TLS 假启动来加速使用 [TLS](https://www.cloudflare.com/learning/security/glossary/transport-layer-security-tls/)/[SSL](https://www.cloudflare.com/learning/security/glossary/what-is-ssl/) 的站点。

> - [探索 CDN 帮助网站更快加载的所有方式](https://www.cloudflare.com/learning/cdn/performance/)

### 可靠性和冗余 – CDN 如何使网站始终保持在线状态？

- 对于拥有互联网资产的任何人来说，正常运行时间都是至关重要的组成部分。

- 恶意攻击或只是受欢迎程度增加所致的硬件故障和流量激增，都有可能使 web 服务器停机并阻止用户访问站点或服务。

- 完善的 CDN 具备一些可最大程度减少停机时间的功能：

  - **负载均衡**可在多个服务器之间平均分配网络流量，从而更容易适应流量的快速增长。

  - 即使一台或多台 CDN 服务器由于硬件故障而脱机，**智能故障切换也可提供不间断的服务**；故障转移可以将流量重新分配给其他正常运行的服务器。

  - 如果整个数据中心都遇到技术问题，那么 [Anycast](https://www.cloudflare.com/learning/cdn/glossary/anycast-network/) 路由会**将流量转移到另一个可用的数据中心**，以确保所有用户都能继续访问网站。

> - [进一步了解 CDN 如何帮助网站保持在线](https://www.cloudflare.com/learning/cdn/cdn-load-balance-reliability/)

### 数据安全性 – CDN 如何保护数据？

- 信息安全是 CDN 不可或缺的一部分。
- CDN 可以使用新的 [TLS/SSL 证书](https://www.cloudflare.com/learning/ssl/what-is-an-ssl-certificate/)保护站点的安全，这将确保高标准的身份验证、[加密](https://www.cloudflare.com/learning/ssl/what-is-encryption/)和完整性。
- 了解有关 CDN 的安全问题，并探索可以采取什么措施来安全地交付内容。

> - [了解 CDN SSL/TLS 安全性](https://www.cloudflare.com/learning/cdn/cdn-ssl-tls-security/)

### 带宽费用 – CDN如何减少带宽成本？

- 源服务器每次响应请求时，都会消耗带宽。
- 了解 CDN （例如 [Cloudflare CDN](https://www.cloudflare.com/cdn) ）如何减少对源服务器的请求并[降低带宽成本](https://www.cloudflare.com/learning/cdn/how-cdns-reduce-bandwidth-cost/)。
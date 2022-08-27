[toc]

## 阿里云主机_安全组端口放行/宝塔面板登录

## reference

* [安全组 (aliyun.com)](https://help.aliyun.com/document_detail/25467.html)
  * [安全组概述](https://help.aliyun.com/document_detail/25387.html)
  * [托管安全组](https://help.aliyun.com/document_detail/188745.html)
  * [安全组应用案例](https://help.aliyun.com/document_detail/25475.html)
  * [常用端口](https://help.aliyun.com/document_detail/40724.html)
  * [操作导航](https://help.aliyun.com/document_detail/173123.html)
  * [创建安全组](https://help.aliyun.com/document_detail/25468.html)
  * [添加安全组规则](https://help.aliyun.com/document_detail/25471.html)
  * [ECS实例加入安全组](https://help.aliyun.com/document_detail/25443.html)
  * [替换ECS实例的安全组](https://help.aliyun.com/document_detail/156683.html)
  * [查看潜在高危安全组](https://help.aliyun.com/document_detail/99163.html)
  * [管理安全组](https://help.aliyun.com/document_detail/127216.html)
  * [管理安全组规则](https://help.aliyun.com/document_detail/127161.html)

### 管理配置安全组

- [安全组云服务器管理控制台 (aliyun.com)](https://ecs.console.aliyun.com/?spm=5176.12818093.ProductAndService--ali--widget-home-product-recent.dre3.3be916d08iN7rH&accounttraceid=9070addfbedd4cbb8f40411168ac2f12xfbr#/securityGroup/region/cn-beijing)

创建新安全组

#### 配置安全组端口放行

![1648192138040.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648192138040.png)

![1648192170061.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648192303119.png)

* 单挑规则配置后单条保存
  * 配置宝塔端口(8888):
  * ![1648192248058.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648192248058.png)
* 确保实例添加到该安全组(按权组内实例列表)
  * ![1648192303119.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648192170061.png)

### 逐一加入指定安全组

- [阿里云控制台首页 (aliyun.com)](https://home.console.aliyun.com/home/dashboard/ResourceDashboard)选择实例

![1648191901492.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648191956689.png)

### 批量加入安全组

![1648191956689.png](https://cdn.jsdelivr.net/gh/xuchaoxin1375/pictures@main/images/1648191901492.png)

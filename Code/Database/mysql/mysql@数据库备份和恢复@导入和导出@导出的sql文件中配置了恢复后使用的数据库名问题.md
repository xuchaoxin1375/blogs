[toc]



## mysql数据库克隆|备份与恢复🎈

- 导出sql文件备份：`mysqldump -u root -p my_database > backup.sql`
- 导入sql文件：`mysql -u root -p my_database < backup.sql`

这里的`-p`可以直接跟上数据库密码`-p"password"`,或者先放空,回车后填写密码完成操作

```bash
root@wnx0006088:~# mysqldump -u root -p wp_voiceforscopes.com > out.sql
Enter password:
root@wnx0006088:~# ls -l out.sql
# 创建新的数据库用于导入
root@wnx0006088:~# mysql -uroot -e "create database test_cli" -p
Enter password:
# 开始导入之前备份的文件
root@wnx0006088:~# mysql -u root -p wp_form2fb.voiceforscopes.com < out.sql
Enter password:
```

### 导出的sql文件预设了数据库名字

导出sql时是否使用了`--database`,效果会有所不同



```sql
-- MySQL dump 10.13  Distrib 5.7.26, for Win64 (x86_64)
--
-- Host: localhost    Database: zsh_vivirbajoestrellas.com
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `vivirbajoestrellas.com`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `vivirbajoestrellas.com` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `vivirbajoestrellas.com`;

--
-- Table structure for table `wp_actionscheduler_actions`
--
```

可以看到

```sql
--
-- Current Database: `vivirbajoestrellas.com`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `vivirbajoestrellas.com` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */;

USE `vivirbajoestrellas.com`;

```

而常规情况下导出的sql头部

```sql
-- MySQL dump 10.13  Distrib 5.7.26, for Win64 (x86_64)
--
-- Host: localhost    Database: 1.es
-- ------------------------------------------------------
-- Server version	5.7.26

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `wp_actionscheduler_actions`
--
```


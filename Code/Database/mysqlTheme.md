## 13.3 Customizing the Prompt

* The prompt of MySQL Shell can be customized using prompt theme `files`.
* To customize the prompt theme file, either set the `MYSQLSH_PROMPT_THEME` environment variable to a prompt theme` file name`,
  * or copy a prompt theme file to the `~/.mysqlsh/` directory on Linux and macOS,
  * or the `%AppData%\Roaming\MySQL\mysqlsh\` directory on Windows.
* The file must be named `prompt.json`, and `MySQL Shell `must be `restarted` before changes take effect.

[]()**Figure 13.1 mysql shell prompt**

![MySQL Shell prompt showing changes of input language JavaScript to SQL, SQL to Python, Python back to JavaScript.](https://dev.mysql.com/doc/mysql-shell/8.0/en/images/mysqlsh-prompt.png)

There are six parts that can make up the prompt:

* **Status**: Whether it is a production system and whether the connection has been lost.
* **MySQL**: A reminder that you are working with a MySQL database.
* **Connection**: Which host you are connected to, and on which port that SSL is being used.
* **Schema**: The current default schema.
* **Mode**: The mode you are using: `JS` = JavaScript, `PY` = Python, and `SQL` = SQL.
* **End**: The prompt ends with `>`.

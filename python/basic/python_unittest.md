[toc]
# django测试入门案例/常见的测试问题/返回空数据/单元测试与客户端&数据库数据/测试工具的使用

### MDN系列教程:

*   [Django 测试 Django 网页应用 - 学习 Web 开发 | MDN (mozilla.org)](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#%E6%B5%8B%E8%AF%95%E7%BB%93%E6%9E%84%E6%A6%82%E8%BF%B0)
*   [2LocalLibrary 测试](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#locallibrary_%E6%B5%8B%E8%AF%95)
    *   [3模型](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#%E6%A8%A1%E5%9E%8B)
    *   [3表单](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#%E8%A1%A8%E5%8D%95)
    *   [3视图](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#%E8%A7%86%E5%9B%BE)
        *   [4仅限登录用户的视图](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#%E4%BB%85%E9%99%90%E7%99%BB%E5%BD%95%E7%94%A8%E6%88%B7%E7%9A%84%E8%A7%86%E5%9B%BE)
        *   [4使用表单测试视图](https://developer.mozilla.org/zh-CN/docs/learn/Server-side/Django/Testing#%E4%BD%BF%E7%94%A8%E8%A1%A8%E5%8D%95%E6%B5%8B%E8%AF%95%E8%A7%86%E5%9B%BE)

### Django文档:

[Django 中的测试 | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/topics/testing/)

*   在 Django 中编写测试的首选方式是使用 Python 标准库中内置的 [`unittest`](https://docs.python.org/3/library/unittest.html#module-unittest) 模块

[编写并运行测试 | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/topics/testing/overview/)

[测试工具 | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/topics/testing/tools/)

[测试数据库¶](https://docs.djangoproject.com/zh-hans/4.0/topics/testing/overview/#the-test-database-1)

### 其他参考

- [Django实际开发中的单元测试_django项目单元测试](https://blog.csdn.net/weixin_42768004/article/details/114522963)

## 测试数据库

*   需要数据库的测试（即模型测试）将`不会使用“实际”（生产）数据库`。 将为测试创建`单独的空白数据库`。
    *   知道这一点很重要,单元测试中的代码访问不了实际环境中的数据(这是测试隐含的一个特点)
        *   单元测试有`临时数据(需要编写相关代码手动的创建符合测试要求(能够达到测试目的的数据,可能是精心设计的数据,未必是随意产生的数据)!)`和`临时数据库(自动创建)`来检测api功能
    *   所以,当你在你的测试代码中试图(通过某个接口)访问数据库中的数据时,一般都是空的结果
    *   这和`python manage.py shell`中的一次性临时测试不同(`python shell`的环境时可以访问到正式的数据库
        *   在`python shell` 中不会自动创建临时数据库,它肯定用的时实际环境中的数据库而不是临时数据库(换句话说,和浏览器这类客户端访问的效果时一样的))
        *   在`python manage.py test <test_target>`的运行中情况大为不同,这种情况下会创建空白数据库(这也是为什么前面说,会出现api路由访问成功(譬如200 OK),但是数据内容却是空白数据的情况)
        *   因此,我们在编写测试的时候,特别是测试要访问数据库的的api的路由/功能时,需要编写相应的数据创建代码,来产生临时数据填充临时数据库,以供测试中的api或者其他代码读取数据

\> 无论测试是通过还是失败，当所有测试执行完毕后，测试数据库都会被销毁。

*   但是,你可以通过使用 [`test --keepdb`](https://docs.djangoproject.com/zh-hans/4.0/ref/django-admin/#cmdoption-test-keepdb) 选项来防止测试数据库被破坏。
    *   这将在两次运行之间保留测试数据库。
    *   如果数据库不存在，将首先创建它。
    *   任何迁移都将被应用，以使其保持最新状态。

#### 运行测试时从生产数据库中查找数据？

*   如果你的代码在编译模块时试图访问数据库，这将在测试数据库建立 _之前_ 发生，可能会产生意想不到的结果。
    *   例如，如果你在模块级代码中进行数据库查询，并且存在`真实的数据库`，则生产数据可能会污染你的测试。
    *   无论如何，_在代码中都包含这样的导入时数据库查询是一个坏主意_——重写代码，使其不会执行此操作。

## 入门案例

*   [编写你的第一个 Django 应用，第 5 部分 | Django 文档 | Django (djangoproject.com)](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/)
    *   该教程的源代码在github上有相关仓库(注意克隆下来的仓库可能是空的,但是不影响单元测试,数据可以在测试中创建,结束后销毁)
    *   [自动化测试简介](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#introducing-automated-testing)
        *   [自动化测试是什么？](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#what-are-automated-tests)
        *   [为什么你需要写测试](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#why-you-need-to-create-tests)
            *   [测试将节约你的时间](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#tests-will-save-you-time)
            *   [测试不仅能发现错误，而且能预防错误](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#tests-don-t-just-identify-problems-they-prevent-them)
            *   [测试使你的代码更有吸引力](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#tests-make-your-code-more-attractive)
            *   [测试有利于团队协作](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#tests-help-teams-work-together)
    *   [基础测试策略](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#basic-testing-strategies)
    *   [开始写我们的第一个测试](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#writing-our-first-test)
        *   [首先得有个 Bug](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#we-identify-a-bug)
        *   [创建一个测试来暴露这个 bug](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#create-a-test-to-expose-the-bug)
        *   [运行测试](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#running-tests)
        *   [修复这个 bug](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#fixing-the-bug)
        *   [更全面的测试](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#more-comprehensive-tests)
    *   [测试视图](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#test-a-view)
        *   [针对视图的测试](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#a-test-for-a-view)
        *   [Django 测试工具之 Client](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#the-django-test-client)
        *   [改善视图代码](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#improving-our-view)
        *   [测试新视图](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#testing-our-new-view)
        *   [测试 `DetailView`](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#testing-the-detailview)
        *   [更多的测试思路](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#ideas-for-more-tests)
    *   [当需要测试的时候，测试用例越多越好](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#when-testing-more-is-better)
    *   [深入代码测试](https://docs.djangoproject.com/zh-hans/4.0/intro/tutorial05/#further-testing)

### manage.py test 的使用帮助

`python manage.py test --help`

```plaintext
usage: manage.py test [-h] [--noinput] [--failfast] [--testrunner TESTRUNNER]
                      [-t TOP_LEVEL] [-p PATTERN] [--keepdb]
                      [--shuffle [SEED]] [-r] [--debug-mode] [-d]
                      [--parallel [N]] [--tag TAGS]
                      [--exclude-tag EXCLUDE_TAGS] [--pdb] [-b]
                      [--no-faulthandler] [--timing] [-k TEST_NAME_PATTERNS]
                      [--version] [-v {0,1,2,3}] [--settings SETTINGS]
                      [--pythonpath PYTHONPATH] [--traceback] [--no-color]
                      [--force-color]
                      [test_label ...]

Discover and run tests in the specified modules or the current directory.

positional arguments:
  test_label            Module paths to test; can be modulename,
                        modulename.TestCase or modulename.TestCase.test_method

options:
  -h, --help            show this help message and exit
  --noinput, --no-input
                        Tells Django to NOT prompt the user for input of any
                        kind.
  --failfast            Tells Django to stop running the test suite after
                        first failed test.
  --testrunner TESTRUNNER
                        Tells Django to use specified test runner class
                        instead of the one specified by the TEST_RUNNER
                        setting.
  -t TOP_LEVEL, --top-level-directory TOP_LEVEL
                        Top level of project for unittest discovery.
  -p PATTERN, --pattern PATTERN
                        The test matching pattern. Defaults to test*.py.
  --keepdb              Preserves the test DB between runs.
  --shuffle [SEED]      Shuffles test case order.
  -r, --reverse         Reverses test case order.
  --debug-mode          Sets settings.DEBUG to True.
  -d, --debug-sql       Prints logged SQL queries on failure.
  --parallel [N]        Run tests using up to N parallel processes. Use the
                        value "auto" to run one test process for each
                        processor core.
  --tag TAGS            Run only tests with the specified tag. Can be used
                        multiple times.
  --exclude-tag EXCLUDE_TAGS
                        Do not run tests with the specified tag. Can be used
                        multiple times.
  --pdb                 Runs a debugger (pdb, or ipdb if installed) on error
                        or failure.
  -b, --buffer          Discard output from passing tests.
  --no-faulthandler     Disables the Python faulthandler module during tests.
  --timing              Output timings, including database set up and total
                        run time.
  -k TEST_NAME_PATTERNS
                        Only run test methods and classes that match the
                        pattern or substring. Can be used multiple times. Same
                        as unittest -k option.
  --version             Show program's version number and exit.
  -v {0,1,2,3}, --verbosity {0,1,2,3}
                        Verbosity level; 0=minimal output, 1=normal output,
                        2=verbose output, 3=very verbose output
  --settings SETTINGS   The Python path to a settings module, e.g.
                        "myproject.settings.main". If this isn't provided, the
                        DJANGO_SETTINGS_MODULE environment variable will be
                        used.
  --pythonpath PYTHONPATH
                        A directory to add to the Python path, e.g.
                        "/home/djangoprojects/myproject".
  --traceback           Raise on CommandError exceptions.
  --no-color            Don't colorize the command output.
  --force-color         Force colorization of the command output.
```

### 运行测试实例

`pmg test word.test_dict.DictTestCase --keepdb --verbosity 2`

*   `pmg=python manage.py`
*   `word.test_dict.DictTestCase`表示被测试的目标(这里是一个整个类)
*   `--verbosity 2`指定需要显示的测试过程信息

```plaintext
PS D:\repos\ELA\backEnd\ela&gt; pmg test  word.test_dict.DictTestCase --keepdb --verbosity 2
Found 5 test(s).
Using existing test database for alias 'default' ('test_ela4')...
Operations to perform:
  Synchronize unmigrated apps: coreapi, django_filters, drf_yasg, messages, rest_framework, staticfiles
  Apply all migrations: admin, auth, contenttypes, polls, scoreImprover, sessions, user, word
Synchronizing apps without migrations:
  Creating tables...
    Running deferred SQL...
Running migrations:
  Applying user.0019_alter_user_examdate_alter_user_name_and_more... OK
System check identified no issues (0 silenced).
test_demo (word.test_dict.DictTestCase) ... ['apple', 'ˈæp(ə)l', 'apples', 'NULL', 'NULL', 'NULL', 'NULL', "['n. 苹果']"]
@test_url /word/test/
{'spelling': 'apple', 'phnetic': 'ˈæp(ə)l', 'explains': "['n. 苹果']"}
@res.type: <class 'dict'="">
@res <response status_code="200," "application="" json"="">
@res.data {'spelling': 'apple', 'phnetic': 'ˈæp(ə)l', 'explains': "['n. 苹果']"}
ok
test_false_is_true (word.test_dict.DictTestCase) ... Method: test_false_is_true.
ok
test_no_explain (word.test_dict.DictTestCase) ... ok
test_one_plus_one_equals_two (word.test_dict.DictTestCase) ... Method: test_one_plus_one_equals_two.
ok
test_reverse (word.test_dict.DictTestCase) ... @type_res: <class 'rest_framework.response.response'="">
@res.content {"detail":"Not found."}
@type_res_list: <class 'django.http.response.httpresponsepermanentredirect'="">
@res.content_list
ok

----------------------------------------------------------------------
Ran 5 tests in 1.358s

OK
Preserving test database for alias 'default' ('test_ela4')...
```

#### verbosity=3

```plaintext
PS D:\repos\ELA\backEnd\ela&gt; pmg test  word.test_dict.DictTestCase --keepdb --verbosity 3
Found 5 test(s).
Using existing test database for alias 'default' ('test_ela4')...
Operations to perform:
  Synchronize unmigrated apps: coreapi, django_filters, drf_yasg, messages, rest_framework, staticfiles
  Apply all migrations: admin, auth, contenttypes, polls, scoreImprover, sessions, user, word
Running pre-migrate handlers for application main
Running pre-migrate handlers for application scoreImprover
Running pre-migrate handlers for application word
Running pre-migrate handlers for application user
Running pre-migrate handlers for application admin
Running pre-migrate handlers for application polls
Running pre-migrate handlers for application auth
Running pre-migrate handlers for application contenttypes
Running pre-migrate handlers for application sessions
Synchronizing apps without migrations:
  Creating tables...
    Running deferred SQL...
Running migrations:
  No migrations to apply.
Running post-migrate handlers for application main
Running post-migrate handlers for application scoreImprover
Running post-migrate handlers for application word
Running post-migrate handlers for application user
Running post-migrate handlers for application admin
Running post-migrate handlers for application polls
Running post-migrate handlers for application auth
Running post-migrate handlers for application contenttypes
Running post-migrate handlers for application sessions
System check identified no issues (0 silenced).
test_demo (word.test_dict.DictTestCase) ... ['apple', 'ˈæp(ə)l', 'apples', 'NULL', 'NULL', 'NULL', 'NULL', "['n. 苹果']"]
@test_url /word/test/
{'spelling': 'apple', 'phnetic': 'ˈæp(ə)l', 'explains': "['n. 苹果']"}
@res.type: <class 'dict'="">
@res <response status_code="200," "application="" json"="">
@res.data {'spelling': 'apple', 'phnetic': 'ˈæp(ə)l', 'explains': "['n. 苹果']"}
ok
test_false_is_true (word.test_dict.DictTestCase) ... Method: test_false_is_true.
ok
test_no_explain (word.test_dict.DictTestCase) ... ok
test_one_plus_one_equals_two (word.test_dict.DictTestCase) ... Method: test_one_plus_one_equals_two.
ok
test_reverse (word.test_dict.DictTestCase) ... @type_res: <class 'rest_framework.response.response'="">
@res.content {"detail":"Not found."}
@type_res_list: <class 'django.http.response.httpresponsepermanentredirect'="">
@res.content_list
ok

----------------------------------------------------------------------
Ran 5 tests in 1.278s

OK
Preserving test database for alias 'default' ('test_ela4')...
PS D:\repos\ELA\backEnd\ela&gt; 
```

### 在测试中创建测试数据setUpTestData()&setUp()

- `setUpTestData()` 用于<u>类级别设置</u>，在测试运行开始的时侯，会调用一次。您可以使用它来创建`在任何测试方法`中，都`不会修改或更改的对象`。
- `setUp()` 在每个`测试函数之前`被调用，以`设置可能被测试修改的`任何对象（每个测试函数，都将获得这些对象的 “新” 版本）

- [TestCase 类的相关wen'daDjango (djangoproject.com)](https://docs.djangoproject.com/en/4.0/topics/testing/tools/#django.test.TestCase.setUpTestData)




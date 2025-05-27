[toc]



```bash
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   ls
dd1  wp
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   tree -L 2
.
├── dd1
│   ├── x1
│   └── y2
└── wp
    ├── dd1
    ├── tt
    └── wp-config.php

4 directories, 4 files
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   tree -L 3
.
├── dd1
│   ├── x1
│   └── y2
└── wp
    ├── dd1
    │   ├── a.sh
    │   ├── b.sh
    │   ├── c.sh
    │   ├── good.sh
    │   └── xix.sh
    ├── tt
    └── wp-config.php

4 directories, 9 files
#( 05/27/25@10:24AM )( cxxu@CxxuDesk ):~
   mv dd1 wp/          
mv: cannot overwrite 'wp/dd1': Directory not empty
#( 05/27/25@10:25AM )( cxxu@CxxuDesk ):~
   mv dd1 wp/dd1
#( 05/27/25@10:25AM )( cxxu@CxxuDesk ):~
   tree -L 3    
.
└── wp
    ├── dd1
    │   ├── a.sh
    │   ├── b.sh
    │   ├── c.sh
    │   ├── dd1
    │   ├── good.sh
    │   └── xix.sh
    ├── tt
    └── wp-config.php

4 directories, 7 files
```


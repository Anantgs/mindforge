🔍 1. Find files by name

```
find /path/to/search -name "filename.txt"

```

use:

```
find . -name "report.txt"

```

2. Find files by extension

```
find /path/to/search -name "*.txt"

```

use:

```
find . -name "*.txt"

```

3. Find files by size

```
find /path/to/search -size 100c

```

use:

```
find . -size 100c

```

4. Find files by owner

```
find /path/to/search -user username

```

use:

```
find . -user username

```

5. Find files by group

```
find /path/to/search -group groupname

```

use:

```
find . -group groupname

```

6. Find files and execute a command (e.g., delete)

```
find . -name "*.tmp" -exec rm {} \;

```

use:

```
find . -name "*.tmp" -exec rm {} \;

```

7. Find files by type

```
find /path/to/search -type d

```

use:

```
find . -type d

```

8. Find files by modification time

```
find /path/to/search -mtime -7

```

use:

```
find . -mtime -7

```

9.  Delete .log files older than 7 days

```
find /path/to/search -name "*.log" -mtime +7 -exec rm {} \;

```

use:

```
find . -name "*.log" -mtime +7 -exec rm {} \;

```

10. Delete large log files (> 500MB)

```
find /var/log -type f -name "*.log" -size +500M -exec rm -f {} \;

```

11. Find a file and compress them 

```
find /var/log -type f -name "*.log" -mtime +3 -exec gzip {} \;

```
## Symbols

In the wild, one might come across the following symbols: @, %, and < when it comes to makefiles. Below there is a little table with some symbols that one would find.

| Symbol | Meaning                               | Examples                            |
| ------ | ------------------------------------- | ----------------------------------- |
| `%`    | Wildcard/placeholder in pattern rules | `$(OBJDIR)/%.o: $(SRCDIR)/%.cpp`    |
| `$<`   | First prerequisite (dependency)       | `c++ -c $<` → `c++ -c src/main.cpp` |
| `$@`   | The target of the rule                | `-o $@` → `-o obj/main.o`           |
| `$`    | Variables reference                   | `$(OBJDIR)`, `$(SRCDIR)` `$(NAME)`  |

## **Baby's first Makefile**

### 1. General structure:

A Makefile consists of the three:

- **Targets**: the name of the goal you want to achieve (e.g., `all`, `clean`...);
- **Dependencies**: The files that the target depends on;
- **Commands**: The shell commands that run when the target is invoked;

Something that looks like this:

```Makefile
target: dependencies
	command
```
_Note: Make uses tabs, not spaces, for the command lines_

### 2. The _all_ rule:

To make a simple Makefile, first we need a program. Therefore, we will use this in a `main.cpp` file:

```cpp
#include <iostream>

int main(void) 
{
    std::cout << "Hello, World!" << std::endl;
    return (0);
}
```

In case you never touched c++ (cpp) and completely scared of its syntax, it does the exact same thing as:

```c
#include <stdio.h>

int main(void)
{
	printf("Hello world\n");
	return (0);
}
```

Now, in our Makefile the syntax would look like this:

```makefile
all:
	c++ -Wall -Wextra -Werror -pedantic -std=c++98 main.cpp -o str
```

This simple Makefile will compile `main.cpp` into an executable named `str`. Why? Because the `-o` flag will tell the compiler that we have a name for that thing you are compiling.

### 3. Using variables:

Obviously our previous rule is quite ineffective when it comes to multiple files. You won't be able to keep finding out the name of the files, and therefore it will become a nightmare soon enough if you don't use **variables**.

What are variables? Simple. Variables are just a way of generally defining a set of dependencies to a target that can also be defined by a variable. Wow, lots of words.

What the hell did I just say? Simple:

```makefile
NAME = str
COMPILER = c++
COMPILERFLAGS = -Wall -Wextra -Werror -pedantic -std=c++98
SRCS = main.cpp

all:
	$(COMP) $(COMPFLAGS) $(SRCS) -o $(NAME)
```
_Note: when defining all, imagine that you are writing it down in the terminal like old times `cc -Wall -Wextra -Werror filename.c -o executable_name`_

Our Makefile takes a bit of shape now. But lets get back at those big fancy words that we used. So, when I spoke about defining a set of dependencies, I meant that we were doing lines like `NAME = str`, `COMP = c++`, `SRCS = src/main.cpp`, and so son. Which is just like how we define variables inside our program, right? It's barely different from `int i = 0`. 

Also, you might have wondered where you shove the rest of the files. Fret not, you can add them manually inside the `SRCS` variable.

### 4. Stop objectifying me


### 5. GO CLEAN YOUR ~~ROOM~~ DIRECTORY!

No self-respecting Makefile would be complete without the `clean`,`fclean` and `re` rules. But what is the difference between them?

- `clean`: removes all files but the executable;
- `fclean`: removes everything, executable included;
- `re`: cleans the whole directory and runs `all` again.

OK, and how do we write them in our Makefile? Something like this:

```makefile
clean:
	@rm -f $(SRCDIR)/*.o

fclean: clean
	@rm -f $(NAME)

re: fclean all
```

You managed to get as far as to already make your files and setting up rules to delete them all in a snap. As you can see, the formatting of the rules remains the same at all time, and now we have one last thing: take away all those phonies!

### 6. You're just a .PHONY

What even is that? the `.PHONY` tells Make that these targets aren't actual files but rather actions to perform. You need to add this at the end of your Makefile:

```makefile
.PHONY: all clean fclean re
```

why use phony `.PHONY`?

- **Avoiding Name Conflicts**:
    - If you have a target named `clean` and also happen to have a file named `clean` in your directory, running `make clean` would do nothing because `make` thinks `clean` is up-to-date (i.e., the file exists).
    - By declaring `clean` as a phony target, `make` will always run the clean commands, regardless of whether a file named `clean` exists.
-  **Ensuring Consistent Behavior**:
    - Phony targets guarantee that the commands associated with them are executed every time you call them. This is especially important for targets like `clean`, `install`, or `all`, which are used to manage the build process rather than producing a file.

### 5. Can I has  Makefile?

With this information, we should be able to write down a Makefile! This is how the final product is going to look like:

```makefile
NAME = str
COMPILER = c++
COMPILERFLAGS = -Wall -Wextra -Werror -pedantic -std=c++98
SRCS = main.cpp
OBJS = $(SRCS: .cpp=.o)

all: $(NAME)

$(NAME): $(OBJSS)
	$(COMPILER) $(COMPILERFLAGS) $(OBJS) -o $(NAME)

%.o: %.cpp
	$(COMPILER) $(COMPILERFLAGS) -c $< -o $@

clean:
	@rm -f *.o

fclean: clean
	@rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re
```


This is how it looks like in terminal:

```shell
 fdessoy@fdessoy-420  ~/projects  cd makefile_tutorial 
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  ls -la
total 16
drwxrwxr-x 2 fdessoy fdessoy 4096 Sep 25 11:58 .
drwxrwxr-x 5 fdessoy fdessoy 4096 Sep 25 11:57 ..
-rw-rw-r-- 1 fdessoy fdessoy  103 Sep 25 11:58 main.cpp
-rw-rw-r-- 1 fdessoy fdessoy  356 Sep 25 11:58 Makefile
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  make
c++ -Wall -Wextra -Werror -pedantic -std=c++98 main.cpp -o str
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  ./str
Hello, World!
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  make clean
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  ls -la     
total 32
drwxrwxr-x 2 fdessoy fdessoy  4096 Sep 25 11:59 .
drwxrwxr-x 5 fdessoy fdessoy  4096 Sep 25 11:57 ..
-rw-rw-r-- 1 fdessoy fdessoy   103 Sep 25 11:58 main.cpp
-rw-rw-r-- 1 fdessoy fdessoy   356 Sep 25 11:58 Makefile
-rwxrwxr-x 1 fdessoy fdessoy 16264 Sep 25 11:59 str
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  make fclean
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  ls -la
total 16
drwxrwxr-x 2 fdessoy fdessoy 4096 Sep 25 11:59 .
drwxrwxr-x 5 fdessoy fdessoy 4096 Sep 25 11:57 ..
-rw-rw-r-- 1 fdessoy fdessoy  103 Sep 25 11:58 main.cpp
-rw-rw-r-- 1 fdessoy fdessoy  356 Sep 25 11:58 Makefile
 fdessoy@fdessoy-420  ~/projects/makefile_tutorial  
```

If this was a "mucho texto"/TL;DR moment for you, here's the breakdown:

1. we ran `make`;
2. executable was made;
3. ran the executable and got `Hello, World!` outputted to the console/terminal;
4. we ran `make clean` which cleaned the files;
5. verified that everything was cleaned running `ls -la`;
6. ran `make fclean` to remove the executable `str`;
7. ran `ls -la` one more time to check if our directory was empty.

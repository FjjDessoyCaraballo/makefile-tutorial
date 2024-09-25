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

In this step we are going to cut directly to our Makefile. I have my reasons:

```makefile
NAME = str 
COMPILER = c++ 
COMPILERFLAGS = -Wall -Wextra -Werror -pedantic -std=c++98 
SRCS = main.cpp 
OBJS = $(SRCS:.cpp=.o)

all: $(NAME) 
	$(NAME): $(OBJS) $(COMPILER) $(COMPILERFLAGS) $(OBJS) -o $(NAME) 
	
%.o: %.cpp
	$(COMPILER) $(COMPILERFLAGS) -c $< -o $@
```

I know you're thinking "what in the seven hells is this?!". Do not worry, I will be going through each new part thoroughly and talk about objects also.

Lets go through the boring theoretical part first: objects. What are object files?

- **Object files** are the result of the **compilation** step when you compile your C/C++ code.
- They have a `.o` extension on Unix-like systems (Linux, mac OS) and `.obj` on Windows.
- An object file contains the **machine code** translated from your source code, as well as other necessary information such as symbol definitions (functions and variables) and references to other symbols that the file depends on.

In other words, it's more machine-readable stuff for our little 'puter friends! With that said, the next questions would be "ok, I still have no idea what those new lines you wrote mean", and, again, don't worry.

```makefile
OBJS = $(SRCS:.cpp=.o)
```

The previous line is using _substitution reference_, very fancy. In other words, it makes a copy of the files with the ending `.cpp` to object files with `.o` ending. That's mostly it.

The catch here is that we used our `SRCS`, so keep that in mind. This means that everything that was referenced in our variable `SRCS` with `.cpp` files will be turned into `.o` files.

```makefile
%.o: %.cpp
	$(COMPILER) $(COMPILERFLAGS) -c $< -o $@
```

Now, this one is using what we call _pattern rule_, another very fancy phrase. However, unlike the past line, there is a bit more to it:

- **`%.o`**: This specifies the target pattern. The `%` acts as a wildcard that matches any stem (file name without an extension). So, `%.o` means "any `.o` file."

- **`%.cpp`**: This specifies the prerequisite pattern. It matches any `.cpp` file that corresponds to the object file being created.

So the `%` operand works in the same way as the `*` operand that we use in terminal to fetch all corresponding cases. For more information on these operands, there is a table at the end of this README. Going further into the command under the rule:

```makefile
	$(COMPILER) $(COMPILERFLAGS) -c $< -o $@
```

- **`$(COMPILER)`**: This is the variable holding the name of the compiler, which is defined earlier in your Makefile (e.g., `c++`).
- **`$(COMPILERFLAGS)`**: This variable holds the flags you want to pass to the compiler (like `-Wall`, `-Wextra`, etc.).
- **`-c`**: This option tells the compiler to compile the source file into an object file without linking.
- **`$<`**: This is an automatic variable in Make that refers to the first prerequisite of the rule. In this case, it would be the corresponding `.cpp` file (e.g., `main.cpp` for `main.o`).
- **`-o $@`**: This option specifies the output file name:
    - **`$@`**: This is another automatic variable that refers to the target of the rule. In this case, it would be the `.o` file being created (e.g., `main.o`).

**TL;DR for this section**
- **`OBJS = $(SRCS:.cpp=.o)`** generates a list of object files based on the source files.
- The pattern rule **`%.o: %.cpp`** specifies how to build an object file from a source file, with the command using automatic variables to streamline the process.

### 5. GO CLEAN YOUR ~~ROOM~~ DIRECTORY!

No self-respecting Makefile would be complete without the `clean`,`fclean` and `re` rules. But what is the difference between them?

- `clean`: removes all files but the executable;
- `fclean`: removes everything, executable included;
- `re`: cleans the whole directory and runs `all` again.

OK, and how do we write them in our Makefile? Something like this:

```makefile
NAME = str 
COMPILER = c++ 
COMPILERFLAGS = -Wall -Wextra -Werror -pedantic -std=c++98 
SRCS = main.cpp 
OBJS = $(SRCS:.cpp=.o)

all: $(NAME) 
	$(NAME): $(OBJS) $(COMPILER) $(COMPILERFLAGS) $(OBJS) -o $(NAME)
	
%.o: %.cpp
	$(COMPILER) $(COMPILERFLAGS) -c $< -o $@

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

### Extra: Symbols

In the wild, one might come across the following symbols: @, %, and < when it comes to Makefile. Below there is a little table with some symbols that one would find.

| Symbol | Meaning                               | Examples                            |
| ------ | ------------------------------------- | ----------------------------------- |
| `%`    | Wildcard/placeholder in pattern rules | `$(OBJDIR)/%.o: $(SRCDIR)/%.cpp`    |
| `$<`   | First prerequisite (dependency)       | `c++ -c $<` → `c++ -c src/main.cpp` |
| `$@`   | The target of the rule                | `-o $@` → `-o obj/main.o`           |
| `$`    | Variables reference                   | `$(OBJDIR)`, `$(SRCDIR)` `$(NAME)`  |

### Extra: helpful output

When it comes to terminal, messages will be the essence to understand what the seven hells is going on. If your stuff never outputs anything saying if it either failed, or worked, it can quickly become confusing. Same thing applies to our Makefile! So how about we put some messages so we know what is going on?

Below we are going to edit one section and the rest will be on you to take it further in your Makefile. We are going to set a message for the `make clean` command that will be outputted to the terminal/console:

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
	@echo "removing objects" <-- we added this line

fclean: clean
	@rm -f $(NAME)
	@echo "removing executable file" <-- we added this line

re: fclean all

.PHONY: all clean fclean re
```

Wait a minute, there are two new lines of code! Well, I lied and I've put another message for the `make fclean`. Life is full of disappointments and I just delivered another one to you by not sticking to my word. Get used to it.

Jokes aside, we used the command `echo` to output the string `"removing objects"` and `"removing executable file"` in our `clean` and `fclean` rules. This is a simple trick, but it greatly enhances your ability to differentiate what is going on in the terminal:

```shell

fdessoy@fdessoy-420  ~/projects/tutorial   main  make
c++ -Wall -Wextra -Werror -pedantic -std=c++98 main.cpp -o str
fdessoy@fdessoy-420  ~/projects/tutorial   main ±  make fclean
removing objects
removing executable file
fdessoy@fdessoy-420  ~/projects/tutorial   main ±  make
c++ -Wall -Wextra -Werror -pedantic -std=c++98 main.cpp -o str
fdessoy@fdessoy-420  ~/projects/tutorial   main ±  make clean
removing objects
fdessoy@fdessoy-420  ~/projects/tutorial   main ±  ls -la
total 44
drwxrwxr-x 3 fdessoy fdessoy 4096 Sep 25 12:51 .
drwxrwxr-x 6 fdessoy fdessoy 4096 Sep 25 12:07 ..
drwxrwxr-x 8 fdessoy fdessoy 4096 Sep 25 12:50 .git
-rw-rw-r-- 1 fdessoy fdessoy 103 Sep 25 12:07 main.cpp
-rw-rw-r-- 1 fdessoy fdessoy 416 Sep 25 12:50 Makefile
-rw-rw-r-- 1 fdessoy fdessoy 7293 Sep 25 12:07 README.md
-rwxrwxr-x 1 fdessoy fdessoy 16264 Sep 25 12:51 str
fdessoy@fdessoy-420  ~/projects/tutorial   main ± 
```

As you can see, with those simple lines we managed to get some helpful messages to the terminal. Also, it looks cool, right?

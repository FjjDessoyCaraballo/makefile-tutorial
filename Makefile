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
	@echo "removing object files"

fclean: clean
	@rm -f $(NAME)
	@echo "removing executable file"

re: fclean all

.PHONY: all clean fclean re

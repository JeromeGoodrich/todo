# todo

# Running the program

1. clone the repo or download it
2. navigate to the root directory "todo"
3. type ./todo and hit return to run the program

# Commands

*create*, *new*, *c*, or *n* will create a new list in the lists directory.
Example: `c -l new_list`

*add* or *a* will add a task to a specified list
Example: `add -t do laundry -l new_list`
-- note if a task or file has multiple words use " " or _

*done* will complete a task and mark it with an 'X' on the list
Example: `done -t do laundry -l new_list`

*delete* or *d* will delete a task and remove it from the list
Example: `delete -t do laundry  -l new_list`

*show* or *s* will show the contents of a specified list
Example: `s -l new_list`

*delete_list* or *dl* will delete a specified list
Example: `dl -l new_list`

*save* will save your list to a printable txt file
Example: `save -l new_list`

# Options

*-l* or *--list* specifies the list you are creating or altering

*-t* or *--task* specifies the task you are creating or altering

*-h* or *--help* provides a list of all the commands and options


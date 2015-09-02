#include <iostream>
#include "todo.hpp"

#include <stdio.h>
#include <sqlite3.h>
#include <string>
#include "todo_list_impl.hpp"

void print_todos(todolist::TodoListImpl tdl) {
    std::vector<todolist::Todo> todos = tdl.get_todos();
    for (auto & element : todos) {
        std::cout << element.id << ". " << element.label << " (" << element.completed << ")\n";
    }
}

int main(int argc, char **argv){
    
    // instantiate our C++ implementation
    todolist::TodoListImpl tdl = todolist::TodoListImpl();
    
    // print the initial list
    std::cout << "Initial Todos:\n";
    print_todos(tdl);
    
    // add a thing
    std::string myThing = "New Todo";
    int newId = tdl.add_todo(myThing);
    
    // show updated todos
    std::cout << "\nTodo Added:\n";
    print_todos(tdl);
    
    // update the new thing's status to complete
    tdl.update_todo_completed(newId, 1);
    
    // show updated todos
    std::cout << "\nTodo Completed:\n";
    print_todos(tdl);
    
    // delete the thing
    tdl.delete_todo(newId);
    
    // show updated todos
    std::cout << "\nTodo Deleted:\n";
    print_todos(tdl);
    
    return 0;
    
}


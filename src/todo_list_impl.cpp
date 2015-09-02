#include "todo_list_impl.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <sqlite3.h>
  
namespace todolist {
    
    sqlite3 *db;
    char *zErrMsg = 0;
    int rc;
    std::string sql;
  
    std::shared_ptr<TodoList> TodoList::create() {
        return std::make_shared<TodoListImpl>();
    }
    
    TodoListImpl::TodoListImpl() {
        _setup_db();
    }
  
    std::vector<Todo> TodoListImpl::get_todos() {
        
        sqlite3_stmt *statement;
        std::vector<Todo> todos;
        
        // get all records
        sql = "SELECT * FROM todos";
        if(sqlite3_prepare_v2(db, sql.c_str(), (sizeof(sql)+1), &statement, 0) == SQLITE_OK) {
            int result = 0;
            while(true) {
                result = sqlite3_step(statement);
                if(result == SQLITE_ROW) {
                    
                    int32_t id = sqlite3_column_int(statement, 0);
                    std::string label = (char*)sqlite3_column_text(statement, 1);
                    std::string status_string = (char*)sqlite3_column_text(statement, 2);
                    TodoStatus status;
                    if (status_string == "COMPLETE") {
                        status = TodoStatus::COMPLETE;
                    } else {
                        status = TodoStatus::INCOMPLETE;
                    }
                    
                    Todo temp_todo = {
                        id,
                        label,
                        status
                    };
                    todos.push_back(temp_todo);
                    
                } else {
                    break;
                }
            }
            sqlite3_finalize(statement);

        }
        
        return todos;
    }
    
    int32_t TodoListImpl::add_todo(const std::string & label) {
  
        // add a record
        sql = "INSERT INTO todos (label, status) "  \
            "VALUES ('" + label + "', 'INCOMPLETE'); ";
        _handle_query(sql);
        
        int32_t rowId = (int)sqlite3_last_insert_rowid(db);
        
        return rowId;
  
    }
    
    bool TodoListImpl::update_todo_status(int32_t id, TodoStatus status) {
        
        std::string statusString = "INCOMPLETE";
        if (status == TodoStatus::COMPLETE) {
            statusString = "COMPLETE";
        }
        
        // update a record's status
        sql = "UPDATE todos SET status = '" + statusString + "' WHERE id = " + std::to_string(id) + ";";
        _handle_query(sql);
        
        return 1;
        
    }
    
    bool TodoListImpl::delete_todo(int32_t id) {
        
        // delete a record
        sql = "DELETE FROM todos WHERE id = " + std::to_string(id) + ";";
        _handle_query(sql);
        
        return 1;
        
    }
    
    // Wrapper to handle errors, etc on common queries.
    void TodoListImpl::_handle_query(std::string sql) {
        
        
        rc = sqlite3_exec(db, sql.c_str(), 0, 0, &zErrMsg);
        if(rc != SQLITE_OK){
            fprintf(stderr, "SQL error: %s\n", zErrMsg);
            sqlite3_free(zErrMsg);
            return;
        } else {
            
        }
    }
    
    void TodoListImpl::_setup_db() {
        
        // open the database, create it if necessary
        rc = sqlite3_open_v2("todo.db", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
        
        if( rc ){
            fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
            sqlite3_close(db);
            return;
        } else {
            
        }
        
        // check if the table exists already
        // if not, create it and insert some data
        sql = "SELECT name FROM sqlite_master WHERE type='table' AND name='todos'";
        _handle_query(sql);
        
        sql = "CREATE TABLE IF NOT EXISTS todos("  \
            "id INTEGER PRIMARY KEY AUTOINCREMENT    NOT NULL," \
            "label          TEXT    NOT NULL," \
            "status         INT     NOT NULL);";
        _handle_query(sql);
        
        sql = "INSERT INTO todos (label, status) "  \
            "VALUES ('Learn C++', 'COMPLETE'); " \
            "INSERT INTO todos (label, status) "  \
            "VALUES ('Learn Djinni', 'COMPLETE'); "     \
            "INSERT INTO todos (label, status)" \
            "VALUES ('Write Some Tutorials', 'COMPLETE');" \
            "INSERT INTO todos (label, status)" \
            "VALUES ('Build Some Apps', 'INCOMPLETE');" \
            "INSERT INTO todos (label, status)" \
            "VALUES ('Profit', 'INCOMPLETE');";
        _handle_query(sql);

    }
  
}
#include "todo_list_impl.hpp"
#include <iostream>
#include <string>
#include <vector>
#include <sqlite3.h>
  
namespace todolist {
    
    std::string _path;
    sqlite3 *db;
    char *zErrMsg = 0;
    int rc;
    std::string sql;
    sqlite3_stmt *statement;
  
    std::shared_ptr<TodoList> TodoList::create_with_path(const std::string & path) {
        return std::make_shared<TodoListImpl>(path);
    }
    
    TodoListImpl::TodoListImpl(const std::string & path) {
        _path = path + "/todo.db";
        _setup_db();
    }
  
    std::vector<Todo> TodoListImpl::get_todos() {
        
        std::vector<Todo> todos;
        
        // get all records
        sql = "SELECT * FROM todos";
        if(sqlite3_prepare_v2(db, sql.c_str(), sql.length()+1, &statement, 0) == SQLITE_OK) {
            int result = 0;
            while(true) {
                result = sqlite3_step(statement);
                if(result == SQLITE_ROW) {
                    
                    int32_t id = sqlite3_column_int(statement, 0);
                    std::string label = (char*)sqlite3_column_text(statement, 1);
                    int32_t completed = sqlite3_column_int(statement, 2);
                    
                    Todo temp_todo = {
                        id,
                        label,
                        completed
                    };
                    todos.push_back(temp_todo);
                    
                } else {
                    break;
                }
            }
            sqlite3_finalize(statement);

        } else {
            auto error = sqlite3_errmsg(db);
            if (error!=nullptr) printf("Error: %s", error);
            else printf("Unknown Error");
        }
        
        return todos;
    }
    
    int32_t TodoListImpl::add_todo(const std::string & label) {
  
        // add a record
        sql = "INSERT INTO todos (label, completed) "  \
            "VALUES ('" + label + "', 0); ";
        _handle_query(sql);
        
        int32_t rowId = (int)sqlite3_last_insert_rowid(db);
        
        return rowId;
  
    }
    
    bool TodoListImpl::update_todo_completed(int32_t id, int32_t completed) {
        
        // update a record's status
        sql = "UPDATE todos SET completed = " + std::to_string(completed) + " " \
            "WHERE id = " + std::to_string(id) + ";";
        _handle_query(sql);
        
        return 1;
        
    }
    
    bool TodoListImpl::delete_todo(int32_t id) {
        
        // delete a record
        sql = "DELETE FROM todos WHERE id = " + std::to_string(id) + ";";
        _handle_query(sql);
        
        return 1;
        
    }
    
    // wrapper to handle errors, etc on simple queries
    void TodoListImpl::_handle_query(std::string sql) {
        rc = sqlite3_exec(db, sql.c_str(), 0, 0, &zErrMsg);
        if(rc != SQLITE_OK){
            fprintf(stderr, "SQL error: %s\n", zErrMsg);
            sqlite3_free(zErrMsg);
            return;
        }
    }
    
    void TodoListImpl::_setup_db() {
        
        // open the database, create it if necessary
        rc = sqlite3_open_v2(_path.c_str(), &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
        if(rc){
            fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
            sqlite3_close(db);
            return;
        }
        
        // create the table if it doesn't exist
        sql = "CREATE TABLE IF NOT EXISTS todos("  \
            "id INTEGER PRIMARY KEY AUTOINCREMENT    NOT NULL," \
            "label          TEXT    NOT NULL," \
            "completed         INT     NOT NULL);";
        _handle_query(sql);
        
        // check if table is empty... if so, add some data.
        sql = "SELECT * FROM todos";
        _handle_query(sql);
        if(sqlite3_prepare_v2(db, sql.c_str(), sql.length()+1, &statement, 0) == SQLITE_OK) {
            int stat = sqlite3_step(statement);
            if (stat == SQLITE_DONE) {
                // table was empty, add some data
                sql = "INSERT INTO todos (label, completed) "  \
                    "VALUES ('Learn C++', 1); " \
                    "INSERT INTO todos (label, completed) "  \
                    "VALUES ('Learn Djinni', 1); "     \
                    "INSERT INTO todos (label, completed)" \
                    "VALUES ('Write Some Tutorials', 1);" \
                    "INSERT INTO todos (label, completed)" \
                    "VALUES ('Build Some Apps', 0);" \
                    "INSERT INTO todos (label, completed)" \
                    "VALUES ('Profit', 0);";
                _handle_query(sql);
            } else {
                std::cout << "didn't add data to db\n";
            }
        } else {
            int error = sqlite3_step(statement);
            std::cout << "SQLITE not ok, error was " << error << "\n";
            
        }
        sqlite3_finalize(statement);
        
    }
  
}
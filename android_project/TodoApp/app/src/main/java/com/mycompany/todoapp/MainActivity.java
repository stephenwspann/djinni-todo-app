package com.mycompany.todoapp;

import android.app.ListActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.ListView;

import com.mycompany.todolist.Todo;
import com.mycompany.todolist.TodoList;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends ListActivity {

    private TodoList todoListInterface;
    private List<String> listValues;
    ArrayList<Todo> todos;
    private int newTodoCount = 1;


    static {
        System.loadLibrary("todoapp_jni");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listValues = new ArrayList<String>();

        String dbPath = this.getFilesDir().getAbsolutePath();
        todoListInterface = TodoList.createWithPath(dbPath);
        refreshList();

    }

    protected void refreshList() {
        todos = todoListInterface.getTodos();
        listValues = new ArrayList<String>();

        for (int i = 0; i < todos.size(); i++) {

            Todo todo = todos.get(i);

            if (todo.getCompleted() == 1) {
                listValues.add("X  " + todo.getLabel());
            } else {
                listValues.add("     " + todo.getLabel());
            }
        }

        ArrayAdapter<String> myAdapter = new ArrayAdapter <String>(this,
                R.layout.row_layout, R.id.listText, listValues);
        setListAdapter(myAdapter);

    }


    // when an item of the list is clicked
    @Override
    protected void onListItemClick(ListView list, View view, int position, long id) {

        super.onListItemClick(list, view, position, id);
        Todo selectedTodo = (Todo) todos.get(position);

        // toggle selected item
        if (selectedTodo.getCompleted() == 1) {
            todoListInterface.updateTodoCompleted(selectedTodo.getId(), 0);
        } else {
            todoListInterface.updateTodoCompleted(selectedTodo.getId(), 1);
        }

        refreshList();

    }

    public void addButtonPressed(View view) {

        todoListInterface.addTodo("New Todo " + String.valueOf(newTodoCount));
        newTodoCount++;

        refreshList();
    }


    public void deleteButtonPressed(View view) {

        ListView listView = getListView();

        final int position = listView.getPositionForView((View) view.getParent());

        // get database id
        Todo selectedTodo = (Todo) todos.get(position);

        todoListInterface.deleteTodo(selectedTodo.getId());

        refreshList();
    }

}

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

        // should be: /data/data/<package name>/databases/
        String dbPath = this.getFilesDir().getAbsolutePath();
        Log.d("STATE", dbPath);
        todoListInterface = TodoList.createWithPath(dbPath);
        refreshList();

    }

    public View getViewByPosition(int pos, ListView listView) {
        final int firstListItemPosition = listView.getFirstVisiblePosition();
        final int lastListItemPosition = firstListItemPosition + listView.getChildCount() - 1;

        if (pos < firstListItemPosition || pos > lastListItemPosition ) {
            return listView.getAdapter().getView(pos, null, listView);
        } else {
            final int childIndex = pos - firstListItemPosition;
            return listView.getChildAt(childIndex);
        }
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

        // dynamically set checkboxes
    /*
        for (int j = 0; j < listValues.size(); j++) {

            View row = getViewByPosition(j, getListView());

            row.getC

        }
        */
    }


    // when an item of the list is clicked
    @Override
    protected void onListItemClick(ListView list, View view, int position, long id) {

        Log.d("position", String.valueOf(position));

        super.onListItemClick(list, view, position, id);

        Todo selectedTodo = (Todo) todos.get(position);

        //String selectedItem = (String) getListAdapter().getItem(position);

        // toggle selected item

        if (selectedTodo.getCompleted() == 1) {
            todoListInterface.updateTodoCompleted(selectedTodo.getId(), 0);
        } else {
            todoListInterface.updateTodoCompleted(selectedTodo.getId(), 1);
        }

        refreshList();


    }

    public void checkboxPressed(View view) {

        Log.d("Log.d", "checkbox pressed");

        ListView listView = getListView();

        final int position = listView.getPositionForView((View) view.getParent());

        // get database id
        Todo selectedTodo = (Todo) todos.get(position);

        if (selectedTodo.getCompleted() == 1) {
            todoListInterface.updateTodoCompleted(selectedTodo.getId(), 0);
        } else {
            todoListInterface.updateTodoCompleted(selectedTodo.getId(), 1);
        }

        CheckBox cb = (CheckBox) view;
        cb.setChecked(!cb.isChecked());


        refreshList();
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void addButtonPressed(View view) {

        Log.d("Button", "add button pressed");

        todoListInterface.addTodo("New Todo " + String.valueOf(newTodoCount));
        newTodoCount++;

        refreshList();
    }


    public void deleteButtonPressed(View view) {

        Log.d("Log.d", "delete button pressed");

        ListView listView = getListView();

        final int position = listView.getPositionForView((View) view.getParent());

        // get database id
        Todo selectedTodo = (Todo) todos.get(position);

        todoListInterface.deleteTodo(selectedTodo.getId());

        refreshList();
    }

}

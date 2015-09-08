package com.mycompany.todoapp;

import android.content.Context;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.mycompany.todolist.Todo;
import com.mycompany.todolist.TodoList;

import java.util.ArrayList;

public class MainActivity extends AppCompatActivity {

    private TodoList todoListInterface;

    static {
        System.loadLibrary("todoapp_jni");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // get the application context and DB path
        //Context context = getApplicationContext();

        // should be: /data/data/<package name>/databases/
        String dbPath = this.getFilesDir().getAbsolutePath();
        Log.d("STATE", dbPath);
        todoListInterface = TodoList.createWithPath(dbPath);
        ArrayList<Todo> todos = todoListInterface.getTodos();

        Log.d("STATE", "onCreate");
        Log.d("STATE", "todos.size(): " + todos.size());

        for (int i = 0; i < todos.size(); i++) {
            Log.d("STATE", todos.get(i).getLabel());
        }

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
}

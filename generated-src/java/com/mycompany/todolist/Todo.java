// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from todolist.djinni

package com.mycompany.todolist;

public final class Todo {


    /*package*/ final int mId;

    /*package*/ final String mLabel;

    /*package*/ final TodoStatus mStatus;

    public Todo(
            int id,
            String label,
            TodoStatus status) {
        this.mId = id;
        this.mLabel = label;
        this.mStatus = status;
    }

    public int getId() {
        return mId;
    }

    public String getLabel() {
        return mLabel;
    }

    public TodoStatus getStatus() {
        return mStatus;
    }
}